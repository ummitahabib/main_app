import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:one_context/one_context.dart';
import 'package:smat_crow/features/farm_manager/views/mobile/register_asset.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/filter_option.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/select_container.dart';
import 'package:smat_crow/features/organisation/views/widgets/dialog_header.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/features/widgets/custom_button.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class AssetFilter extends HookConsumerWidget {
  const AssetFilter({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shared = ref.watch(sharedProvider);
    return HookBuilder(
      builder: (context) {
        final assetStatus = useState<String?>(null);
        final assetFlag = useState<String?>(null);
        final assetLifeSpan = useState<Map<String, ValueNotifier<String?>>>(
          {"start": useState<String?>(null), "end": useState<String?>(null)},
        );
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DialogHeader(
              headText: filterByText,
              callback: () {
                if (Responsive.isMobile(context)) {
                  Navigator.pop(context);
                  return;
                }
                OneContext().popDialog();
              },
              showIcon: true,
            ),
            FilterOption(
              list: shared.assetStatusList
                  .map(
                    (e) => AssetStatus(
                      dummyAssetStatusList
                          .firstWhere(
                            (element) => element.name.toLowerCase().contains(
                                  (e.status ?? emptyString).toLowerCase(),
                                ),
                            orElse: () => dummyAssetStatusList.first,
                          )
                          .color,
                      e.status ?? "",
                    ),
                  )
                  .toList(),
              value: assetStatus,
              title: assetStatusText,
            ),
            const Divider(),
            FilterOption(
              list: shared.flagList
                  .map(
                    (e) => AssetStatus(AppColors.SmatCrowNeuBlue900, e.flag ?? ""),
                  )
                  .toList(),
              value: assetFlag,
              title: assetFlagText,
            ),
            const Divider(),
            FilterOption(
              value: ValueNotifier(emptyString),
              list: const [],
              title: purchaseDateText,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: SpacingConstants.double20,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SelectContainer(
                        value: assetLifeSpan.value['start']!.value,
                        title: "",
                        hintText: startDateText,
                        function: () async {
                          if (FocusScope.of(context).hasFocus) {
                            FocusScope.of(context).unfocus();
                          }
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            currentDate: DateTime.now(),
                          );
                          if (date != null) {
                            assetLifeSpan.value['start']!.value = DateFormat("dd-MM-yyyy").format(date);
                          }
                        },
                      ),
                    ),
                    const Xmargin(SpacingConstants.size10),
                    Expanded(
                      child: SelectContainer(
                        value: assetLifeSpan.value['end']!.value,
                        title: "",
                        hintText: endDateText,
                        function: () async {
                          if (FocusScope.of(context).hasFocus) {
                            FocusScope.of(context).unfocus();
                          }
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            currentDate: DateTime.now(),
                          );
                          if (date != null) {
                            assetLifeSpan.value['end']!.value = DateFormat("dd-MM-yyyy").format(date);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(SpacingConstants.double20),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: resetFilter,
                      onPressed: () {
                        assetStatus.value = null;
                        assetLifeSpan.value['end']!.value = null;
                        assetLifeSpan.value['start']!.value = null;
                        assetFlag.value = null;
                      },
                      leftIcon: Icons.clear,
                      color: AppColors.SmatCrowNeuBlue100,
                    ),
                  ),
                  const Xmargin(SpacingConstants.double20),
                  Expanded(
                    child: CustomButton(
                      text: applyFilter,
                      onPressed: () {},
                      leftIcon: Icons.add,
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
