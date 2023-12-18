import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/organisation/data/models/menu_item_model.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class SidebarItem extends StatefulWidget {
  const SidebarItem({
    super.key,
    required this.menuItem,
    this.isSelected = false,
    required this.selected,
  });

  final MenuItemModel menuItem;
  final bool isSelected;
  final String selected;

  @override
  State<SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<SidebarItem> {
  bool isHovered = false;

  void _toggleHover(bool isHovered) {
    setState(() {
      this.isHovered = isHovered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _toggleHover(true),
      onExit: (_) => _toggleHover(false),
      child: HookConsumer(
        builder: (context, ref, child) {
          return Container(
            height: SpacingConstants.size48,
            width: widget.selected == ConfigRoute.manageOrgRoute
                ? null
                : SpacingConstants.size270,
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? Colors.white
                  : isHovered
                      ? AppColors.SmatCrowPrimary100
                      : null,
              border: Border(
                right: BorderSide(
                  color: widget.isSelected
                      ? AppColors.SmatCrowPrimary500
                      : Colors.white,
                  width: 3,
                ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: widget.selected != ConfigRoute.manageOrgRoute
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  widget.menuItem.asset,
                  color: widget.isSelected
                      ? AppColors.SmatCrowPrimary500
                      : AppColors.SmatCrowNeuBlue400,
                ),
                if (widget.selected != ConfigRoute.manageOrgRoute)
                  customSizedBoxWidth(SpacingConstants.size20),
                if (widget.selected != ConfigRoute.manageOrgRoute)
                  Text(
                    widget.menuItem.name,
                    style: Styles.smatCrowMediumSubParagraph(
                      color: widget.isSelected
                          ? AppColors.SmatCrowNeuBlue900
                          : AppColors.SmatCrowNeuBlue500,
                    ).copyWith(
                      fontWeight:
                          widget.isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  )
              ],
            ),
          );
        },
      ),
    );
  }
}
