import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_manager/views/mobile/register_asset.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/colored_container.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class FilterOption extends HookConsumerWidget {
  const FilterOption({super.key, required this.value, required this.list, required this.title, this.child});

  final ValueNotifier<String?> value;
  final List<AssetStatus> list;
  final String title;
  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: SpacingConstants.double20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BoldHeaderText(text: title),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.keyboard_arrow_down),
              )
            ],
          ),
        ),
        ...list
            .map(
              (e) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio(
                    value: value.value == e.name,
                    groupValue: true,
                    onChanged: (val) {
                      value.value = e.name;
                    },
                  ),
                  InkWell(
                    onTap: () {
                      value.value = e.name;
                    },
                    child: ColoredContainer(
                      color: e.color,
                      text: e.name,
                    ),
                  )
                ],
              ),
            )
            .toList(),
        child ?? const SizedBox.shrink()
      ],
    );
  }
}
