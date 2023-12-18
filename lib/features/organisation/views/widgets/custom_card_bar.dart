import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class CustomCardBar extends HookConsumerWidget {
  const CustomCardBar({
    super.key,
    required this.elevation,
    required this.center,
    this.leadingCallback,
    required this.title,
    this.trailingCallback,
    this.trailingIcon,
    this.textWidth,
    this.width,
  });

  final double? elevation;
  final bool center;
  final VoidCallback? leadingCallback;
  final String title;
  final VoidCallback? trailingCallback;

  final Widget? trailingIcon;
  final double? textWidth;
  final double? width;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.isDesktop(context)
            ? SpacingConstants.size0
            : Responsive.isTablet(context)
                ? SpacingConstants.size30
                : SpacingConstants.size0,
      ),
      child: Card(
        elevation: elevation ?? SpacingConstants.size1,
        margin: EdgeInsets.zero,
        child: SizedBox(
          height: SpacingConstants.size51,
          width: Responsive.isDesktop(context)
              ? width ?? Responsive.xWidth(context, percent: 0.3)
              : Responsive.isTablet(context) || Responsive.isMobile(context)
                  ? Responsive.xWidth(context)
                  : SpacingConstants.size360,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: leadingCallback == null
                ? const SizedBox.shrink()
                : IconButton(
                    onPressed: leadingCallback,
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                      size: SpacingConstants.size20,
                    ),
                    splashRadius: SpacingConstants.size20,
                  ),
            title: center
                ? Center(
                    child: Text(
                      title,
                      style: Theme.of(context).appBarTheme.titleTextStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                : SizedBox(
                    width: textWidth ?? SpacingConstants.size250,
                    child: Text(
                      title,
                      style: Theme.of(context).appBarTheme.titleTextStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
            trailing: trailingIcon ??
                IconButton(
                  onPressed: trailingCallback,
                  splashRadius: SpacingConstants.size20,
                  icon: const Icon(
                    Icons.add_circle_outline,
                    color: AppColors.SmatCrowPrimary500,
                    size: SpacingConstants.size24,
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
