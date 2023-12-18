import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:one_context/one_context.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/organisation/views/widgets/dialog_container.dart';
import 'package:smat_crow/features/organisation/views/widgets/dialog_header.dart';
import 'package:smat_crow/features/shared/data/controller/firebase_controller.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/features/widgets/custom_button.dart';
import 'package:smat_crow/features/widgets/custom_drop_down.dart';
import 'package:smat_crow/features/widgets/custom_text_field.dart';
import 'package:smat_crow/network/crow/models/organization_by_id_response.dart';
import 'package:smat_crow/network/crow/models/request/create_organization.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class OrganizationDetails extends HookConsumerWidget {
  const OrganizationDetails({
    super.key,
    this.org,
  });

  final GetOrganizationById? org;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final industryType = useState<String?>(null);
    final orgName = useState<String?>(null);

    final orgDesc = useState<String?>(null);
    final orgAddress = useState<String?>(null);
    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          ref.read(firebaseProvider).downloadUrl = null;
        });
        if (org != null) {
          industryType.value = org!.industry;
          orgName.value = org!.name;
          orgDesc.value = org!.longDescription;
          orgAddress.value = org!.address;
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            ref.read(firebaseProvider).downloadUrl = org!.image;
          });
        }

        return null;
      },
      [],
    );
    final firebase = ref.watch(firebaseProvider);
    return DialogContainer(
      height: Responsive.yHeight(
        context,
        percent: Responsive.isTablet(context)
            ? SpacingConstants.size0point5
            : kIsWeb
                ? SpacingConstants.size0point08
                : SpacingConstants.size0point7,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!Responsive.isDesktop(context))
            Center(
              child: Container(
                height: SpacingConstants.size5,
                width: SpacingConstants.size70,
                margin: const EdgeInsets.only(top: SpacingConstants.size10),
                decoration: const BoxDecoration(color: AppColors.SmatCrowNeuBlue200),
              ),
            ),
          customSizedBoxHeight(SpacingConstants.size20),
          DialogHeader(
            headText: org == null ? "$createText $organizationText" : "$updateText $organizationText",
            callback: () {
              ref.read(firebaseProvider).downloadUrl = null;
              OneContext().popDialog();
            },
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.isTablet(context) ? SpacingConstants.size40 : SpacingConstants.size20,
            ),
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            showDivider: kIsWeb,
          ),
          customSizedBoxHeight(SpacingConstants.size10),
          Container(
            height: Responsive.yHeight(
              context,
              percent: Responsive.isTablet(context) ? SpacingConstants.size0point4 : SpacingConstants.size0point6,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.isTablet(context) ? SpacingConstants.size40 : SpacingConstants.size20,
            ),
            child: ListView(
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        ref.read(organizationProvider).uploadToFirebase();
                      },
                      child: Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                              SpacingConstants.int200.toDouble(),
                            ),
                            child: Container(
                              height: SpacingConstants.size72,
                              width: SpacingConstants.size72,
                              decoration: BoxDecoration(
                                color: AppColors.SmatCrowNeuBlue100,
                                shape: BoxShape.circle,
                                image: ref.read(firebaseProvider).downloadUrl == null
                                    ? null
                                    : DecorationImage(
                                        image: NetworkImage(
                                          ref.read(firebaseProvider).downloadUrl!,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              alignment: Alignment.center,
                              child: ref.read(firebaseProvider).downloadUrl == null
                                  ? SvgPicture.asset(AppAssets.noImage)
                                  : null,
                            ),
                          ),
                          if (firebase.loading)
                            const SizedBox(
                              width: SpacingConstants.size20,
                              height: SpacingConstants.size20,
                              child: CircularProgressIndicator.adaptive(),
                            )
                          else
                            SvgPicture.asset(AppAssets.addImage)
                        ],
                      ),
                    ),
                    customSizedBoxWidth(SpacingConstants.size20),
                    Expanded(
                      child: SizedBox(
                        child: CustomTextField(
                          hintText: organizationName,
                          onChanged: (p0) => orgName.value = p0,
                          initialValue: orgName.value,
                          isRequired: true,
                          textCapitalization: TextCapitalization.words,
                          text: "",
                          labelStyle: Styles.smatCrowMediumParagraph(
                            color: AppColors.SmatCrowNeuBlue900,
                          ).copyWith(
                            fontSize: SpacingConstants.font14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                customSizedBoxHeight(SpacingConstants.size20),
                CustomTextField(
                  hintText: "$organizationText $address",
                  onChanged: (val) => orgAddress.value = val,
                  initialValue: orgAddress.value,
                  isRequired: true,
                  text: address,
                  labelStyle: Styles.smatCrowMediumParagraph(
                    color: AppColors.SmatCrowNeuBlue900,
                  ).copyWith(
                    fontSize: SpacingConstants.font14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                customSizedBoxHeight(SpacingConstants.size20),
                CustomDropdownField<String?>(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.SmatCrowNeuBlue50),
                    color: AppColors.SmatCrowNeuBlue100,
                    borderRadius: BorderRadius.circular(SpacingConstants.size10),
                  ),
                  hintStyle: Styles.smatCrowParagraphRegular(
                    fontSize: SpacingConstants.font14,
                    color: AppColors.SmatCrowNeuBlue400,
                  ),
                  valueStyle: Styles.smatCrowParagraphRegular(
                    fontSize: SpacingConstants.font14,
                    color: AppColors.SmatCrowNeuBlue900,
                  ),
                  labelStyle: Styles.smatCrowMediumParagraph(
                    color: AppColors.SmatCrowNeuBlue900,
                  ).copyWith(
                    fontSize: SpacingConstants.font14,
                    fontWeight: FontWeight.bold,
                  ),
                  height: SpacingConstants.size44,
                  hintText: selectYourOption,
                  items: ref.read(organizationProvider).industriesList.map((e) => e.name).toList(),
                  labelText: selectIndustryType,
                  onChanged: (p0) => industryType.value = p0,
                  value: ref.read(organizationProvider).industriesList.map((e) => e.name).contains(industryType.value)
                      ? industryType.value
                      : null,
                ),
                customSizedBoxHeight(SpacingConstants.size20),
                CustomTextField(
                  hintText: moreAboutCommunity,
                  onChanged: (p0) => orgDesc.value = p0,
                  initialValue: orgDesc.value,
                  text: description,
                  labelStyle: Styles.smatCrowMediumParagraph(
                    color: AppColors.SmatCrowNeuBlue900,
                  ).copyWith(
                    fontSize: SpacingConstants.font14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: SpacingConstants.size4.toInt(),
                ),
                customSizedBoxHeight(SpacingConstants.size20),
                CustomButton(
                  width: Responsive.xWidth(context),
                  height: SpacingConstants.size47,
                  text: org == null ? "$createText $organizationText" : "$updateText $organizationText",
                  onPressed: () {
                    if (industryType.value == null) {
                      snackBarMsg(selectIndustryType);
                      return;
                    }
                    if (orgName.value == null) {
                      snackBarMsg("$enter $organizationName");
                      return;
                    }
                    if (orgAddress.value == null) {
                      snackBarMsg("$enter $organizationText $address");
                      return;
                    }
                    if (orgDesc.value == null) {
                      snackBarMsg("$enter $description");
                      return;
                    }
                    if (ref.read(sharedProvider).userInfo == null) return;
                    final request = CreateOrganizationRequest(
                      name: orgName.value ?? "",
                      longDescription: orgDesc.value ?? "",
                      shortDescription: orgDesc.value ?? "",
                      image: ref.read(firebaseProvider).downloadUrl ?? "",
                      address: orgAddress.value ?? "",
                      industry: ref
                              .read(organizationProvider)
                              .industriesList
                              .firstWhere(
                                (element) => element.name == industryType.value,
                              )
                              .id ??
                          "",
                      user: ref.read(sharedProvider).userInfo!.user.id,
                    );
                    ref.read(organizationProvider).createOrUpdateOrganization(context, ref, org, request);
                  },
                  color: AppColors.SmatCrowPrimary500,
                  fontSize: SpacingConstants.size16,
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
