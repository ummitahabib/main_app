import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/features/organisation/views/widgets/custom_action_widget.dart';
import 'package:smat_crow/features/presentation/pages/post/upload_post_page.dart';
import 'package:smat_crow/features/presentation/provider/get_single_user.dart';
import 'package:smat_crow/utils2/AppHelper.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

import '../../../provider/stories_provider.dart';

class PostAndStoryModal extends StatefulWidget {
  const PostAndStoryModal({
    Key? key,
  }) : super(key: key);

  @override
  State<PostAndStoryModal> createState() => _PostAndStoryModalState();
}

class _PostAndStoryModalState extends State<PostAndStoryModal> with SingleTickerProviderStateMixin {
  final TextEditingController _descriptionController = TextEditingController();
  late GetSingleUserProvider _userProvider;

  @override
  void initState() {
    super.initState();
    Provider.of<StoryProviders>(context, listen: false).init();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of<GetSingleUserProvider>(context, listen: false);

    final storyController = Provider.of<StoryProviders>(context, listen: false);

    Future<void> handleCreateStory() async {
      final imageSelected = await storyController.getImage();

      if (imageSelected != null) {
        final userName = _userProvider.user!.firstName ?? emptyString;
        final userUrl = _userProvider.user!.profileUrl ?? emptyString;

        storyController.createStory(userName: userName, userUrl: userUrl);
      }
    }

    return GestureDetector(
      onTap: () {
        ApplicationHelpers().routeBack(context);
        Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.only(left: 200, right: 10, bottom: 450, top: 10),
          child: Center(
            child: GestureDetector(
              onTap: () {
                ApplicationHelpers().routeBack(context);
                Navigator.pop(context);
              },
              child: Container(
                width: SpacingConstants.size200,
                height: SpacingConstants.size100,
                padding: const EdgeInsets.symmetric(
                  horizontal: SpacingConstants.size24,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(SpacingConstants.size8),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(
                        SpacingConstants.int0,
                        SpacingConstants.int0,
                        SpacingConstants.int0,
                        0.07,
                      ),
                      blurRadius: SpacingConstants.size18,
                      offset: Offset(
                        SpacingConstants.size0,
                        SpacingConstants.size12,
                      ),
                    ),
                  ],
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          ApplicationHelpers().trackButtonAndDeviceEvent(
                            'ADD_FEED_ITEM_CLICKED',
                          );
                          uploadPostModel();
                          ApplicationHelpers().routeBack(context);
                        },
                        child: Row(
                          children: [
                            const Icon(
                              EvaIcons.paperPlaneOutline,
                              size: SpacingConstants.size24,
                              color: AppColors.SmatCrowNeuBlue900,
                            ),
                            Text(
                              postText,
                              style: postandStoryTextStyle(),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: handleCreateStory,
                        child: Row(
                          children: [
                            const Icon(
                              EvaIcons.playCircleOutline,
                              size: SpacingConstants.size24,
                              color: AppColors.SmatCrowNeuBlue900,
                            ),
                            Text(
                              storyText,
                              style: postandStoryTextStyle(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> uploadPostModel() {
    const containerWidth = 510.0;
    const containerHeight = 497.0;
    return customDialog(
      context,
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.transparent,
        ),
        width: containerWidth,
        height: containerHeight,
        child: const UploadPostPage(),
      ),
    );
  }
}
