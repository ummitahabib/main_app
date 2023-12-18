import 'package:flutter/material.dart';
import 'package:smat_crow/network/crow/models/industries_response.dart';
import 'package:smat_crow/network/crow/models/request/create_organization.dart';
import 'package:smat_crow/network/crow/organization_operations.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/widgets/old_text_field.dart';
import 'package:smat_crow/screens/widgets/square_button.dart';
import 'package:smat_crow/utils/colors.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils/strings.dart';
import 'package:smat_crow/utils2/constants.dart';

import '../../../utils/styles.dart';

class CreateOrganizationBody extends StatefulWidget {
  const CreateOrganizationBody({Key? key}) : super(key: key);

  @override
  _CreateOrganizationBodyState createState() => _CreateOrganizationBodyState();
}

class _CreateOrganizationBodyState extends State<CreateOrganizationBody> {
  final List<GetIndustriesResponse> _industries = [];
  GetIndustriesResponse? _industry;
  TextEditingController organizationName = TextEditingController();
  TextEditingController shortDescription = TextEditingController();
  TextEditingController longDescription = TextEditingController();
  TextEditingController address = TextEditingController();
  final Pandora _pandora = Pandora();

  @override
  void initState() {
    super.initState();
    //  Provider.of<FarmManagerProvider>(context, listen: false).getAllIndustries();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting) {}
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                TextInputContainer(
                  child: _industries.isNotEmpty
                      ? DropdownButtonHideUnderline(
                          child: DropdownButton<GetIndustriesResponse>(
                            hint: const Text('Select Industry Type'),
                            value: _industry,
                            style: const TextStyle(
                              color: AppColors.signupSubHeaderGrey,
                              fontSize: 15.0,
                              fontFamily: 'NunitoSans_Regular',
                            ),
                            onChanged: (selectedItem) {
                              setState(() {
                                _industry = selectedItem!;
                              });
                            },
                            items: _industries.map((GetIndustriesResponse industry) {
                              return DropdownMenuItem<GetIndustriesResponse>(
                                value: industry,
                                child: Text(industry.name ?? ""),
                              );
                            }).toList(),
                          ),
                        )
                      : Container(),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextInputContainer(
                  child: TextField(
                    autocorrect: false,
                    controller: organizationName,
                    keyboardType: TextInputType.name,
                    style: Styles.nunitoRegularStyle(),
                    decoration: InputDecoration(
                      hintText: "Organization Name",
                      border: InputBorder.none,
                      hintStyle: Styles.nunitoRegularStyle(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextInputContainer(
                  child: TextField(
                    autocorrect: false,
                    controller: shortDescription,
                    maxLines: 2,
                    maxLength: 20,
                    keyboardType: TextInputType.multiline,
                    style: const TextStyle(
                      color: AppColors.signupSubHeaderGrey,
                      fontSize: 15.0,
                      fontFamily: 'NunitoSans_Regular',
                    ),
                    decoration: const InputDecoration(
                      hintText: "Short Description",
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontSize: 15.0,
                        color: AppColors.signupSubHeaderGrey,
                        fontFamily: 'NunitoSans_Regular',
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextInputContainer(
                  child: TextField(
                    autocorrect: false,
                    controller: longDescription,
                    maxLines: 4,
                    maxLength: 60,
                    keyboardType: TextInputType.multiline,
                    style: Styles.nunitoRegularStyle(),
                    decoration: InputDecoration(
                      hintText: "Long Description",
                      border: InputBorder.none,
                      hintStyle: Styles.nunitoRegularStyle(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextInputContainer(
                  child: TextField(
                    autocorrect: false,
                    controller: address,
                    keyboardType: TextInputType.streetAddress,
                    style: Styles.nunitoRegularStyle(),
                    decoration: InputDecoration(
                      hintText: "Address",
                      border: InputBorder.none,
                      hintStyle: Styles.nunitoRegularStyle(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SquareButton(
                  backgroundColor: AppColors.landingOrangeButton,
                  press: () {
                    _pandora.logAPPButtonClicksEvent('CREATE_ORG_BUTTON_PRESSED');
                    if (validateInputs(
                      organizationName.text,
                      shortDescription.text,
                      longDescription.text,
                      address.text,
                    )) {
                      createNewOrganization();
                    } else {
                      _pandora.showToast(
                        Errors.missingFieldsError,
                        context,
                        MessageTypes.WARNING.toString().split('.').last,
                      );
                    }
                  },
                  textColor: AppColors.landingWhiteButton,
                  text: 'Create Organization',
                ),
              ],
            ),
          ),
        );
      },
      future: Future.delayed(const Duration(seconds: 4)),
    );
  }

  bool validateInputs(
    String name,
    String shortDescription,
    String longDescription,
    String address,
  ) {
    return (name.isEmpty || shortDescription.isEmpty || longDescription.isEmpty || address.isEmpty) ? false : true;
  }

  Future<void> createNewOrganization() async {
    final createOrg = await createOrganizationForUser(
      CreateOrganizationRequest(
        name: organizationName.text,
        longDescription: longDescription.text,
        shortDescription: shortDescription.text,
        address: address.text,
        industry: _industry!.id!,
        user: USER_ID,
        image: "",
      ),
    );

    if (createOrg) {
      _pandora.reRouteUserPop(context, '/homePage', emptyString);
    } else {
      _pandora.showToast(
        'Failed to create organization',
        context,
        MessageTypes.FAILED.toString().split('.').last,
      );
    }
  }
}
