import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:one_context/one_context.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/site_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/site_options_controller.dart';
import 'package:smat_crow/features/organisation/views/widgets/dialog_container.dart';
import 'package:smat_crow/features/organisation/views/widgets/dialog_header.dart';
import 'package:smat_crow/features/widgets/custom_button.dart';
import 'package:smat_crow/features/widgets/custom_text_field.dart';
import 'package:smat_crow/network/crow/models/request/create_star_mission_request.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/strings.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

final _pandora = Pandora();

class SoilTest extends HookConsumerWidget {
  const SoilTest({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missionName = useState<String?>(null);
    final missionDesc = useState<String?>(null);
    return DialogContainer(
      height: Responsive.yHeight(
        context,
        percent: Responsive.isTablet(context)
            ? SpacingConstants.size0point45
            : kIsWeb
                ? SpacingConstants.size0point65
                : SpacingConstants.size0point6,
      ),
      child: Column(
        children: [
          if (!kIsWeb)
            Center(
              child: Container(
                height: SpacingConstants.size5,
                width: SpacingConstants.size70,
                margin: const EdgeInsets.only(top: SpacingConstants.size10),
                decoration: const BoxDecoration(color: AppColors.SmatCrowNeuBlue200),
              ),
            ),
          const SizedBox(
            height: kIsWeb ? SpacingConstants.size10 : SpacingConstants.size20,
          ),
          DialogHeader(
            headText: requestSoilTest,
            callback: () {
              if (kIsWeb) {
                OneContext().popDialog();
              } else {
                Navigator.pop(context);
              }
            },
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.isTablet(context) ? SpacingConstants.size40 : SpacingConstants.size20,
              vertical: SpacingConstants.size10,
            ),
            showDivider: kIsWeb,
          ),
          customSizedBoxHeight(SpacingConstants.size10),
          Container(
            height: Responsive.yHeight(
              context,
              percent: Responsive.isTablet(context)
                  ? SpacingConstants.size0point3
                  : kIsWeb
                      ? SpacingConstants.size0point5
                      : SpacingConstants.size0point45,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.isTablet(context) ? SpacingConstants.size70 : SpacingConstants.size20,
            ),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                CustomTextField(
                  hintText: "$enter $siteNameText",
                  onChanged: (val) => missionName.value = val,
                  isRequired: true,
                  text: missionNameText,
                  labelStyle: Styles.smatCrowMediumParagraph(
                    color: AppColors.SmatCrowNeuBlue900,
                  ).copyWith(
                    fontSize: SpacingConstants.font14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                customSizedBoxHeight(SpacingConstants.size20),
                CustomTextField(
                  hintText: "Enter Description",
                  onChanged: (p0) => missionDesc.value = p0,
                  text: description,
                  labelStyle: Styles.smatCrowMediumParagraph(
                    color: AppColors.SmatCrowNeuBlue900,
                  ).copyWith(
                    fontSize: SpacingConstants.font14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: SpacingConstants.size5.toInt(),
                ),
                customSizedBoxHeight(SpacingConstants.size40),
                CustomButton(
                  text: requestMissionText,
                  loading: ref.watch(siteOptionProvider).loading,
                  onPressed: () {
                    if (missionName.value == null) {
                      _pandora.showToast(
                        Errors.missingFieldsError,
                        context,
                        MessageTypes.WARNING.toString().split('.').last,
                      );
                      return;
                    }
                    _pandora.logAPPButtonClicksEvent(
                      'REQUEST_NEW_SOIL_MISSION_BUTTON_CLICKED',
                    );
                    final req = CreateMissionRequest(
                      name: missionName.value!,
                      description: missionDesc.value ?? emptyString,
                      organization: ref.read(organizationProvider).organization!.id ?? "",
                      site: ref.read(siteProvider).site!.id,
                      scheduleDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                    );
                    ref.read(siteOptionProvider).requestSoilTestMission(req).then((value) {
                      if (value) {
                        if (kIsWeb) {
                          OneContext().popDialog();
                        } else {
                          Navigator.pop(context);
                        }
                      }
                    });
                  },
                  color: AppColors.SmatCrowPrimary500,
                  fontSize: SpacingConstants.size16,
                  width: Responsive.xWidth(context),
                  height: SpacingConstants.size47,
                ),
                SizedBox(
                  height: kIsWeb ? SpacingConstants.size40 : MediaQuery.of(context).viewInsets.bottom,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
