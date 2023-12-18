import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/organisation/data/controller/batch_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/site_controller.dart';
import 'package:smat_crow/features/organisation/views/widgets/home_web_container.dart';
import 'package:smat_crow/features/organisation/views/widgets/site_name.dart';
import 'package:smat_crow/features/widgets/custom_button.dart';
import 'package:smat_crow/features/widgets/custom_text_field.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class EditBatchName extends HookConsumerWidget {
  const EditBatchName({
    super.key,
    required this.controller,
  });
  final PageController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = useState<String?>(null);
    return HomeWebContainer(
      title: "$edit $batchNameText",
      width: SpacingConstants.size360,
      leadingCallback: () {
        controller.previousPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      },
      elevation: kIsWeb ? null : 0,
      center: kIsWeb ? false : true,
      trailingIcon: const SizedBox.shrink(),
      child: Padding(
        padding: const EdgeInsets.all(SpacingConstants.size20),
        child: kIsWeb
            ? SiteName(
                initialValue: ref.read(batchProvider).batch != null ? ref.read(batchProvider).batch!.name : null,
                callback: (value) {
                  if (value != null && value.trim().isNotEmpty) {
                    ref.read(batchProvider).updateBatch(ref.read(batchProvider).batch!.id!, {
                      "name": value,
                    }).then((value) {
                      if (value) {
                        controller.previousPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOut,
                        );
                        ref.read(siteProvider).subType = SubType.sector;
                      }
                    });
                  } else {
                    snackBarMsg(nameWarning);
                  }
                },
                hintText: batchNameText,
                buttonName: saveChanges,
                controller: controller,
              )
            : Column(
                children: [
                  CustomTextField(
                    hintText: batchNameText,
                    onChanged: (p0) => name.value = p0,
                    initialValue: ref.read(batchProvider).batch != null ? ref.watch(batchProvider).batch!.name : null,
                    isRequired: true,
                    textCapitalization: TextCapitalization.words,
                    text: batchNameText,
                    labelStyle: Styles.smatCrowMediumParagraph(
                      color: AppColors.SmatCrowNeuBlue900,
                    ).copyWith(
                      fontSize: SpacingConstants.font14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  customSizedBoxHeight(SpacingConstants.size20),
                  CustomButton(
                    text: saveChanges,
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (name.value != null && name.value!.trim().isNotEmpty) {
                        ref.read(batchProvider).updateBatch(ref.read(batchProvider).batch!.id!, {
                          "name": name.value,
                        }).then((value) {
                          if (value) {
                            controller.previousPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOut,
                            );
                            ref.read(siteProvider).subType = SubType.sector;
                          }
                        });
                      } else {
                        snackBarMsg(nameWarning);
                      }
                    },
                    height: SpacingConstants.size47,
                    color: AppColors.SmatCrowPrimary500,
                  )
                ],
              ),
      ),
    );
  }
}
