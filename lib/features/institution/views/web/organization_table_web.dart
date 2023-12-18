import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/app_container.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/institution/data/controller/institution_controller.dart';
import 'package:smat_crow/features/institution/views/mobile/organization_table_mobile.dart';
import 'package:smat_crow/features/organisation/views/widgets/empty_list_widget.dart';
import 'package:smat_crow/features/widgets/custom_button.dart';
import 'package:smat_crow/screens/farmmanager/widgets/grid_loader.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class OrganizationTableWeb extends HookConsumerWidget {
  const OrganizationTableWeb({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instPro = ref.watch(institutionProvider);
    useEffect(
      () {
        Future(() {
          if (instPro.institutionOrgList.isEmpty) {
            instPro.getInstitutionOrg();
          }
        });
        return null;
      },
      [],
    );
    return AppContainer(
      padding: EdgeInsets.zero,
      child: Builder(
        builder: (context) {
          if (instPro.loading) {
            return WrapLoader(length: SpacingConstants.font10.toInt());
          }
          if (instPro.institutionOrgList.isEmpty) {
            return const EmptyListWidget(text: noOrgFound, asset: AppAssets.emptyImage);
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
                        text: descriptionText,
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
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: SpacingConstants.double20,
                        vertical: SpacingConstants.font10,
                      ),
                      child: BoldHeaderText(
                        text: "",
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
                    border: Border(bottom: BorderSide(color: AppColors.SmatCrowNeuBlue100)),
                  ),
                  children: [
                    TableCell(
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
                    TableCell(
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
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 40.0, right: 20),
                        child: CustomButton(
                          text: "View Details",
                          onPressed: () {
                            orgOption(context, instPro.institutionOrgList[index]);
                          },
                          fontSize: SpacingConstants.font12,
                          color: AppColors.SmatCrowNeuBlue100,
                          height: 32,
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
