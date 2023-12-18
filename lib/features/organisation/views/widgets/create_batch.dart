import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/app_container.dart';
import 'package:smat_crow/features/organisation/data/controller/batch_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/sector_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/site_controller.dart';
import 'package:smat_crow/features/organisation/views/widgets/home_web_container.dart';
import 'package:smat_crow/features/shared/data/controller/firebase_controller.dart';
import 'package:smat_crow/features/widgets/custom_button.dart';
import 'package:smat_crow/features/widgets/custom_text_field.dart';
import 'package:smat_crow/network/crow/models/request/create_batch.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class CreateBatch extends HookConsumerWidget {
  const CreateBatch({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final batchName = useState<String?>(null);

    return HomeWebContainer(
      title: "New Batch",
      leadingCallback: () {
        ref.read(siteProvider).subType = SubType.sector;
        pageController.jumpToPage(0);
      },
      center: !kIsWeb,
      elevation: kIsWeb ? null : 0,
      width: Responsive.xWidth(context),
      trailingIcon: const SizedBox.shrink(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: SpacingConstants.size20,
          vertical: SpacingConstants.size10,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.isTablet(context) ? SpacingConstants.size70 : SpacingConstants.size20,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextField(
                    hintText: newBatchText,
                    onChanged: (p0) => batchName.value = p0,
                    textCapitalization: TextCapitalization.characters,
                    isRequired: true,
                    text: batchNameText,
                    labelStyle: Styles.smatCrowMediumParagraph(
                      color: AppColors.SmatCrowNeuBlue900,
                    ).copyWith(
                      fontSize: SpacingConstants.font14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  customSizedBoxHeight(SpacingConstants.size20),
                  InkWell(
                    onTap: () {
                      ref.read(firebaseProvider).downloadUrl = null;
                      ref.read(organizationProvider).uploadToFirebase("organization/batch");
                    },
                    child: AppContainer(
                      padding: const EdgeInsets.symmetric(
                        horizontal: SpacingConstants.size40,
                        vertical: SpacingConstants.size34,
                      ),
                      width: Responsive.xWidth(context),
                      child: ref.watch(firebaseProvider).loading
                          ? const SizedBox(
                              width: SpacingConstants.size20,
                              height: SpacingConstants.size20,
                              child: CircularProgressIndicator.adaptive(),
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  AppAssets.weatherInfo,
                                  color: AppColors.SmatCrowNeuBlue900,
                                ),
                                customSizedBoxHeight(
                                  SpacingConstants.size20,
                                ),
                                Flexible(
                                  child: Text(
                                    ref.read(firebaseProvider).downloadUrl ?? uploadYourFile,
                                    style: Styles.smatCrowMediumSubParagraph(
                                      color: Colors.black,
                                    ).copyWith(fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                customSizedBoxHeight(
                                  SpacingConstants.size10,
                                ),
                                Text(
                                  uploadWarning,
                                  style: Styles.smatCrowCaptionRegular(
                                    color: AppColors.SmatCrowNeuBlue500,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                    ),
                  ),
                  customSizedBoxHeight(SpacingConstants.size20),
                  CustomButton(
                    text: "$createText $newBatchText",
                    onPressed: () {
                      if (batchName.value != null && ref.read(firebaseProvider).downloadUrl != null) {
                        final req = CreateBatchRequest(
                          name: batchName.value!,
                          sector: ref.read(sectorProvider).sector!.id,
                        );
                        ref
                            .read(batchProvider)
                            .createBatch(
                              req,
                              ref.read(firebaseProvider).downloadUrl!,
                            )
                            .then((value) {
                          pageController.jumpToPage(4);
                          ref.read(siteProvider).subType = SubType.batch;
                        });
                      }
                    },
                    color: AppColors.SmatCrowPrimary500,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
