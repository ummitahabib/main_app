import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_manager/views/mobile/log_type_table_mobile.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/app_container.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/shared/data/controller/asset_controller.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/features/shared/views/custom_app_bar.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/features/widgets/custom_text_field.dart';
import 'package:smat_crow/screens/farmmanager/widgets/grid_loader.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class AssetLogDetails extends HookConsumerWidget {
  const AssetLogDetails({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = useState("");
    final shared = ref.watch(sharedProvider);
    final assets = ref.watch(assetProvider);
    useEffect(
      () {
        Future(() {
          if (shared.logStatusList.isEmpty) {
            shared.getLogStatus();
          }
          assets.getAssetLogs(queries: {"logTypeName": shared.logType!.types, "pageSize": 30});

          if (assets.assetLogsList.isNotEmpty) {
            selected.value = assets.assetLogsList.first.log!.status ?? "";
          }
        });
        return null;
      },
      [],
    );
    final search = useState("");
    return Scaffold(
      appBar: customAppBar(context, title: logDetailsText),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(SpacingConstants.double20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                BoldHeaderText(
                  text: shared.logType != null ? (shared.logType!.types ?? emptyString) : emptyString,
                  fontSize: SpacingConstants.font24,
                ),
                const Spacer(),
              ],
            ),
            const Ymargin(SpacingConstants.double20),
            CustomTextField(
              hintText: "Search",
              text: "",
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.SmatCrowNeuBlue900,
              ),
              onChanged: (value) {
                search.value = value;
              },
            ),
            const Ymargin(SpacingConstants.double20),
            Builder(
              builder: (context) {
                if (assets.loading) {
                  return const GridLoader(arrangement: 1);
                }
                if (assets.assetLogsList.isEmpty) {
                  return const AppContainer(
                    width: double.maxFinite,
                    color: AppColors.SmatCrowGrayScaleLabel,
                    child: Text(noLogFound),
                  );
                }
                return LogTypeTableMobile(
                  log: assets.assetLogsList
                      .where((element) => element.log!.name!.toLowerCase().contains(search.value..toLowerCase()))
                      .toList(),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
