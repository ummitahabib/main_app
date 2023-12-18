import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class OrgCategories extends HookConsumerWidget {
  const OrgCategories({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expand = useState(true);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: SpacingConstants.int400),
            color: Colors.white,
            child: Wrap(
              spacing: SpacingConstants.font10,
              runSpacing: SpacingConstants.font10,
              children: [
                ...List.generate(
                  expand.value ? _list.length : 2,
                  (index) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(SpacingConstants.font10),
                      color: AppColors.SmatCrowNeuBlue100,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: SpacingConstants.font10,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _list[index],
                          style: Styles.smatCrowSubParagraphRegular(color: AppColors.SmatCrowNeuBlue900)
                              .copyWith(fontSize: SpacingConstants.font12),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: SpacingConstants.size4),
                          child: Icon(
                            Icons.arrow_drop_up_rounded,
                            color: AppColors.SmatCrowNeuBlue900,
                            size: SpacingConstants.size30,
                          ),
                        )
                      ],
                    ),
                  ),
                ).toList()
              ],
            ),
          ),
        ),
        const Xmargin(SpacingConstants.size5),
        InkWell(
          onTap: () {
            expand.value = !expand.value;
          },
          child: Icon(
            expand.value ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            size: SpacingConstants.font32,
          ),
        )
      ],
    );
  }
}

final _list = ['Revenue', "Number of Logs Created", "Number of Assets", "Number of Users", "Warehouse Output"];
