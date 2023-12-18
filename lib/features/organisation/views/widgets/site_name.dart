import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/organisation/data/controller/site_controller.dart';
import 'package:smat_crow/features/organisation/views/widgets/custom_card_bar.dart';
import 'package:smat_crow/features/widgets/custom_button.dart';
import 'package:smat_crow/features/widgets/custom_text_field.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class SiteName extends HookConsumerWidget {
  const SiteName({
    required this.callback,
    required this.controller,
    super.key,
    this.buttonName,
    this.initialValue,
    this.hintText,
  });
  final String? buttonName;
  final Function(String?) callback;
  final PageController controller;
  final String? initialValue;
  final String? hintText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = useState<String?>(initialValue);
    return SingleChildScrollView(
      child: Column(
        children: [
          if (!kIsWeb)
            CustomCardBar(
              title: (initialValue == null && ref.read(siteProvider).subType == SubType.site)
                  ? newSite
                  : (initialValue == null && ref.read(siteProvider).subType == SubType.sector)
                      ? newSector
                      : (initialValue != null && ref.read(siteProvider).subType == SubType.sector)
                          ? "$editSector $nameText"
                          : "$editSite $nameText",
              elevation: 0,
              leadingCallback: () {
                if (initialValue == null) {
                  controller.previousPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                } else {
                  ref.read(siteProvider).subType = SubType.sector;
                  controller.jumpToPage(0);
                }
              },
              trailingIcon: const SizedBox.shrink(),
              center: true,
            ),
          if (!kIsWeb) customSizedBoxHeight(SpacingConstants.size40),
          Padding(
            padding: kIsWeb
                ? EdgeInsets.zero
                : const EdgeInsets.symmetric(
                    horizontal: SpacingConstants.size20,
                  ),
            child: SizedBox(
              width: !Responsive.isMobile(context) ? SpacingConstants.size510 : null,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextField(
                    hintText: hintText ?? siteNameText,
                    onChanged: (p0) => name.value = p0,
                    initialValue: name.value,
                    isRequired: true,
                    onTap: () {
                      ref.watch(siteProvider).sheetHeight = 0.7;
                    },
                    textCapitalization: TextCapitalization.words,
                    text: hintText ?? siteNameText,
                    labelStyle: Styles.smatCrowMediumParagraph(
                      color: AppColors.SmatCrowNeuBlue900,
                    ).copyWith(
                      fontSize: SpacingConstants.font14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  customSizedBoxHeight(SpacingConstants.size20),
                  CustomButton(
                    text: buttonName ?? continueText,
                    onPressed: () => callback(name.value),
                    height: SpacingConstants.size47,
                    color: AppColors.SmatCrowPrimary500,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: Responsive.isDesktop(context) ? SpacingConstants.size40 : MediaQuery.of(context).viewInsets.bottom,
          ),
        ],
      ),
    );
  }
}
