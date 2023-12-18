import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smat_crow/features/farm_manager/data/controller/farm_manager_controller.dart';
import 'package:smat_crow/features/farm_manager/views/mobile/asset_details_info.dart';
import 'package:smat_crow/features/farm_manager/views/mobile/farm_asset.dart';
import 'package:smat_crow/features/farm_manager/views/web/farm_asset_details_log_web.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/color_600_text.dart';
import 'package:smat_crow/features/organisation/views/widgets/empty_list_widget.dart';
import 'package:smat_crow/features/organisation/views/widgets/tap_card.dart';
import 'package:smat_crow/features/shared/data/controller/asset_controller.dart';
import 'package:smat_crow/features/shared/views/custom_app_bar.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/features/widgets/custom_text_field.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/permission_constant.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class FarmAssetDetailsWeb extends HookConsumerWidget {
  const FarmAssetDetailsWeb({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asset = ref.watch(assetProvider);
    final manager = ref.watch(farmManagerProvider);
    final path = (context.currentBeamLocation.state as BeamState).uri.queryParameters;
    final id = (context.currentBeamLocation.state as BeamState).uri.pathSegments;
    useEffect(
      () {
        Future(() => asset.getAssetDetails(path["assetId"] ?? ""));
        return null;
      },
      [],
    );
    final selectedIndex = useState(0);
    final thread = useTextEditingController();
    return Scaffold(
      key: _scaffoldKey,
      appBar: customAppBar(
        context,
        onTap: () {
          context.beamToReplacementNamed("${ConfigRoute.farmAsset}/${id.last}");
        },
        title: assetDetailsText,
        center: false,
        actions: [
          if (manager.agentOrg != null && manager.agentOrg!.permissions!.contains(FarmManagerPermissions.updateAsset))
            InkWell(
              onTap: () {
                Pandora().reRouteUser(
                  context,
                  "${ConfigRoute.registerAsset}?assetId=${path["assetId"]}",
                  asset.assetDetails,
                );
              },
              child: SvgPicture.asset(AppAssets.edit),
            ),
          const Xmargin(SpacingConstants.double20)
        ],
      ),
      floatingActionButton: InkWell(
        onTap: () {
          _scaffoldKey.currentState!.openEndDrawer();
        },
        child: CircleAvatar(
          radius: SpacingConstants.size25,
          backgroundColor: AppColors.SmatCrowPrimary500,
          child: SvgPicture.asset(AppAssets.message),
        ),
      ),
      endDrawer: Drawer(
        width: SpacingConstants.size600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SpacingConstants.double20,
                vertical: SpacingConstants.font10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BoldHeaderText(text: "Thread"),
                      Ymargin(SpacingConstants.size5),
                      Flexible(
                        child: Color600Text(
                          text: 'To manage farm asset and get team members feedback on time',
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    splashRadius: SpacingConstants.double20,
                    onPressed: () {
                      _scaffoldKey.currentState!.closeEndDrawer();
                    },
                    icon: const Icon(
                      Icons.clear,
                      color: AppColors.SmatCrowNeuBlue500,
                    ),
                  )
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: SizedBox(
                height: Responsive.yHeight(
                  context,
                  percent: SpacingConstants.size0point85,
                ),
                child: SingleChildScrollView(
                  child: asset.assetDetails != null
                      ? Column(
                          children: asset.assetDetails!.additionalInfo!.assetThreads!
                              .map(
                                (e) => Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: AppColors.SmatCrowNeuBlue100,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(
                                            SpacingConstants.size8,
                                          ),
                                          topRight: Radius.circular(
                                            SpacingConstants.size8,
                                          ),
                                          bottomRight: Radius.circular(
                                            SpacingConstants.size8,
                                          ),
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: SpacingConstants.font12,
                                        vertical: SpacingConstants.size6,
                                      ),
                                      child: Text(e.url ?? emptyString),
                                    ),
                                    const Ymargin(SpacingConstants.font10),
                                    Color600Text(
                                      text: "Sent: ${DateFormat.Hm().format(e.createdDate ?? DateTime.now())}",
                                    )
                                  ],
                                ),
                              )
                              .toList(),
                        )
                      : const Center(
                          child: Column(
                            children: [
                              EmptyListWidget(
                                text: "No Thread at the moment",
                                asset: AppAssets.emptyImage,
                              )
                            ],
                          ),
                        ),
                ),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SpacingConstants.double20,
                vertical: SpacingConstants.font10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: CustomTextField(
                      hintText: "Send message",
                      text: "",
                      controller: thread,
                    ),
                  ),
                  const Xmargin(SpacingConstants.double20),
                  InkWell(
                    onTap: () async {
                      if (thread.text.trim().isNotEmpty) {
                        await ref.read(assetProvider).addAssetThread(
                              thread.text,
                              path["assetId"] ?? "",
                            );
                        thread.text = "";
                        thread.notifyListeners();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(SpacingConstants.font10),
                      decoration: BoxDecoration(
                        color: AppColors.SmatCrowPrimary500,
                        borderRadius: BorderRadius.circular(SpacingConstants.font10),
                      ),
                      child: ref.watch(assetProvider).loading
                          ? const CircularProgressIndicator.adaptive()
                          : SvgPicture.asset(
                              AppAssets.invite,
                              color: AppColors.SmatCrowNeuBlue900,
                            ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      body: (asset.assetDetails == null)
          ? const EmptyListWidget(
              text: "Asset details not available at this moment",
              asset: AppAssets.emptyImage,
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(SpacingConstants.double20),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Text(
                      getAssetTypeIcon(asset.assetDetails!.assets!.name ?? ""),
                      style: const TextStyle(fontSize: SpacingConstants.font32),
                    ),
                    title: Text(
                      "${asset.assetDetails!.assets!.name}",
                      style: Styles.smatCrowHeadingBold5(
                        color: AppColors.SmatCrowNeuBlue900,
                      ),
                    ),
                    subtitle: Color600Text(
                      text: "${asset.assetDetails!.assets!.type} $assetText",
                    ),
                  ),
                  const Ymargin(SpacingConstants.double20),
                  Container(
                    height: SpacingConstants.size32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(SpacingConstants.size8),
                      color: AppColors.SmatCrowNeuBlue100,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: TapCard(
                            selectedIndex: selectedIndex.value,
                            tap: () {
                              selectedIndex.value = 0;
                            },
                            name: infoText,
                            index: 0,
                          ),
                        ),
                        Expanded(
                          child: TapCard(
                            index: 1,
                            selectedIndex: selectedIndex.value,
                            tap: () {
                              selectedIndex.value = 1;
                            },
                            name: farmLogText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Ymargin(SpacingConstants.double20),
                  if (selectedIndex.value == 0) const AssetDetailsInfo() else const FarmAssetDetailLogsWeb()
                ],
              ),
            ),
    );
  }
}
