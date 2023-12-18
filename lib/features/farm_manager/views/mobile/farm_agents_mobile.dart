import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smat_crow/features/farm_manager/data/controller/farm_manager_controller.dart';
import 'package:smat_crow/features/farm_manager/views/web/farm_agents_web.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/app_container.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/institution/data/controller/institution_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/organisation/views/widgets/custom_action_widget.dart';
import 'package:smat_crow/features/organisation/views/widgets/empty_list_widget.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/features/shared/views/custom_app_bar.dart';
import 'package:smat_crow/features/shared/views/modal_stick.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/features/widgets/custom_button.dart';
import 'package:smat_crow/features/widgets/custom_drop_down.dart';
import 'package:smat_crow/features/widgets/custom_text_field.dart';
import 'package:smat_crow/main.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class FarmAgentMobile extends HookConsumerWidget {
  const FarmAgentMobile({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final manager = ref.watch(farmManagerProvider);
    useEffect(
      () {
        Future(() {
          manager.getAgents();
        });
        return null;
      },
      [],
    );
    return Scaffold(
      appBar: customAppBar(
        context,
        title: agentsText,
        actions: ref.watch(sharedProvider).userInfo!.user.role.role == UserRole.user.name
            ? [
                IconButton(
                  splashRadius: SpacingConstants.double20,
                  onPressed: () {
                    customDialogAndModal(
                      context,
                      HookConsumer(
                        builder: (context, ref, child) {
                          final agentEmail = useState<String?>(null);
                          final agentType = useState<String?>(null);
                          final manager = ref.watch(farmManagerProvider);
                          useEffect(
                            () {
                              Future(() {
                                if (manager.agentTypeList.isEmpty) {
                                  manager.getAgentTypes();
                                }
                              });
                              return null;
                            },
                            [],
                          );
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: SpacingConstants.double20,
                              vertical: SpacingConstants.font10,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const ModalStick(),
                                const Ymargin(SpacingConstants.font10),
                                const BoldHeaderText(text: addAgentText),
                                const Ymargin(SpacingConstants.double20),
                                CustomTextField(
                                  initialValue: agentEmail.value,
                                  hintText: enterEmail,
                                  onChanged: (value) {
                                    agentEmail.value = value;
                                  },
                                  text: agentEmailText,
                                ),
                                const Ymargin(SpacingConstants.double20),
                                CustomDropdownField(
                                  items: manager.agentTypeList.map((e) => e.userType ?? emptyString).toList(),
                                  value: agentType.value,
                                  hintText: selectYourOption,
                                  labelText: agentTypeText,
                                  onChanged: (value) {
                                    agentType.value = value;
                                    manager.agentType = manager.agentTypeList.firstWhere(
                                      (element) => element.userType == value,
                                    );
                                  },
                                ),
                                const Ymargin(SpacingConstants.double20),
                                CustomButton(
                                  text: sendinviteText,
                                  loading: manager.loader,
                                  onPressed: () {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    if (agentType.value == null || agentEmail.value == null) {
                                      snackBarMsg(validationWarningText);
                                      return;
                                    }
                                    ref
                                        .read(farmManagerProvider)
                                        .onboardAgent(agentEmail.value!, [manager.agentType!.uuid ?? ""]).then((value) {
                                      if (value) {
                                        if (Responsive.isMobile(context)) {
                                          Navigator.pop(
                                            navigatorKey.currentState!.context,
                                          );
                                        } else {
                                          Navigator.pop(context);
                                        }
                                      }
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: kIsWeb ? SpacingConstants.size40 : MediaQuery.of(context).viewInsets.bottom,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      Responsive.isTablet(context),
                    );
                  },
                  icon: const Icon(
                    Icons.add,
                    color: AppColors.SmatCrowPrimary500,
                  ),
                )
              ]
            : [],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(SpacingConstants.double20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppContainer(
              padding: EdgeInsets.zero,
              child: Builder(
                builder: (context) {
                  if (manager.loading) {
                    return const Center(child: CupertinoActivityIndicator());
                  }
                  if (manager.farmAgentList.isEmpty) {
                    return const EmptyListWidget(
                      text: noAgentText,
                      asset: AppAssets.emptyImage,
                    );
                  }
                  return Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: const {0: FixedColumnWidth(40)},
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
                                horizontal: SpacingConstants.font10,
                                vertical: SpacingConstants.font10,
                              ),
                              child: BoldHeaderText(
                                text: snText,
                                fontSize: SpacingConstants.font14,
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: SpacingConstants.font10,
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
                              padding: EdgeInsets.all(SpacingConstants.font10),
                              child: BoldHeaderText(
                                text: timeStampText,
                                fontSize: SpacingConstants.font14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      ...List.generate(
                        manager.farmAgentList.length,
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
                              child: Padding(
                                padding: const EdgeInsets.all(
                                  SpacingConstants.font10,
                                ),
                                child: Text(
                                  "${index + 1}",
                                  style: Styles.smatCrowSubParagraphRegular(
                                    color: AppColors.SmatCrowNeuBlue900,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(
                                  SpacingConstants.font10,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    agentDetails(
                                      context,
                                      manager.farmAgentList[index],
                                    );
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: SpacingConstants.double20,
                                        height: SpacingConstants.double20,
                                        decoration: const BoxDecoration(
                                          color: AppColors.SmatCrowAccentBlue,
                                          shape: BoxShape.circle,
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          manager.farmAgentList[index].userDetails!.fullName![0],
                                          style: Styles.smatCrowSmallTextRegular(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const Xmargin(SpacingConstants.size5),
                                      Flexible(
                                        child: Text(
                                          manager.farmAgentList[index].userDetails!.fullName ?? "",
                                          style: Styles.smatCrowSubParagraphRegular(
                                            color: AppColors.SmatCrowNeuBlue900,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(
                                  SpacingConstants.font10,
                                ),
                                child: Text(
                                  DateFormat('MM-dd-yy').format(
                                    manager.farmAgentList[index].userTypes!.first.modifiedDate ?? DateTime.now(),
                                  ),
                                  style: Styles.smatCrowSubParagraphRegular(
                                    color: AppColors.SmatCrowNeuBlue900,
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
            )
          ],
        ),
      ),
    );
  }
}
