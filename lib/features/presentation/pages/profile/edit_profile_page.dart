import 'package:beamer/beamer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quiver/strings.dart';
import 'package:smat_crow/features/data/data_sources/api_data_sources.dart';
import 'package:smat_crow/features/data/models/update_user_request.dart';
import 'package:smat_crow/features/domain/entities/user/user_entity.dart';
import 'package:smat_crow/features/domain/usecases/firebase_usecases/upload_image_to_storage_usecase.dart';
import 'package:smat_crow/features/presentation/provider/user_state.dart';
import 'package:smat_crow/features/presentation/widgets/custom_button.dart';
import 'package:smat_crow/features/presentation/widgets/custom_text_field.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';

import 'package:smat_crow/utils2/app_helper.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/profile_widget.dart';
import 'package:smat_crow/utils2/service_locator.dart' as di;
import 'package:smat_crow/utils2/spacing_constants.dart';

String DEFAULT_IMAGE =
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80';

class EditProfilePage extends StatefulHookConsumerWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _emailAddressController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final userProvider = ref.watch(sharedProvider).userInfo;

      if (userProvider != null) {
        setState(() {
          _firstNameController = TextEditingController(text: userProvider.user.firstName);
          _lastNameController = TextEditingController(text: userProvider.user.lastName);
          _userNameController = TextEditingController(text: userProvider.user.phone ?? "");
          _emailAddressController = TextEditingController(text: userProvider.user.email);
        });
      }
    });

    super.initState();
  }

  bool _isUpdating = false;

  Uint8List? _image;

  Future<void> selectImage() async {
    try {
      final pickedFile = await FilePicker.platform.pickFiles();

      if (pickedFile != null) {
        final bytes = pickedFile.files.first.bytes;
        setState(() {
          _image = Uint8List.fromList(bytes!);
        });
      } else {}
    } catch (e) {}
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    /// final userProvider = ref.watch(userStateProvider);
    return Scaffold(
      backgroundColor: AppColors.SmatCrowDefaultWhite,
      appBar: AppBar(
        backgroundColor: AppColors.SmatCrowDefaultWhite,
        title: const Text(editProfile),
        leading: GestureDetector(
          onTap: () {
            if (kIsWeb) {
              context.beamToReplacementNamed(ConfigRoute.mainPage);
            } else {
              Navigator.pop(context);
            }
          },
          child: const Icon(
            Icons.arrow_back_ios,
            size: SpacingConstants.size16,
          ),
        ),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: SpacingConstants.size10,
            vertical: SpacingConstants.size10,
          ),
          child: Column(
            children: [
              Center(
                child: SizedBox(
                  width: SpacingConstants.size100,
                  height: SpacingConstants.size100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(SpacingConstants.size50),
                    child: profileWidget(
                      imageUrl: DEFAULT_IMAGE,
                      image: _image,
                    ),
                  ),
                ),
              ),
              customSizedBoxHeight(SpacingConstants.size15),
              CustomTextField(
                hintText: firstNameHint,
                text: firstNameText,
                textEditingController: _firstNameController,
                type: TextFieldType.Default,
                validator: (arg) {
                  if (isEmpty(arg)) {
                    return '$firstName $cannotBeEmpty';
                  } else {
                    return null;
                  }
                },
              ),
              customSizedBoxHeight(SpacingConstants.size15),
              CustomTextField(
                hintText: lastNameHint,
                text: lastNameText,
                textEditingController: _lastNameController,
                type: TextFieldType.Default,
                validator: (arg) {
                  if (isEmpty(arg)) {
                    return '$lastName $cannotBeEmpty';
                  } else {
                    return null;
                  }
                },
              ),
              customSizedBoxHeight(SpacingConstants.size15),
              CustomTextField(
                hintText: 'Phone Number',
                text: "Phone number",
                textEditingController: _userNameController,
                type: TextFieldType.Default,
                validator: (arg) {
                  if (isEmpty(arg)) {
                    return '$phoneNumberText $cannotBeEmpty';
                  } else {
                    return null;
                  }
                },
              ),
              customSizedBoxHeight(SpacingConstants.size15),
              CustomTextField(
                hintText: emailHint,
                text: emailTextField,
                textEditingController: _emailAddressController,
                enabled: false,
                type: TextFieldType.Email,
              ),
              customSizedBoxHeight(SpacingConstants.size15),
              CustomButton(
                borderColor: AppColors.SmatCrowPrimary500,
                color: AppColors.SmatCrowPrimary500,
                text: saveChangesText,
                textColor: AppColors.SmatCrowNeuBlue900,
                width: SpacingConstants.size342,
                isLoading: ref.watch(authenticationProvider).loading,
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final request = UpdateInfoRequest(
                      firstName: _firstNameController.text,
                      lastName: _lastNameController.text,
                      phone: _userNameController.text,
                    );
                    ref.read(authenticationProvider).updateUser(request);
                  }
                },
              ),
              customSizedBoxHeight(SpacingConstants.size10),
            ],
          ),
        ),
      ),
    );
  }

  _updateUserProfileData() {
    ApplicationHelpers().trackButtonAndDeviceEvent('UPDATE_USER_PROFILE');
    setState(() => _isUpdating = true);
    if (_image == null) {
      _updateUserProfile(emptyString);
    } else {
      di.locator<UploadImageToStorageUseCase>().call(_image!, false, "profileImages").then((profileUrl) {
        _updateUserProfile(profileUrl);
      });
    }
  }

  _updateUserProfile(String profileUrl) async {
    final userProvider = ref.watch(userStateProvider);
    final user = ref.watch(sharedProvider).userInfo;
    try {
      userProvider.updateUser(
        user: UserEntity(
          uid: user!.user.id,
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          username: _userNameController.text.trim(),
          email: _emailAddressController.text.trim(),
          profileUrl: profileUrl,
        ),
      );

      _clear();
    } catch (e) {
      // Handle any errors or exceptions here
      debugPrint('Error: $e');
    }
  }

  _clear() {
    setState(() {
      _isUpdating = false;
      _firstNameController.clear();
      _lastNameController.clear();
      _userNameController.clear();
      _emailAddressController.clear();
    });
    Navigator.pop(context);
  }
}
