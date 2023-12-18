import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:one_context/one_context.dart';
import 'package:smat_crow/features/farm_manager/data/controller/farm_manager_controller.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/organisation/views/widgets/dialog_header.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/features/shared/views/custom_app_bar.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/features/widgets/custom_button.dart';
import 'package:smat_crow/features/widgets/custom_drop_down.dart';
import 'package:smat_crow/features/widgets/custom_text_field.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class CreateBudget extends HookConsumerWidget {
  const CreateBudget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final farmSeason = useState<String?>(null);
    final budgetAmount = useState<String?>(null);
    final shared = ref.watch(sharedProvider);
    final farmDash = ref.watch(farmManagerProvider);
    useEffect(
      () {
        if (farmDash.budget != null) {
          budgetAmount.value = farmDash.budget!.seasonBudget.toString();
        }
        if (shared.season != null) {
          farmSeason.value = shared.season!.description;
        }
        Future(() {
          if (shared.seasonList.isEmpty) {
            shared.getSeasons();
          }
        });
        return null;
      },
      [],
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(SpacingConstants.font10),
      child: Scaffold(
        appBar: Responsive.isDesktop(context) ? null : customAppBar(context),
        resizeToAvoidBottomInset: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (Responsive.isDesktop(context))
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  DialogHeader(
                    headText: createBudgetText,
                    callback: () {
                      OneContext().popDialog();
                    },
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    showDivider: false,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(SpacingConstants.double20),
                    child: Text(
                      createBudgetLabel,
                      style: Styles.smatCrowParagraphRegular(color: AppColors.SmatCrowNeuBlue400),
                    ),
                  ),
                ],
              ),
            if (Responsive.isDesktop(context)) const Divider(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(SpacingConstants.double20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!Responsive.isDesktop(context))
                      const BoldHeaderText(
                        text: createBudgetText,
                        fontSize: SpacingConstants.font28,
                      ),
                    if (!Responsive.isDesktop(context)) const Ymargin(SpacingConstants.size5),
                    if (!Responsive.isDesktop(context))
                      Text(
                        createBudgetLabel,
                        style: Styles.smatCrowParagraphRegular(color: AppColors.SmatCrowNeuBlue400),
                      ),
                    if (!Responsive.isDesktop(context)) const Ymargin(SpacingConstants.size20),
                    CustomTextField(
                      initialValue: budgetAmount.value,
                      hintText: enterBudgetAmountText,
                      onChanged: (value) {
                        budgetAmount.value = value;
                      },
                      text: budgetAmountText,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CurrencyTextInputFormatter(name: ""),
                      ],
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                    const Ymargin(SpacingConstants.size20),
                    CustomDropdownField(
                      items: shared.seasonList.map((e) => e.description ?? "").toList(),
                      value: shared.season == null ? null : shared.season!.description,
                      hintText: selectYourOption,
                      labelText: farmingSeasonText,
                      onChanged: (value) {
                        farmSeason.value = value.toString();
                        shared.season = shared.seasonList.firstWhere((element) => element.description == value);
                      },
                      hintStyle: Styles.smatCrowSubParagraphRegular(color: AppColors.SmatCrowNeuBlue400),
                      decoration: BoxDecoration(
                        color: AppColors.SmatCrowNeuBlue50,
                        borderRadius: BorderRadius.circular(SpacingConstants.size8),
                        border: Border.all(color: AppColors.SmatCrowNeuBlue200),
                      ),
                    ),
                    const Ymargin(SpacingConstants.size20),
                    const Ymargin(SpacingConstants.size100),
                    CustomButton(
                      loading: ref.watch(farmManagerProvider).loading,
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (farmSeason.value == null || budgetAmount.value == null) {
                          snackBarMsg(validationWarningText);
                          return;
                        }
                        if (farmDash.budget != null) {
                          ref
                              .read(farmManagerProvider)
                              .updateBudget(
                                farmDash.budget!.uuid ?? "",
                                double.parse(budgetAmount.value!.replaceAll(",", "")).toInt(),
                              )
                              .then((value) {
                            if (value) {
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              } else {
                                OneContext().popDialog();
                              }
                            }
                          });
                        } else {
                          ref
                              .read(farmManagerProvider)
                              .createBudget(double.parse(budgetAmount.value!.replaceAll(",", "")).toInt())
                              .then((value) {
                            if (value) {
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              } else {
                                OneContext().popDialog();
                              }
                            }
                          });
                        }
                      },
                      text: farmDash.budget != null ? updateBudgetText : createBudgetText,
                      color: AppColors.SmatCrowPrimary500,
                    ),
                    SizedBox(
                      height: Responsive.isDesktop(context)
                          ? SpacingConstants.size40
                          : MediaQuery.of(context).viewInsets.bottom,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
