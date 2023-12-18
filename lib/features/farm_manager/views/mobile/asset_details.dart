// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smat_crow/features/farm_manager/data/controller/farm_manager_controller.dart';
import 'package:smat_crow/features/farm_manager/views/mobile/asset_details_farm_logs.dart';
import 'package:smat_crow/features/farm_manager/views/mobile/asset_details_info.dart';
import 'package:smat_crow/features/farm_manager/views/mobile/farm_asset.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/color_600_text.dart';
import 'package:smat_crow/features/organisation/views/widgets/custom_action_widget.dart';
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

class AssetDetails extends HookConsumerWidget {
  const AssetDetails({super.key, this.showHead = true, required this.id});
  final bool showHead;
  final String id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asset = ref.watch(assetProvider);
    final manager = ref.watch(farmManagerProvider);
    useEffect(
      () {
        Future(() => asset.getAssetDetails(id));
        return null;
      },
      [],
    );
    final selectedIndex = useState(0);

    return Scaffold(
      appBar: showHead
          ? customAppBar(
              context,
              title: assetDetailsText,
              actions: [
                if (manager.agentOrg != null &&
                    manager.agentOrg!.permissions!.contains(FarmManagerPermissions.updateAsset))
                  InkWell(
                    onTap: () {
                      if (kIsWeb) {
                        final path = (context.currentBeamLocation.state as BeamState).uri.queryParameters;
                        Pandora().reRouteUser(
                          context,
                          "${ConfigRoute.registerAsset}?assetId=${path["assetId"]}",
                          asset.assetDetails,
                        );
                      } else {
                        Pandora().reRouteUser(context, ConfigRoute.registerAsset, asset.assetDetails);
                      }
                    },
                    child: SvgPicture.asset(AppAssets.edit),
                  ),
                const Xmargin(SpacingConstants.double20)
              ],
            )
          : null,
      body: SingleChildScrollView(
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
                style: Styles.smatCrowHeadingBold5(color: AppColors.SmatCrowNeuBlue900),
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
            if (selectedIndex.value == 0) const AssetDetailsInfo() else AssetDetailsFarmLogs(id: id)
          ],
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () {
          customModalSheet(
            context,
            HookConsumer(
              builder: (context, ref, child) {
                final asset = ref.watch(assetProvider).assetDetails;
                if (asset == null) {
                  return const Center(
                    child: Column(
                      children: [
                        EmptyListWidget(
                          text: "No Thread at the moment",
                          asset: AppAssets.emptyImage,
                        )
                      ],
                    ),
                  );
                }

                return SizedBox(
                  height: Responsive.yHeight(context, percent: 0.95),
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
                                Color600Text(
                                  text: 'To manage farm logs and get team members\nfeedback on time',
                                ),
                              ],
                            ),
                            IconButton(
                              splashRadius: SpacingConstants.double20,
                              onPressed: () {
                                Navigator.pop(context);
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
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: asset.additionalInfo != null
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: asset.additionalInfo!.assetThreads!.reversed
                                        .map(
                                          (e) => Padding(
                                            padding: const EdgeInsets.only(bottom: 10.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                                const Ymargin(SpacingConstants.size5),
                                                Color600Text(
                                                  text:
                                                      "Sent: ${DateFormat.Hm().format(e.createdDate ?? DateTime.now())}",
                                                )
                                              ],
                                            ),
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
                      HookBuilder(
                        builder: (context) {
                          final thread = useTextEditingController();
                          return Padding(
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
                                    FocusScope.of(context).unfocus();
                                    if (thread.text.trim().isNotEmpty) {
                                      await ref.read(assetProvider).addAssetThread(
                                            thread.text,
                                            asset.assets!.uuid ?? "",
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
                          );
                        },
                      ),
                      SizedBox(height: MediaQuery.of(context).viewInsets.bottom)
                    ],
                  ),
                );
              },
            ),
          );
        },
        child: CircleAvatar(
          radius: SpacingConstants.size25,
          backgroundColor: AppColors.SmatCrowPrimary500,
          child: SvgPicture.asset(AppAssets.message),
        ),
      ),
    );
  }
}
