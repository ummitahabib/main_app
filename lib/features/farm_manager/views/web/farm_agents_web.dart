import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:one_context/one_context.dart';
import 'package:smat_crow/features/farm_manager/data/controller/farm_manager_controller.dart';
import 'package:smat_crow/features/farm_manager/data/model/agent_model.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/app_container.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/color_600_text.dart';
import 'package:smat_crow/features/institution/data/controller/institution_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/organisation/views/widgets/custom_action_widget.dart';
import 'package:smat_crow/features/organisation/views/widgets/dialog_header.dart';
import 'package:smat_crow/features/organisation/views/widgets/empty_list_widget.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/features/shared/views/custom_app_bar.dart';
import 'package:smat_crow/features/shared/views/load_more_indicator.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/features/widgets/custom_button.dart';
import 'package:smat_crow/features/widgets/custom_drop_down.dart';
import 'package:smat_crow/features/widgets/custom_text_field.dart';
import 'package:smat_crow/main.dart';
import 'package:smat_crow/screens/farmmanager/widgets/grid_loader.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

var _page = 1;

class FarmAgentWeb extends HookConsumerWidget {
  const FarmAgentWeb({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final manager = ref.watch(farmManagerProvider);
    final beamState = Beamer.of(context).currentBeamLocation.state as BeamState;
    final id = beamState.pathPatternSegments;
    final controller = useScrollController();

    useEffect(
      () {
        Future(() {
          manager.getAgents(orgId: id.last);
        });
        controller.addListener(() async {
          if (controller.position.atEdge) {
            final isTop = controller.position.pixels == 0;
            if (!isTop && !manager.loadMore) {
              await manager.getMoreAgents(orgId: id.last, page: _page);
              _page++;
            }
          }
        });
        return null;
      },
      [],
    );
    return Scaffold(
      appBar: customAppBar(
        context,
        onTap: () {
          context.beamToReplacementNamed(
            "${ConfigRoute.farmManagerOverview}/${id.last}",
          );
        },
        title: agentsText,
        actions: ref.watch(sharedProvider).userInfo != null &&
                ref.watch(sharedProvider).userInfo!.user.role.role == UserRole.user.name
            ? [
                CustomButton(
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
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              DialogHeader(
                                headText: addAgentText,
                                showIcon: true,
                                callback: () {
                                  OneContext().popDialog();
                                },
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: SpacingConstants.double20,
                                  vertical: SpacingConstants.font10,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
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
                                        ref.read(farmManagerProvider).onboardAgent(
                                          agentEmail.value!,
                                          [manager.agentType!.uuid ?? ""],
                                        ).then((value) {
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
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                  text: addAgentText,
                  leftIcon: Icons.add,
                  height: SpacingConstants.size30,
                  width: SpacingConstants.size140,
                ),
                const Xmargin(SpacingConstants.double20)
              ]
            : [],
      ),
      body: SingleChildScrollView(
        controller: controller,
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
                    return WrapLoader(length: SpacingConstants.font10.toInt());
                  }
                  if (manager.farmAgentList.isEmpty) {
                    return const EmptyListWidget(
                      text: noAgentText,
                      asset: AppAssets.emptyImage,
                    );
                  }
                  return Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: const {0: FixedColumnWidth(60), 3: FixedColumnWidth(150), 4: FixedColumnWidth(150)},
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
                              padding: EdgeInsets.symmetric(
                                horizontal: SpacingConstants.font10,
                                vertical: SpacingConstants.font10,
                              ),
                              child: BoldHeaderText(
                                text: email,
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
                                text: phoneNumberText,
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
                                  manager.farmAgentList[index].userDetails!.email ?? "",
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
                                child: Text(
                                  manager.farmAgentList[index].userDetails!.phone ?? "",
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
                                child: Text(
                                  DateFormat('MM-dd-yy').format(
                                    manager.farmAgentList[index].userTypes!.isEmpty
                                        ? DateTime.now()
                                        : manager.farmAgentList[index].userTypes!.first.modifiedDate ?? DateTime.now(),
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
            ),
            if (manager.loadMore) const LoadMoreIndicator()
          ],
        ),
      ),
    );
  }
}

Future<dynamic> agentDetails(BuildContext context, FarmAgentModel manager) {
  return customDialogAndModal(
    context,
    HookBuilder(
      builder: (context) {
        final selected = useState<UserType?>(
          manager.userTypes!.isEmpty ? null : manager.userTypes!.first,
        );
        return SizedBox(
          height: Responsive.yHeight(context, percent: 0.95),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DialogHeader(
                headText: addAgentText,
                showIcon: true,
                callback: () {
                  if (Responsive.isDesktop(context)) {
                    OneContext().popDialog();
                  } else {
                    Navigator.pop(context);
                  }
                },
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: SpacingConstants.double20).copyWith(bottom: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: SpacingConstants.font32,
                                  backgroundColor: AppColors.SmatCrowNeuBlue200,
                                  foregroundImage: NetworkImage(DEFAULT_IMAGE),
                                ),
                                const Xmargin(SpacingConstants.font10),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        manager.userDetails!.fullName ?? "",
                                        style: Styles.smatCrowMediumParagraph(
                                          color: AppColors.SmatCrowNeuBlue900,
                                        ).copyWith(fontSize: SpacingConstants.font16),
                                      ),
                                      Color600Text(text: manager.userDetails!.email ?? "")
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Xmargin(SpacingConstants.double20),
                          AppContainer(
                            padding: const EdgeInsets.symmetric(
                              horizontal: SpacingConstants.font10,
                              vertical: SpacingConstants.size5,
                            ),
                            child: PopupMenuButton(
                              itemBuilder: (context) => manager.userTypes!
                                  .map(
                                    (e) => PopupMenuItem(
                                      value: e,
                                      child: Text(e.userType ?? ""),
                                    ),
                                  )
                                  .toList(),
                              onSelected: (value) {
                                selected.value = value;
                              },
                              initialValue: selected.value,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  color: AppColors.SmatCrowNeuBlue200,
                                ),
                                borderRadius: BorderRadius.circular(SpacingConstants.font10),
                              ),
                              elevation: 1,
                              position: PopupMenuPosition.under,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Color600Text(
                                    text: selected.value == null ? selectText : (selected.value!.userType ?? ""),
                                  ),
                                  const Xmargin(SpacingConstants.font10),
                                  const Icon(Icons.keyboard_arrow_down)
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      const Ymargin(SpacingConstants.double20),
                      Row(
                        children: [
                          SvgPicture.asset(AppAssets.calendar),
                          const Xmargin(SpacingConstants.font10),
                          Text(
                            manager.userDetails!.phone ?? "",
                            style: Styles.smatCrowSubParagraphRegular(),
                          ),
                          const Xmargin(SpacingConstants.size30),
                          SvgPicture.asset(AppAssets.phone),
                          const Xmargin(SpacingConstants.font10),
                          Text(
                            manager.userDetails!.phone ?? "",
                            style: Styles.smatCrowSubParagraphRegular(),
                          ),
                        ],
                      ),
                      if (selected.value != null) const Ymargin(SpacingConstants.size30),
                      if (selected.value != null)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const BoldHeaderText(text: "Permission"),
                            Wrap(
                              children: selected.value!.permissions!
                                  .map(
                                    (e) => Padding(
                                      padding: const EdgeInsets.only(
                                        right: SpacingConstants.font10,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Checkbox.adaptive(
                                            value: true,
                                            onChanged: (value) {},
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                SpacingConstants.font10,
                                              ),
                                            ),
                                            splashRadius: SpacingConstants.font10,
                                          ),
                                          Text(
                                            e,
                                            style: Styles.smatCrowSmallTextRegular(),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            )
                          ],
                        ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    ),
    !Responsive.isMobile(context),
  );
}
