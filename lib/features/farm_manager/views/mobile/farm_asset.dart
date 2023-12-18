import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smat_crow/features/farm_manager/data/controller/farm_manager_controller.dart';
import 'package:smat_crow/features/farm_manager/views/mobile/register_asset.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/app_material.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/colored_container.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/item_row.dart';
import 'package:smat_crow/features/organisation/views/widgets/empty_list_widget.dart';
import 'package:smat_crow/features/shared/data/controller/asset_controller.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/features/shared/views/custom_app_bar.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/features/widgets/custom_text_field.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/farmmanager/widgets/grid_loader.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/permission_constant.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

var _page = 2;

class FarmAssetMobile extends HookConsumerWidget {
  const FarmAssetMobile({super.key, this.actions, this.title});

  final List<Widget>? actions;
  final String? title;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asset = ref.watch(assetProvider);
    final shared = ref.watch(sharedProvider);
    final manager = ref.watch(farmManagerProvider);
    final controller = useScrollController();
    useEffect(
      () {
        Future(() {
          asset.getOrgAssets();
          if (shared.flagList.isEmpty) {
            shared.getFlags();
          }
          controller.addListener(() async {
            if (controller.position.atEdge) {
              final isTop = controller.position.pixels == 0;
              if (!isTop && !asset.loadMore) {
                await asset.getMoreOrgAssets(queries: {'page': _page});
                _page++;
              }
            }
          });
        });
        return null;
      },
      [],
    );
    final search = useState("");

    return Scaffold(
      appBar: customAppBar(
        context,
        title: farmAssetText,
        actions: actions ??
            [
              if (manager.agentOrg != null &&
                  manager.agentOrg!.permissions!.contains(FarmManagerPermissions.createAsset))
                InkWell(
                  onTap: () {
                    asset.assetDetails = null;
                    Pandora().reRouteUser(
                      context,
                      ConfigRoute.registerAsset,
                      "args",
                    );
                  },
                  child: Ink(
                    padding: const EdgeInsets.symmetric(
                      vertical: SpacingConstants.font10,
                      horizontal: SpacingConstants.double20,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: AppColors.SmatCrowPrimary500,
                    ),
                  ),
                ),
            ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(SpacingConstants.size20),
        controller: controller,
        child: Builder(
          builder: (context) {
            if (asset.loading) {
              return const GridLoader(arrangement: 1);
            }

            if (asset.orgAssetList.isEmpty) {
              return const EmptyListWidget(
                text: noFarmAssetText,
                asset: AppAssets.emptyImage,
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  hintText: searchAssetText,
                  onChanged: (val) {
                    search.value = val;
                  },
                  text: emptyString,
                  initialValue: search.value,
                  prefixIcon: const Icon(Icons.search_rounded),
                ),
                const Ymargin(SpacingConstants.double20),
                Wrap(
                  runSpacing: SpacingConstants.double20,
                  spacing: SpacingConstants.double20,
                  children: [
                    ...asset.orgAssetList
                        .where(
                          (e) => e.assets!.name!.toLowerCase().contains(search.value.toLowerCase()),
                        )
                        .map(
                          (e) => InkWell(
                            onTap: () {
                              asset.assetDetails = e;
                              Pandora().reRouteUser(
                                context,
                                ConfigRoute.assetDetails,
                                e.assets!.uuid,
                              );
                            },
                            child: AppMaterial(
                              width: Responsive.isTablet(context)
                                  ? Responsive.xWidth(
                                      context,
                                      percent: SpacingConstants.size0point45,
                                    )
                                  : null,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: SpacingConstants.font16,
                                  vertical: SpacingConstants.font10,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "${getAssetTypeIcon(e.assets!.type ?? "")} ${e.assets!.name}",
                                          style: Styles.smatCrowMediumBody(
                                            color: AppColors.SmatCrowOffBlackLabel,
                                          ),
                                        ),
                                        const Spacer(),
                                        ColoredContainer(
                                          color: dummyAssetStatusList
                                              .firstWhere(
                                                (element) => element.name == (e.assets!.status ?? ""),
                                                orElse: () => dummyAssetStatusList.first,
                                              )
                                              .color,
                                          text: e.assets!.status ?? "",
                                        )
                                      ],
                                    ),
                                    const Ymargin(SpacingConstants.font16),
                                    ItemRow(
                                      asset: AppAssets.compass,
                                      title: assetTypeText,
                                      body: e.assets!.type ?? "",
                                    ),
                                    ItemRow(
                                      asset: AppAssets.flag,
                                      title: assetFlagText,
                                      body: (e.assets!.assetFlags!.isNotEmpty && shared.flagList.isNotEmpty)
                                          ? shared.flagList
                                                  .firstWhere(
                                                    (element) => element.uuid == e.assets!.assetFlags!.first,
                                                    orElse: () => shared.flagList.first,
                                                  )
                                                  .flag ??
                                              ""
                                          : null,
                                    ),
                                    ItemRow(
                                      asset: AppAssets.calendar,
                                      title: purchaseDateText,
                                      body: DateFormat("dd/MM/yyyy").format(
                                        e.assets!.acquisitionDate ?? DateTime.now(),
                                      ),
                                    ),
                                    ItemRow(
                                      asset: AppAssets.flash,
                                      title: "Status",
                                      body: e.assets!.deleted == "N" ? "Published" : "Draft",
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                  ],
                ),
                if (asset.loadMore)
                  const Center(
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator.adaptive(),
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

String getAssetTypeIcon(String type) {
  switch (type) {
    case "Material":
      return '🚙';
    case "Plant":
      return '🌴';
    case "Seed":
      return '🫘';
    case "Water":
      return '💦';
    case "Manure":
      return '🐄';
    default:
      return "🚜";
  }
}
