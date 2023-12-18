import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:one_context/one_context.dart';
import 'package:smat_crow/features/organisation/data/controller/map_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/site_controller.dart';
import 'package:smat_crow/features/organisation/views/widgets/dialog_container.dart';
import 'package:smat_crow/features/organisation/views/widgets/dialog_header.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/features/shared/views/modal_stick.dart';
import 'package:smat_crow/features/widgets/custom_button.dart';
import 'package:smat_crow/features/widgets/custom_text_field.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/subscription/components/subscription_model.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils/session.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

final _pandora = Pandora();

class ExportMap extends HookConsumerWidget {
  const ExportMap({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userEmail = useState<String?>(null);
    return DialogContainer(
      height: Responsive.yHeight(
        context,
        percent: Responsive.isTablet(context)
            ? SpacingConstants.size0point7
            : Responsive.isDesktop(context)
                ? SpacingConstants.size0point45
                : SpacingConstants.size0point7,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const ModalStick(),
            const SizedBox(height: SpacingConstants.size20),
            DialogHeader(
              headText: exportMap,
              callback: () {
                if (Responsive.isDesktop(context)) {
                  OneContext().popDialog();
                } else {
                  Navigator.pop(context);
                }
              },
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.isTablet(context) ? SpacingConstants.size40 : SpacingConstants.size20,
                vertical: SpacingConstants.size10,
              ),
              showDivider: Responsive.isDesktop(context),
            ),
            customSizedBoxHeight(SpacingConstants.size10),
            StatefulBuilder(
              builder: (context, setState) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.isTablet(context) ? SpacingConstants.size80 : SpacingConstants.size20,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextField(
                        hintText: "$enter $emailAddress",
                        onChanged: (val) => userEmail.value = val,
                        type: TextFieldType.Email,
                        isRequired: true,
                        keyboardType: TextInputType.emailAddress,
                        text: emailAddress,
                        labelStyle: Styles.smatCrowMediumParagraph(
                          color: AppColors.SmatCrowNeuBlue900,
                        ).copyWith(
                          fontSize: SpacingConstants.font14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      customSizedBoxHeight(SpacingConstants.size20),
                      CustomButton(
                        text: sendText,
                        onPressed: () {
                          _pandora.logAPPButtonClicksEvent(
                            'EXPORT_FIELD_MAP_BUTTON_CLICKED',
                          );
                          if (userEmail.value == null) return;
                          ref.watch(siteProvider).sheetHeight = 0.4;
                          if (ref.read(sharedProvider).userInfo!.perks.contains(AppPermissions.site_report)) {
                            setState(() {
                              Session.userEmail = userEmail.value!;
                              Session.userName = ref.read(sharedProvider).userInfo!.user.firstName;
                            });
                            if (ref.read(mapProvider).polygon.isNotEmpty) {
                              _pandora.generateKMLForPolygon(
                                'Site Area',
                                ref.read(mapProvider).siteLatLng,
                                "site",
                              );
                              if (kIsWeb) {
                                OneContext().popDialog();
                              } else {
                                Navigator.pop(context);
                              }
                            } else {
                              _pandora.showToast(
                                areaNotEmpty,
                                context,
                                MessageTypes.WARNING.toString().split('.').last,
                              );
                            }
                          } else {
                            SubscriptionModal.showSubscriptionModal(context);
                          }
                        },
                        color: AppColors.SmatCrowPrimary500,
                        fontSize: SpacingConstants.size16,
                        width: Responsive.xWidth(context),
                        height: SpacingConstants.size47,
                      ),
                      SizedBox(
                        height: Responsive.isDesktop(context)
                            ? SpacingConstants.size40
                            : MediaQuery.of(context).viewInsets.bottom,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
