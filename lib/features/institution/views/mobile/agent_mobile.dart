import 'package:flutter/material.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/app_container.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/top_down_text.dart';
import 'package:smat_crow/features/organisation/views/widgets/custom_action_widget.dart';
import 'package:smat_crow/features/shared/views/custom_app_bar.dart';
import 'package:smat_crow/features/shared/views/modal_stick.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/features/widgets/custom_button.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class AgentMobile extends StatelessWidget {
  const AgentMobile({
    super.key,
    this.isMobile = true,
  });

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isMobile ? customAppBar(context, title: "Agents") : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(SpacingConstants.double20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppContainer(
              padding: EdgeInsets.zero,
              child: Table(
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
                            text: "Name",
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
                            text: "Email Adresss",
                            fontSize: SpacingConstants.font14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  ...List.generate(
                    10,
                    (index) => TableRow(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(bottom: BorderSide(color: AppColors.SmatCrowNeuBlue100)),
                      ),
                      children: [
                        TableCell(
                          child: InkWell(
                            onTap: () => _userOption(context),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: SpacingConstants.double20,
                                vertical: SpacingConstants.font10,
                              ),
                              child: Text(
                                "Dammy",
                                style: Styles.smatCrowSubParagraphRegular(
                                  color: AppColors.SmatCrowNeuBlue900,
                                ),
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: InkWell(
                            onTap: () => _userOption(context),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: SpacingConstants.double20,
                                vertical: SpacingConstants.font10,
                              ),
                              child: Text(
                                "dammy@gmail.com",
                                style: Styles.smatCrowSubParagraphRegular(
                                  color: AppColors.SmatCrowNeuBlue900,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<dynamic> _userOption(BuildContext context) {
  return customDialogAndModal(
    context,
    Padding(
      padding: const EdgeInsets.only(
        left: SpacingConstants.double20,
        right: SpacingConstants.double20,
        bottom: SpacingConstants.size30,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ModalStick(),
          Container(
            width: SpacingConstants.size50,
            height: SpacingConstants.size50,
            decoration: const BoxDecoration(
              color: AppColors.SmatCrowAccentBlue,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              "D",
              style: Styles.smatCrowSmallTextRegular(color: Colors.white).copyWith(fontSize: SpacingConstants.font14),
            ),
          ),
          const Ymargin(SpacingConstants.size10),
          const TopDownText(
            top: "Farm Name",
            down: "Dammy",
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
          const Ymargin(SpacingConstants.size30),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TopDownText(top: "Email Address", down: "Dammy@doe.com"),
              TopDownText(
                top: "User Type",
                down: "Field Agent",
                crossAxisAlignment: CrossAxisAlignment.end,
              )
            ],
          ),
          const Ymargin(SpacingConstants.size20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomButton(
                  text: "Delete",
                  onPressed: () {},
                  height: SpacingConstants.size44,
                  leftIcon: Icons.delete_outline_rounded,
                  color: AppColors.SmatCrowRed500,
                  textColor: Colors.white,
                  iconColor: Colors.white,
                ),
              ),
              const Xmargin(SpacingConstants.double20),
              Expanded(
                child: CustomButton(
                  text: "Edit",
                  onPressed: () {},
                  height: SpacingConstants.size44,
                  leftIcon: Icons.edit_outlined,
                ),
              )
            ],
          )
        ],
      ),
    ),
  );
}
