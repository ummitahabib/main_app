import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/organisation/views/widgets/custom_card_bar.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/responsive.dart';

class HomeWebContainer extends HookConsumerWidget {
  const HomeWebContainer({
    super.key,
    required this.title,
    this.leadingCallback,
    this.trailingCallback,
    required this.child,
    this.width,
    this.elevation,
    this.center = false,
    this.trailingIcon,
    this.addSpacing,
    this.childHeight,
  });
  final String title;
  final VoidCallback? leadingCallback;
  final VoidCallback? trailingCallback;
  final Widget child;
  final double? width;
  final double? elevation;
  final bool center;
  final Widget? trailingIcon;
  final bool? addSpacing;
  final double? childHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: AppColors.SmatCrowNeuBlue100)),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            CustomCardBar(
              elevation: elevation,
              center: center,
              leadingCallback: leadingCallback,
              title: title,
              width: width,
              trailingCallback: trailingCallback,
              trailingIcon: trailingIcon,
            ),
            SizedBox(
              height: childHeight ?? Responsive.yHeight(context, percent: 0.75),
              child: child,
            )
          ],
        ),
      ),
    );
  }
}
