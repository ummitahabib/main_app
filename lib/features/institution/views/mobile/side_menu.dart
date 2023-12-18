import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:one_context/one_context.dart';
import 'package:quiver/strings.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/color_600_text.dart';
import 'package:smat_crow/features/institution/data/controller/institution_controller.dart';
import 'package:smat_crow/features/institution/data/controller/side_navigation_provider.dart';
import 'package:smat_crow/features/organisation/views/widgets/custom_action_widget.dart';
import 'package:smat_crow/features/organisation/views/widgets/dialog_header.dart';
import 'package:smat_crow/features/shared/views/modal_stick.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/features/widgets/custom_button.dart';
import 'package:smat_crow/features/widgets/custom_text_field.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class SideMenuMobile extends StatefulHookConsumerWidget {
  const SideMenuMobile({
    super.key,
  });

  @override
  ConsumerState<SideMenuMobile> createState() => _SideMenuMobileState();
}

class _SideMenuMobileState extends ConsumerState<SideMenuMobile> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: AppColors.SmatCrowNeuOrange900,
        padding: const EdgeInsets.all(SpacingConstants.size15),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Color600Text(text: menuText),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.clear,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              const Ymargin(SpacingConstants.size40),
              TextButton(
                onPressed: () {
                  ref.read(sideNavProvider).jumpToPage(0);
                  ref.read(sideNavProvider.notifier).pageController = PageController();
                  Navigator.pop(context);
                },
                child: Text(
                  dashboardText,
                  style: ref.watch(sideNavProvider).initialPage == 0
                      ? Styles.smatCrowMediumSubParagraph(color: Colors.white)
                      : Styles.smatCrowSubParagraphRegular(color: Colors.white70),
                ),
              ),
              TextButton(
                onPressed: () {
                  ref.read(sideNavProvider).jumpToPage(1);
                  ref.read(sideNavProvider.notifier).pageController = PageController(initialPage: 1);
                  Navigator.pop(context);
                },
                child: Text(
                  organizationText,
                  style: ref.watch(sideNavProvider).initialPage == 1
                      ? Styles.smatCrowMediumSubParagraph(color: Colors.white)
                      : Styles.smatCrowSubParagraphRegular(color: Colors.white70),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  inviteOrganization(context);
                },
                child: Text(
                  sendinviteText,
                  style: Styles.smatCrowSubParagraphRegular(color: Colors.white70),
                ),
              ),
              TextButton(
                onPressed: () {
                  ref.read(sideNavProvider).jumpToPage(2);
                  ref.read(sideNavProvider.notifier).pageController = PageController(initialPage: 2);
                  Navigator.pop(context);
                },
                child: Text(
                  settingsText,
                  style: ref.watch(sideNavProvider).initialPage == 2
                      ? Styles.smatCrowMediumSubParagraph(color: Colors.white)
                      : Styles.smatCrowSubParagraphRegular(color: Colors.white70),
                ),
              ),
              const Spacer(),
              CustomButton(
                text: newOrgText,
                onPressed: () {
                  Navigator.pop(context);
                  inviteOrganization(context);
                },
                leftIcon: Icons.add,
                iconColor: Colors.white,
                color: Colors.transparent,
                borderColor: Colors.white,
                fontSize: SpacingConstants.font10,
                textColor: Colors.white,
              ),
              const Ymargin(SpacingConstants.size20),
            ],
          ),
        ),
      ),
    );
  }
}

Future<dynamic> inviteOrganization(BuildContext context) {
  final key = GlobalKey<FormState>();
  return customDialogAndModal(
    context,
    HookConsumer(
      builder: (context, ref, child) {
        final emailAdd = useTextEditingController();

        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (Responsive.isMobile(context)) const ModalStick(),
              DialogHeader(
                headText: newOrgText,
                showDivider: false,
                showIcon: !Responsive.isMobile(context),
                callback: () {
                  OneContext().popDialog();
                },
                mainAxisAlignment:
                    !Responsive.isMobile(context) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: SpacingConstants.double20,
                  vertical: SpacingConstants.double20,
                ),
                child: Form(
                  key: key,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        hintText: enterEmail,
                        validator: (arg) {
                          if (isEmpty(arg)) {
                            return emailAdressWarningText;
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        controller: emailAdd,
                        text: emailAddress,
                        type: TextFieldType.Email,
                      ),
                      const Ymargin(SpacingConstants.double20),
                      CustomButton(
                        text: sendinviteText,
                        loading: ref.watch(institutionProvider).loading,
                        onPressed: () {
                          if (FocusScope.of(context).hasFocus) {
                            FocusScope.of(context).unfocus();
                          }
                          if (key.currentState!.validate()) {
                            ref.read(institutionProvider).inviteOrganization(emailAdd.text).then((value) {
                              if (Responsive.isTablet(context)) {
                                OneContext().popDialog();
                                return;
                              }
                              Navigator.pop(context);
                            });
                          }
                        },
                      ),
                      Ymargin(MediaQuery.of(context).viewInsets.bottom)
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    ),
    Responsive.isTablet(context) || kIsWeb,
  );
}
