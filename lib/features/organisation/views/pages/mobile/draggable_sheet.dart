import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/organisation/data/controller/batch_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/map_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/sector_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/site_controller.dart';
import 'package:smat_crow/features/organisation/views/pages/mobile/create_site_mobile.dart';
import 'package:smat_crow/features/organisation/views/pages/mobile/site_main_page.dart';
import 'package:smat_crow/features/organisation/views/widgets/batch_edit_name.dart';
import 'package:smat_crow/features/organisation/views/widgets/batch_images_screen.dart';
import 'package:smat_crow/features/organisation/views/widgets/batch_list_page.dart';
import 'package:smat_crow/features/organisation/views/widgets/create_batch.dart';
import 'package:smat_crow/features/organisation/views/widgets/custom_card_bar.dart';
import 'package:smat_crow/features/organisation/views/widgets/sector_option_menu.dart';
import 'package:smat_crow/features/organisation/views/widgets/site_name.dart';
import 'package:smat_crow/features/shared/views/modal_stick.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class DraggableSheet extends StatefulHookConsumerWidget {
  const DraggableSheet({
    super.key,
  });

  @override
  ConsumerState<DraggableSheet> createState() => _DraggableSheetState();
}

class _DraggableSheetState extends ConsumerState<DraggableSheet> {
  final draggableScrollableController = DraggableScrollableController();
  final _pandora = Pandora();
  @override
  Widget build(BuildContext context) {
    final site = ref.watch(siteProvider);
    final sector = ref.watch(sectorProvider);
    final siteName = useState<String?>(null);

    return DraggableScrollableSheet(
      initialChildSize: ref.watch(siteProvider).sheetHeight,
      maxChildSize: 0.8,
      controller: draggableScrollableController,
      builder: (context, scrollController) => ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(SpacingConstants.size20),
          topRight: Radius.circular(SpacingConstants.size20),
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(SpacingConstants.size20),
              topRight: Radius.circular(SpacingConstants.size20),
            ),
          ),
          child: HookConsumer(
            builder: (context, ref, child) {
              final controller = usePageController();
              return ListView(
                controller: scrollController,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                children: [
                  const ModalStick(),
                  SizedBox(
                    width: Responsive.xWidth(context),
                    height: Responsive.yHeight(
                      context,
                      percent: draggableScrollableController.isAttached ? draggableScrollableController.size : 0.7,
                    ),
                    child: PageView(
                      controller: controller,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        SiteMainPage(pageController: controller),
                        SiteName(
                          controller: controller,
                          hintText: ref.read(siteProvider).subType == SubType.sector ? "$sectorText $nameText" : null,
                          callback: (val) {
                            FocusManager.instance.primaryFocus?.unfocus();
                            ref.watch(siteProvider).sheetHeight = 0.4;
                            if (ref.read(siteProvider).subType == SubType.site) {
                            } else {
                              ref.read(siteProvider).subType = SubType.sector;
                            }

                            if (val != null && val.isNotEmpty) {
                              siteName.value = val;
                              controller.nextPage(
                                duration: const Duration(
                                  milliseconds: SpacingConstants.int400,
                                ),
                                curve: Curves.easeInOut,
                              );
                              ref.read(mapProvider).allowMapTap = true;
                            } else {
                              _pandora.showToast(
                                nameWarning,
                                context,
                                MessageTypes.WARNING.toString().split('.').last,
                              );
                            }
                          },
                        ),
                        CreateSiteMobile(
                          controller: controller,
                          siteName: siteName.value ?? "",
                        ),

                        // This is to edit site name
                        SiteName(
                          controller: controller,
                          callback: (value) {
                            ref.watch(siteProvider).sheetHeight = 0.4;
                            FocusManager.instance.primaryFocus?.unfocus();
                            if (value != null && value.isNotEmpty) {
                              ref.read(siteProvider).updateSite(ref.read(siteProvider).site!.id, {
                                "name": value,
                              }).then((value) {
                                if (value) {
                                  controller.jumpToPage(0);
                                }
                              });
                            }
                          },
                          initialValue: site.site == null ? null : site.site!.name,
                        ),
                        BatchPageMobile(controller: controller),
                        CreateBatch(pageController: controller),
                        BatchImagesScreen(controller: controller),
                        EditBatchName(controller: controller),
                        // This is to edit sector name
                        SiteName(
                          controller: controller,
                          callback: (value) {
                            FocusManager.instance.primaryFocus?.unfocus();
                            ref.watch(siteProvider).sheetHeight = 0.4;
                            if (value != null && value.isNotEmpty) {
                              ref.read(sectorProvider).updateSector(ref.read(sectorProvider).sector!.id, {
                                "name": value,
                              }).then((value) {
                                if (value) {
                                  controller.jumpToPage(0);
                                }
                              });
                            }
                          },
                          hintText: "$sectorText $nameText",
                          initialValue: sector.sector == null ? null : sector.sector!.name,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class BatchPageMobile extends HookConsumerWidget {
  const BatchPageMobile({
    super.key,
    required this.controller,
  });

  final PageController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomCardBar(
          elevation: 0,
          center: true,
          title: ref.read(sectorProvider).sector == null ? emptyString : ref.watch(sectorProvider).sector!.name,
          leadingCallback: () {
            ref.read(siteProvider).subType = SubType.sector;
            controller.jumpToPage(0);
            ref.read(batchProvider).showBatchInfo = false;
          },
          trailingIcon: SectorOptionMenu(
            pageController: controller,
            sector: ref.read(sectorProvider).sector,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: SpacingConstants.size20,
            vertical: SpacingConstants.size10,
          ),
          child: BatchListPage(controller: controller),
        )
      ],
    );
  }
}
