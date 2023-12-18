import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/institution/data/controller/institution_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/map_controller.dart';
import 'package:smat_crow/features/shared/data/controller/asset_controller.dart';
import 'package:smat_crow/features/shared/data/controller/log_controller.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class InstitutionMenu extends HookConsumerWidget {
  const InstitutionMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shared = ref.watch(sharedProvider);
    final logController = ref.watch(logProvider);
    final beamState = Beamer.of(context).currentBeamLocation.state as BeamState;
    final id = beamState.pathPatternSegments.last;
    useEffect(
      () {
        Future(() {
          if (shared.logTypesList.isEmpty) {
            shared.getLogTypes();
          }
          if (shared.assetTypesList.isEmpty) {
            shared.getAssetTypes();
          }
          if (shared.flagList.isEmpty) {
            shared.getFlags();
          }
          if (shared.currencyList.isEmpty) {
            shared.getCurrencies();
          }
        });
        return null;
      },
      [],
    );
    return Column(
      children: [
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
              ref.read(institutionProvider).selectedMenu = index;
              if (ref.read(institutionProvider).selectedMenu == 0) {
                Future.delayed(const Duration(seconds: 2), () => ref.read(mapProvider).getSiteBounds());
              }
            },
            child: Container(
              padding: const EdgeInsets.all(SpacingConstants.font12),
              decoration: BoxDecoration(
                color:
                    ref.watch(institutionProvider).selectedMenu == index ? AppColors.SmatCrowPrimary100 : Colors.white,
                border: Border(
                  left: BorderSide(
                    width: SpacingConstants.size2,
                    color: ref.watch(institutionProvider).selectedMenu == index
                        ? AppColors.SmatCrowPrimary500
                        : Colors.white,
                  ),
                ),
              ),
              width: double.maxFinite,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: SpacingConstants.font32,
                    height: SpacingConstants.font32,
                    child: Image.asset(menuList[index].asset),
                  ),
                  const Xmargin(SpacingConstants.font10),
                  Text(
                    menuList[index].name,
                    style: Styles.smatCrowSubParagraphRegular(color: AppColors.SmatCrowNeuBlue900),
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
        Container(
          padding: const EdgeInsets.all(SpacingConstants.font12),
          decoration: BoxDecoration(
            color: ref.watch(institutionProvider).selectedMenu == 4 ? AppColors.SmatCrowPrimary100 : Colors.white,
            borderRadius: BorderRadius.circular(SpacingConstants.font10),
          ),
          width: double.maxFinite,
          child: Row(
            children: [
              Image.asset(AppAssets.plant),
              const Xmargin(SpacingConstants.font10),
              Text(
                farmLogText,
                style: Styles.smatCrowSubParagraphRegular(color: AppColors.SmatCrowNeuBlue900),
              ),
              const Spacer(),
              PopupMenuButton(
                itemBuilder: (context) => shared.logTypesList
                    .map(
                      (e) => PopupMenuItem(
                        value: e,
                        child: Text(e.types ?? ""),
                        onTap: () {
                          shared.logType = e;
                          logController
                              .getOrgLogs(queries: {"logTypeName": shared.logType!.types, "pageSize": "30"}, orgId: id);
                          ref.read(institutionProvider).selectedMenu = 4;
                        },
                      ),
                    )
                    .toList(),
                child: const Icon(
                  Icons.arrow_forward_ios,
                  size: SpacingConstants.font14,
                  color: AppColors.SmatCrowNeuBlue900,
                ),
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(SpacingConstants.font12),
          decoration: BoxDecoration(
            color: ref.watch(institutionProvider).selectedMenu == 5 ? AppColors.SmatCrowPrimary100 : Colors.white,
            borderRadius: BorderRadius.circular(SpacingConstants.font10),
          ),
          width: double.maxFinite,
          child: Row(
            children: [
              Image.asset(AppAssets.barrow),
              const Xmargin(SpacingConstants.font10),
              Text(
                farmAssetText,
                style: Styles.smatCrowSubParagraphRegular(color: AppColors.SmatCrowNeuBlue900),
              ),
              const Spacer(),
              PopupMenuButton(
                itemBuilder: (context) => shared.assetTypesList
                    .map(
                      (e) => PopupMenuItem(
                        value: e,
                        child: Text(e.types ?? ""),
                        onTap: () {
                          shared.assetTypes = e;
                          ref.read(institutionProvider).selectedMenu = 5;
                          ref.read(assetProvider).getOrgAssets(orgId: id, queries: {"assetTypeName": e.types});
                        },
                      ),
                    )
                    .toList(),
                onSelected: (value) {
                  ref.watch(institutionProvider).selectedMenu = 5;
                },
                child: const Icon(
                  Icons.arrow_forward_ios,
                  size: SpacingConstants.font14,
                  color: AppColors.SmatCrowNeuBlue900,
                ),
              )
            ],
          ),
        ),
        InkWell(
          onTap: () => ref.watch(institutionProvider).selectedMenu = 6,
          child: Container(
            padding: const EdgeInsets.all(SpacingConstants.font12),
            decoration: BoxDecoration(
              color: ref.watch(institutionProvider).selectedMenu == 6 ? AppColors.SmatCrowPrimary100 : Colors.white,
              borderRadius: BorderRadius.circular(SpacingConstants.font10),
            ),
            width: double.maxFinite,
            child: Row(
              children: [
                SizedBox(
                  width: SpacingConstants.font32,
                  height: SpacingConstants.font32,
                  child: Image.asset(AppAssets.famer),
                ),
                const Xmargin(SpacingConstants.font10),
                Text(
                  agentsText,
                  style: Styles.smatCrowSubParagraphRegular(color: AppColors.SmatCrowNeuBlue900),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class NameImage {
  final String name;
  final String asset;
  final Color color;
  final String details;
  NameImage(this.name, this.asset, this.color, this.details);
}

final menuList = [
  NameImage(mapViewText, "assets2/images/38.png", Colors.white, ''),
  NameImage(financeDashText, "assets2/images/38-1.png", Colors.white, ''),
  NameImage(weatherText, "assets2/images/Cloud 3 zap.png", Colors.white, ''),
  NameImage(soilDataText, "assets2/images/39.png", Colors.white, ''),
  // NameImage("Soil Analysis Mission", "assets2/images/32.png"),
];
