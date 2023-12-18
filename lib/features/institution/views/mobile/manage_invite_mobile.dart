import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:one_context/one_context.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/app_container.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/top_down_text.dart';
import 'package:smat_crow/features/institution/data/controller/institution_controller.dart';
import 'package:smat_crow/features/institution/data/model/invite_response.dart';
import 'package:smat_crow/features/organisation/views/widgets/custom_action_widget.dart';
import 'package:smat_crow/features/organisation/views/widgets/empty_list_widget.dart';
import 'package:smat_crow/features/shared/views/custom_app_bar.dart';
import 'package:smat_crow/features/shared/views/modal_stick.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/features/widgets/custom_button.dart';
import 'package:smat_crow/screens/farmmanager/widgets/grid_loader.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class ManageInviteMobile extends HookConsumerWidget {
  const ManageInviteMobile({
    super.key,
    this.isMobile = true,
  });

  final bool isMobile;
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
    return Scaffold(
      appBar: isMobile ? customAppBar(context, title: manageInviteText) : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(SpacingConstants.double20),
        child: Column(
          children: [
            AppContainer(
              padding: EdgeInsets.zero,
              child: Builder(
                builder: (context) {
                  if (instPro.loading) {
                    return const GridLoader(arrangement: 1);
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
                              child: InkWell(
                                onTap: () {
                                  _userOption(context, instPro.sentInviteList[index]);
                                },
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
                            ),
                            TableCell(
                              child: InkWell(
                                onTap: () => _userOption(context, instPro.sentInviteList[index]),
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
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<dynamic> _userOption(BuildContext context, InviteResponse resp) {
  return customDialogAndModal(
    context,
    HookConsumer(
      builder: (context, ref, child) {
        return Padding(
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
                  (resp.recipientDetails!.fullName ?? "")[0],
                  style:
                      Styles.smatCrowSmallTextRegular(color: Colors.white).copyWith(fontSize: SpacingConstants.font14),
                ),
              ),
              BoldHeaderText(
                text: resp.recipientDetails!.fullName ?? "",
                fontSize: SpacingConstants.font16,
              ),
              const Ymargin(SpacingConstants.size30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TopDownText(top: emailAddress, down: resp.recipientDetails!.email ?? ""),
                  TopDownText(
                    top: phoneNumberText,
                    down: resp.recipientDetails!.phone ?? "",
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
                      text: delete,
                      loading: ref.watch(institutionProvider).loader,
                      onPressed: () {
                        ref
                            .read(institutionProvider)
                            .cancelInvitation(resp.recipientDetails!.email ?? "", resp.invitationDetails!.uuid ?? "")
                            .then((value) {
                          if (Responsive.isTablet(context)) {
                            OneContext().popDialog();
                            return;
                          }
                          Navigator.pop(context);
                        });
                      },
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
                      text: resend,
                      loading: ref.watch(institutionProvider).loader,
                      onPressed: () {
                        ref
                            .read(institutionProvider)
                            .inviteOrganization(resp.recipientDetails!.email ?? "")
                            .then((value) {
                          if (Responsive.isTablet(context)) {
                            OneContext().popDialog();
                            return;
                          }
                          Navigator.pop(context);
                        });
                      },
                      height: SpacingConstants.size44,
                      leftIcon: Icons.send_outlined,
                    ),
                  )
                ],
              )
            ],
          ),
        );
      },
    ),
  );
}
