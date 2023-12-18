import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_manager/views/mobile/farm_agents_mobile.dart';
import 'package:smat_crow/features/institution/views/mobile/financa_dash_mobile.dart';
import 'package:smat_crow/features/institution/views/mobile/map_view_mobile.dart';
import 'package:smat_crow/features/institution/views/web/institution_menu.dart';
import 'package:smat_crow/features/institution/views/widgets/image_text.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/organisation/views/pages/site_map_options/soil_info.dart';
import 'package:smat_crow/features/organisation/views/pages/site_map_options/weather_info.dart';
import 'package:smat_crow/features/organisation/views/widgets/custom_action_widget.dart';
import 'package:smat_crow/features/organisation/views/widgets/dialog_header.dart';
import 'package:smat_crow/features/organisation/views/widgets/empty_list_widget.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/main.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class MenuBody extends HookConsumerWidget {
  const MenuBody({
    super.key,
    required this.isMobile,
    required this.selectedMenu,
  });

  final bool isMobile;
  final ValueNotifier<int> selectedMenu;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isMobile)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(SpacingConstants.font10),
                child: DialogHeader(
                  headText: ref.watch(organizationProvider).organization != null
                      ? ref.watch(organizationProvider).organization!.name ?? ""
                      : emptyString,
                  showIcon: true,
                  callback: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const Divider(),
            ],
          ),
        ListTile(
          leading: Text(
            menuText.toUpperCase(),
            style: Styles.smatCrowMediumLabel(color: AppColors.SmatCrowNeuBlue900),
          ),
        ),
        ...List.generate(
          menuList.length,
          (index) => InkWell(
            onTap: () {
              selectedMenu.value = index;

              if (selectedMenu.value == 2) {
                if (!isMobile) {
                  Navigator.pop(context);
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MapViewMobile(),
                  ),
                );
                return;
              }
              if (selectedMenu.value == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FinanceDashMobile(),
                  ),
                );
                return;
              }
              if (selectedMenu.value == 2) {
                customModalSheet(context, const WeatherInfo());
                return;
              }
              if (selectedMenu.value == 3) {
                customModalSheet(context, const SoilInfo());
                return;
              }
            },
            child: Container(
              padding: const EdgeInsets.all(SpacingConstants.font12),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    width: SpacingConstants.size2,
                    color: selectedMenu.value == index ? AppColors.SmatCrowPrimary500 : Colors.white,
                  ),
                ),
              ),
              width: double.maxFinite,
              child: Row(
                children: [
                  Image.asset(menuList[index].asset),
                  const Xmargin(SpacingConstants.font10),
                  Text(
                    menuList[index].name,
                    style: Styles.smatCrowSubParagraphRegular(
                      color: AppColors.SmatCrowNeuBlue900,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        ListTile(
          leading: Text(
            farmManagerText.toUpperCase(),
            style: Styles.smatCrowMediumLabel(color: AppColors.SmatCrowNeuBlue900),
          ),
        ),
        InkWell(
          onTap: () {
            customDialogAndModal(
              navigatorKey.currentState!.context,
              SizedBox(
                height: Responsive.yHeight(context, percent: 0.8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DialogHeader(
                      headText: selectLogTypeText,
                      callback: () {
                        if (isMobile) {
                          Navigator.pop(navigatorKey.currentState!.context);
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      showIcon: true,
                    ),
                    HookConsumer(
                      builder: (context, ref, child) {
                        final shared = ref.watch(sharedProvider);
                        useEffect(
                          () {
                            Future(() {
                              if (shared.logTypesList.isEmpty) {
                                shared.getLogTypes();
                              }
                            });
                            return null;
                          },
                          [],
                        );
                        if (shared.loading) {
                          return const Center(
                            child: CupertinoActivityIndicator(),
                          );
                        }
                        if (shared.logTypesList.isEmpty) {
                          return const Center(
                            child: EmptyListWidget(
                              text: noLogFound,
                              asset: AppAssets.emptyImage,
                            ),
                          );
                        }
                        return SizedBox(
                          height: Responsive.yHeight(context, percent: 0.67),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ...shared.logTypesList
                                    .map(
                                      (e) => ListTile(
                                        leading: Text(e.types ?? ""),
                                        onTap: () {
                                          shared.logType = e;
                                          if (!isMobile) {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          }
                                          Pandora().reRouteUser(
                                            navigatorKey.currentState!.context,
                                            ConfigRoute.farmLogType,
                                            e,
                                          );
                                        },
                                      ),
                                    )
                                    .toList()
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
              Responsive.isTablet(context),
            );
          },
          child: const ImageText(
            title: farmLogText,
            asset: AppAssets.plant,
          ),
        ),
        InkWell(
          onTap: () {
            customDialogAndModal(
              navigatorKey.currentState!.context,
              SizedBox(
                height: Responsive.yHeight(context, percent: 0.8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DialogHeader(
                      headText: selectAssetType,
                      callback: () {
                        if (isMobile) {
                          Navigator.pop(navigatorKey.currentState!.context);
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      showIcon: true,
                    ),
                    HookConsumer(
                      builder: (context, ref, child) {
                        final shared = ref.watch(sharedProvider);
                        useEffect(
                          () {
                            Future(() {
                              if (shared.assetTypesList.isEmpty) {
                                shared.getAssetTypes();
                              }
                            });
                            return null;
                          },
                          [],
                        );
                        if (shared.loading) {
                          return const Center(
                            child: CupertinoActivityIndicator(),
                          );
                        }
                        if (shared.assetTypesList.isEmpty) {
                          return const Center(
                            child: EmptyListWidget(
                              text: noAssetFound,
                              asset: AppAssets.emptyImage,
                            ),
                          );
                        }
                        return SizedBox(
                          height: Responsive.yHeight(context, percent: 0.67),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ...shared.assetTypesList
                                    .map(
                                      (e) => ListTile(
                                        leading: Text(e.types ?? ""),
                                        onTap: () {
                                          shared.assetTypes = e;
                                          if (!isMobile) {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          }
                                          Pandora().reRouteUser(
                                            navigatorKey.currentState!.context,
                                            ConfigRoute.farmAsset,
                                            e,
                                          );
                                        },
                                      ),
                                    )
                                    .toList()
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
              Responsive.isTablet(context),
            );
          },
          child: const ImageText(
            title: farmAssetText,
            asset: AppAssets.barrow,
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FarmAgentMobile(),
              ),
            );
          },
          child: const ImageText(
            title: agentsText,
            asset: AppAssets.famer,
          ),
        ),
      ],
    );
  }
}
