import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/features/presentation/pages/stories/widgets/post_and_story_modal.dart';
import 'package:smat_crow/features/presentation/provider/get_single_user.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/AppHelper.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  const AppBarWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  void initState() {
    super.initState();
    Pandora().getFromSharedPreferences(Const.uid).then((value) async {
      await Provider.of<GetSingleUserProvider>(context, listen: false).getSingleUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ApplicationHelpers appHelper = ApplicationHelpers();

    return Padding(
      padding: EdgeInsets.only(
        left: SpacingConstants.size20,
        right: SpacingConstants.size20,
        top: Responsive.isDesktop(context) ? SpacingConstants.size10 : SpacingConstants.size15,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            socialText,
            style: Styles.socialTextStyle(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  appHelper.trackButtonAndDeviceEvent(
                    'POST_AND_STORY_MODAL_CLICKED',
                  );
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const PostAndStoryModal();
                    },
                  );
                },
                child: const Icon(
                  EvaIcons.plusCircleOutline,
                  size: SpacingConstants.size24,
                  color: AppColors.SmatCrowPrimary500,
                ),
              ),
              customSizedBoxWidth(SpacingConstants.size16),
              GestureDetector(
                onTap: () {
                  appHelper.trackButtonAndDeviceEvent(
                    'SEARCH_BAR_CLICKED',
                  );

                  appHelper.reRouteUser(
                    context,
                    ConfigRoute.searchPage,
                    emptyString,
                  );
                },
                child: const Icon(
                  EvaIcons.search,
                  size: SpacingConstants.size24,
                  color: AppColors.SmatCrowNeuBlue900,
                ),
              ),
              customSizedBoxWidth(SpacingConstants.size20),
              GestureDetector(
                onTap: () {
                  appHelper.trackButtonAndDeviceEvent(
                    'COMMUNITY_ICON_CLICKED',
                  );

                  appHelper.reRouteUser(
                    context,
                    emptyString,
                    emptyString,
                  );
                },
                child: const Icon(
                  EvaIcons.messageSquareOutline,
                  size: SpacingConstants.size24,
                  color: AppColors.SmatCrowNeuBlue900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
