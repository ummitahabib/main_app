import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/app_container.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/institution/data/controller/institution_controller.dart';
import 'package:smat_crow/features/organisation/views/widgets/empty_list_widget.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/screens/farmmanager/widgets/grid_loader.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class ManageInviteWeb extends HookConsumerWidget {
  const ManageInviteWeb({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instPro = ref.watch(institutionProvider);
    useEffect(
      () {
        Future(() => instPro.sentInstitutions());
        return null;
      },
      [],
    );
    return Expanded(
      flex: 2,
      child: AppContainer(
        padding: EdgeInsets.zero,
        child: Builder(
          builder: (context) {
            if (instPro.loading) {
              return const GridLoader();
            }
            if (instPro.sentInviteList.isEmpty) {
              return const EmptyListWidget(text: manageInviteWarning, asset: AppAssets.emptyImage);
            }
            return Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                const TableRow(
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColors.SmatCrowNeuBlue100)),
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
                          text: emailAddress,
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
                          text: fullNameText,
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
                          text: actionText,
                          fontSize: SpacingConstants.font14,
                        ),
                      ),
                    ),
                  ],
                ),
                ...List.generate(
                  instPro.sentInviteList.length,
                  (index) => TableRow(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(bottom: BorderSide(color: AppColors.SmatCrowNeuBlue100)),
                    ),
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: SpacingConstants.double20,
                            vertical: SpacingConstants.font10,
                          ),
                          child: Text(
                            instPro.sentInviteList[index].recipientDetails!.email ?? "",
                            style: Styles.smatCrowSubParagraphRegular(
                              color: AppColors.SmatCrowNeuBlue900,
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
                          child: Text(
                            instPro.sentInviteList[index].recipientDetails!.fullName ?? "",
                            style: Styles.smatCrowSubParagraphRegular(
                              color: AppColors.SmatCrowNeuBlue900,
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
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () {
                                  ref
                                      .read(institutionProvider)
                                      .inviteOrganization(instPro.sentInviteList[index].recipientDetails!.email ?? "")
                                      .then((value) {});
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      AppAssets.invite,
                                      color: AppColors.SmatCrowPrimary500,
                                    ),
                                    const Xmargin(SpacingConstants.size5),
                                    Text(
                                      resend,
                                      style: Styles.smatCrowSubRegularUnderline(
                                        color: AppColors.SmatCrowPrimary500,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const Xmargin(SpacingConstants.size10),
                              InkWell(
                                onTap: () {
                                  ref
                                      .read(institutionProvider)
                                      .cancelInvitation(
                                        instPro.sentInviteList[index].recipientDetails!.email ?? "",
                                        instPro.sentInviteList[index].recipientDetails!.id ?? "",
                                      )
                                      .then((value) {});
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      AppAssets.delete,
                                      color: AppColors.SmatCrowRed500,
                                    ),
                                    const Xmargin(SpacingConstants.size5),
                                    Text(
                                      delete,
                                      style: Styles.smatCrowSubRegularUnderline(
                                        color: AppColors.SmatCrowRed500,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
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
      ),
    );
  }
}
