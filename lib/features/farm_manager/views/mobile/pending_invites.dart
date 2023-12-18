// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:one_context/one_context.dart';
import 'package:smat_crow/features/farm_manager/data/controller/farm_manager_controller.dart';
import 'package:smat_crow/features/farm_manager/data/model/accept_invite_request.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/app_container.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/top_down_text.dart';
import 'package:smat_crow/features/institution/data/model/invite_response.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/organisation/views/widgets/custom_action_widget.dart';
import 'package:smat_crow/features/organisation/views/widgets/empty_list_widget.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/features/shared/views/custom_app_bar.dart';
import 'package:smat_crow/features/shared/views/modal_stick.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/features/widgets/custom_button.dart';
import 'package:smat_crow/features/widgets/custom_text_field.dart';
import 'package:smat_crow/screens/farmmanager/widgets/grid_loader.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class PendingInvites extends StatelessWidget {
  const PendingInvites({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, title: "Pending Invites"),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: SpacingConstants.double20,
        ),
        height: Responsive.yHeight(context),
        child: AppContainer(
          padding: EdgeInsets.zero,
          child: HookConsumer(
            builder: (context, ref, child) {
              final manager = ref.watch(farmManagerProvider);
              useEffect(
                () {
                  Future(() async {
                    if (manager.pendingInviteList.isEmpty) {
                      await manager.pendinginvitation();
                    } else {
                      await manager.pendinginvitation(false);
                    }

                    ref.watch(sharedProvider).getOrganizationList();
                    await ref.watch(sharedProvider).getPermission();
                  });
                  return () {};
                },
                [],
              );
              if (manager.loading) {
                return const GridLoader(arrangement: 1);
              }
              if (manager.pendingInviteList.isEmpty) {
                return const EmptyListWidget(
                  text: "No Pending invites",
                  asset: AppAssets.emptyImage,
                );
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
                    manager.pendingInviteList.length,
                    (index) => TableRow(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(bottom: BorderSide(color: AppColors.SmatCrowNeuBlue100)),
                      ),
                      children: [
                        TableCell(
                          child: InkWell(
                            onTap: () {
                              _inviteOption(context, manager.pendingInviteList[index]);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: SpacingConstants.double20,
                                vertical: SpacingConstants.font10,
                              ),
                              child: Text(
                                manager.pendingInviteList[index].parentDetails!.email ?? "",
                                style: Styles.smatCrowSubParagraphRegular(
                                  color: AppColors.SmatCrowNeuBlue900,
                                ),
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: InkWell(
                            onTap: () {
                              _inviteOption(context, manager.pendingInviteList[index]);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: SpacingConstants.double20,
                                vertical: SpacingConstants.font10,
                              ),
                              child: Text(
                                manager.pendingInviteList[index].parentDetails!.fullName ?? "",
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
      ),
    );
  }
}

Future<dynamic> _inviteOption(BuildContext context, InviteResponse resp) {
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
                  (resp.parentDetails!.fullName ?? "")[0],
                  style:
                      Styles.smatCrowSmallTextRegular(color: Colors.white).copyWith(fontSize: SpacingConstants.font14),
                ),
              ),
              BoldHeaderText(
                text: resp.parentDetails!.fullName ?? "",
                fontSize: SpacingConstants.font16,
              ),
              const Ymargin(SpacingConstants.size30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TopDownText(top: emailAddress, down: resp.parentDetails!.email ?? ""),
                  TopDownText(
                    top: phoneNumberText,
                    down: resp.parentDetails!.phone ?? "",
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
                      text: cancel,
                      loading: ref.watch(farmManagerProvider).loader,
                      onPressed: () {
                        ref
                            .read(farmManagerProvider)
                            .cancelInvitation(
                              resp.recipientDetails!.email ?? "",
                              resp.invitationDetails!.parentId ?? "",
                            )
                            .then((value) {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                            return;
                          }
                          OneContext().popDialog();
                        });
                      },
                      height: SpacingConstants.size44,
                      leftIcon: Icons.cancel_outlined,
                      color: AppColors.SmatCrowRed500,
                      textColor: Colors.white,
                      iconColor: Colors.white,
                    ),
                  ),
                  const Xmargin(SpacingConstants.double20),
                  Expanded(
                    child: CustomButton(
                      text: acceptRequest,
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          OneContext().popDialog();
                        }

                        customDialogAndModal(
                          context,
                          HookConsumer(
                            builder: (context, ref, child) {
                              final permissionList = useState(<String>[]);
                              final orgs = useState(<Org>[]);
                              final secureToken = useState<String?>(null);
                              useEffect(
                                () {
                                  secureToken.value = resp.invitationDetails!.invitationToken;
                                  Future(() {
                                    ref.watch(organizationProvider).getUserOrganizations();
                                  });
                                  return null;
                                },
                                [],
                              );
                              return Column(
                                children: [
                                  const Ymargin(50),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const BoldHeaderText(text: "Accept Invite"),
                                        GestureDetector(
                                          child: const Icon(Icons.clear),
                                          onTap: () {
                                            if (Navigator.canPop(context)) {
                                              Navigator.pop(context);
                                              return;
                                            }
                                            OneContext().popDialog();
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                  const Ymargin(20),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CustomTextField(
                                            hintText: "Enter invitation token",
                                            text: "Invitation Token",
                                            initialValue: secureToken.value,
                                            onChanged: (value) {
                                              secureToken.value = value;
                                            },
                                          ),
                                          const Ymargin(20),
                                          Text(
                                            "Organization",
                                            style: Styles.smatCrowMediumSubParagraph(
                                              color: AppColors.SmatCrowNeuBlue900,
                                            ).copyWith(fontWeight: FontWeight.bold),
                                          ),
                                          ...ref
                                              .watch(organizationProvider)
                                              .organizationList
                                              .map((e) => Org(organizationId: e.id, organizationName: e.name))
                                              .map(
                                                (e) => CheckboxListTile.adaptive(
                                                  contentPadding: EdgeInsets.zero,
                                                  value: orgs.value
                                                      .map((e) => e.organizationId)
                                                      .contains(e.organizationId),
                                                  onChanged: (value) {
                                                    if (orgs.value
                                                        .map((e) => e.organizationId)
                                                        .contains(e.organizationId)) {
                                                      orgs.value.removeWhere(
                                                        (element) => element.organizationId == e.organizationId,
                                                      );
                                                    } else {
                                                      orgs.value.add(e);
                                                    }
                                                    orgs.notifyListeners();
                                                  },
                                                  title: Text(e.organizationName ?? ""),
                                                ),
                                              ),
                                          const Ymargin(20),
                                          Text(
                                            "Permissions",
                                            style: Styles.smatCrowMediumSubParagraph(
                                              color: AppColors.SmatCrowNeuBlue900,
                                            ).copyWith(fontWeight: FontWeight.bold),
                                          ),
                                          const Ymargin(20),
                                          ...ref.watch(sharedProvider).permissionList.map(
                                                (e) => Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          e.groupName,
                                                          style: Styles.smatCrowMediumSubParagraph(
                                                            color: AppColors.SmatCrowNeuBlue900,
                                                          ).copyWith(fontWeight: FontWeight.bold),
                                                        ),
                                                        const Spacer(),
                                                        Checkbox.adaptive(
                                                          value: e.permissions.every(permissionList.value.contains),
                                                          onChanged: (val) {
                                                            if (e.permissions.any(permissionList.value.contains)) {
                                                              permissionList.value.removeWhere(e.permissions.contains);
                                                            } else {
                                                              permissionList.value.addAll(e.permissions);
                                                            }
                                                            permissionList.notifyListeners();
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                    Wrap(
                                                      children: e.permissions
                                                          .map(
                                                            (e) => Row(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                Checkbox.adaptive(
                                                                  value: permissionList.value.contains(e),
                                                                  onChanged: (val) {
                                                                    if (permissionList.value.contains(e)) {
                                                                      permissionList.value.remove(e);
                                                                    } else {
                                                                      permissionList.value.add(e);
                                                                    }
                                                                    permissionList.notifyListeners();
                                                                  },
                                                                ),
                                                                Text(
                                                                  e.toUpperCase(),
                                                                  style: Styles.smatCrowSmallTextRegular(),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                          .toList(),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Ymargin(20),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                    child: CustomButton(
                                      text: "Accept Invite",
                                      loading: ref.watch(farmManagerProvider).loader,
                                      onPressed: () {
                                        if (secureToken.value == null) {
                                          snackBarMsg("Enter received token");
                                          return;
                                        }

                                        if (permissionList.value.isEmpty) {
                                          snackBarMsg("Select permissions");
                                          return;
                                        }
                                        if (orgs.value.isEmpty) {
                                          snackBarMsg("Select organizations");
                                          return;
                                        }

                                        final request = AcceptInviteRequest(
                                          invitationId: resp.invitationDetails!.uuid ?? "",
                                          secureToken: secureToken.value ?? "",
                                          recipientId: resp.invitationDetails!.recipientId ?? "",
                                          senderId: resp.invitationDetails!.parentId ?? "",
                                          organizations: orgs.value,
                                          visibilityPermissions: permissionList.value,
                                        );
                                        ref.read(farmManagerProvider).acceptInvite(request).then((value) {
                                          if (Navigator.canPop(context)) {
                                            Navigator.pop(context);
                                            return;
                                          }
                                          OneContext().popDialog();
                                        });
                                      },
                                    ),
                                  ),
                                  const Ymargin(40),
                                  SizedBox(
                                    height: Responsive.isDesktop(context)
                                        ? SpacingConstants.size40
                                        : MediaQuery.of(context).viewInsets.bottom,
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      },
                      height: SpacingConstants.size44,
                      leftIcon: Icons.check,
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
