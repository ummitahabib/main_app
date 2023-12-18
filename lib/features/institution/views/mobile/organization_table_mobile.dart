import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:one_context/one_context.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/app_container.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/head_down.dart';
import 'package:smat_crow/features/institution/data/controller/institution_controller.dart';
import 'package:smat_crow/features/institution/data/model/institution_org_response.dart';
import 'package:smat_crow/features/organisation/data/controller/site_controller.dart';
import 'package:smat_crow/features/organisation/views/widgets/custom_action_widget.dart';
import 'package:smat_crow/features/organisation/views/widgets/empty_list_widget.dart';
import 'package:smat_crow/features/shared/views/modal_stick.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/main.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/farmmanager/widgets/grid_loader.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class OrganizationTableMobile extends HookConsumerWidget {
  const OrganizationTableMobile({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instPro = ref.watch(institutionProvider);
    useEffect(
      () {
        Future(() {
          instPro.getInstitutionOrg();
        });
        return null;
      },
      [],
    );
    return AppContainer(
      padding: EdgeInsets.zero,
      color: Colors.white,
      child: Builder(
        builder: (context) {
          if (instPro.loading) {
            return const GridLoader(arrangement: 1);
          }
          if (instPro.institutionOrgList.isEmpty) {
            return const EmptyListWidget(
              text: noOrgFound,
              asset: AppAssets.emptyImage,
            );
          }
          return Responsive.isMobile(context)
              ? Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    const TableRow(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: AppColors.SmatCrowNeuBlue100,
                          ),
                        ),
                      ),
                      children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: SpacingConstants.double20,
                              vertical: SpacingConstants.font10,
                            ),
                            child: BoldHeaderText(
                              text: nameText,
                              fontSize: SpacingConstants.font14,
                            ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: SpacingConstants.double20,
                              vertical: SpacingConstants.font10,
                            ),
                            child: BoldHeaderText(
                              text: noOfOrgText,
                              fontSize: SpacingConstants.font14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ...List.generate(
                      instPro.institutionOrgList.length,
                      (index) => TableRow(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(
                              color: AppColors.SmatCrowNeuBlue100,
                            ),
                          ),
                        ),
                        children: [
                          TableCell(
                            child: InkWell(
                              onTap: () {
                                orgOption(
                                  context,
                                  instPro.institutionOrgList[index],
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: SpacingConstants.double20,
                                  vertical: SpacingConstants.font10,
                                ),
                                child: BoldHeaderText(
                                  text: instPro.institutionOrgList[index].user!.fullName ?? "",
                                  fontSize: SpacingConstants.font14,
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: SpacingConstants.double20,
                                vertical: SpacingConstants.font10,
                              ),
                              child: BoldHeaderText(
                                text: (instPro.institutionOrgList[index].organizations ?? []).length.toString(),
                                fontSize: SpacingConstants.font14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              : Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    const TableRow(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: AppColors.SmatCrowNeuBlue100,
                          ),
                        ),
                      ),
                      children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: SpacingConstants.double20,
                              vertical: SpacingConstants.font10,
                            ),
                            child: BoldHeaderText(
                              text: nameText,
                              fontSize: SpacingConstants.font14,
                            ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: SpacingConstants.double20,
                              vertical: SpacingConstants.font10,
                            ),
                            child: BoldHeaderText(
                              text: emailHint,
                              fontSize: SpacingConstants.font14,
                            ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: SpacingConstants.double20,
                              vertical: SpacingConstants.font10,
                            ),
                            child: BoldHeaderText(
                              text: noOfOrgText,
                              fontSize: SpacingConstants.font14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ...List.generate(
                      instPro.institutionOrgList.length,
                      (index) => TableRow(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(
                              color: AppColors.SmatCrowNeuBlue100,
                            ),
                          ),
                        ),
                        children: [
                          TableCell(
                            child: InkWell(
                              onTap: () {
                                orgOption(
                                  context,
                                  instPro.institutionOrgList[index],
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: SpacingConstants.double20,
                                  vertical: SpacingConstants.font10,
                                ),
                                child: BoldHeaderText(
                                  text: instPro.institutionOrgList[index].user!.fullName ?? "",
                                  fontSize: SpacingConstants.font14,
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: InkWell(
                              onTap: () {
                                orgOption(
                                  context,
                                  instPro.institutionOrgList[index],
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: SpacingConstants.double20,
                                  vertical: SpacingConstants.font10,
                                ),
                                child: BoldHeaderText(
                                  text: instPro.institutionOrgList[index].user!.email ?? "",
                                  fontSize: SpacingConstants.font14,
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: SpacingConstants.double20,
                                vertical: SpacingConstants.font10,
                              ),
                              child: BoldHeaderText(
                                text: (instPro.institutionOrgList[index].organizations ?? []).length.toString(),
                                fontSize: SpacingConstants.font14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                );
        },
      ),
    );
  }
}

Future<dynamic> orgOption(BuildContext context, InstitutionOrgResponse inst) {
  return customDialogAndModal(
    kIsWeb ? context : navigatorKey.currentState!.context,
    HookConsumer(
      builder: (context, ref, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: SpacingConstants.double20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (Responsive.isMobile(context)) const ModalStick(),
              const Ymargin(SpacingConstants.double20),
              Row(
                children: [
                  BoldHeaderText(
                    text: inst.user!.fullName ?? "",
                    fontSize: SpacingConstants.font21,
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      ref.read(institutionProvider).detachOrganization(inst.user!.id ?? "").then((value) {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          OneContext().popDialog();
                        }
                      });
                    },
                    child: SvgPicture.asset(AppAssets.delete),
                  ),
                ],
              ),
              const Ymargin(SpacingConstants.double20),
              HeadDownWidget(
                head: emailHint,
                down: inst.user!.email ?? "",
              ),
              const Ymargin(SpacingConstants.double20),
              HeadDownWidget(
                head: noOfOrgText,
                down: (inst.organizations ?? []).length.toString(),
              ),
              const Ymargin(SpacingConstants.double20),
              Wrap(
                spacing: SpacingConstants.double20,
                runSpacing: SpacingConstants.double20,
                children: [
                  ...(inst.organizations ?? []).reversed.map(
                        (e) => InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            ref.watch(institutionProvider).instOrganization = e;
                            ref.read(siteProvider).getOrganizationSites(e.organizationId ?? "");
                            if (kIsWeb) {
                              Pandora().reRouteUser(
                                context,
                                "${ConfigRoute.institutionOrganizationPath}/${e.organizationId}",
                                e.organizationId,
                              );
                              return;
                            }
                            Pandora().reRouteUser(
                              navigatorKey.currentState!.context,
                              ConfigRoute.institutionOrganizationSitePath,
                              emptyString,
                            );
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: SpacingConstants.size100 + SpacingConstants.size10,
                                height: SpacingConstants.size80,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(DEFAULT_IMAGE),
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    SpacingConstants.size20,
                                  ),
                                ),
                              ),
                              Text(e.organizationName ?? "")
                            ],
                          ),
                        ),
                      )
                ],
              ),
              const Ymargin(SpacingConstants.double20),
            ],
          ),
        );
      },
    ),
    !Responsive.isMobile(context),
  );
}
