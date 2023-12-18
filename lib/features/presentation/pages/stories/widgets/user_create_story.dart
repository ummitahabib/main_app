import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/features/presentation/provider/get_single_user.dart';
import 'package:smat_crow/features/presentation/provider/stories_provider.dart';
import 'package:smat_crow/features/presentation/widgets/loading_state_widget.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/decoration.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class UserStoryWidget extends StatefulWidget {
  const UserStoryWidget({
    Key? key,
    required this.image,
    required this.onTap,
  }) : super(key: key);

  final String image;
  final VoidCallback onTap;

  @override
  State<UserStoryWidget> createState() => _UserStoryWidgetState();
}

class _UserStoryWidgetState extends State<UserStoryWidget> {
  late GetSingleUserProvider _userProvider;

  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of<GetSingleUserProvider>(context, listen: false);

    final storyController = Provider.of<StoryProviders>(context, listen: false);

    Future<void> handleCreateStory() async {
      final imageSelected = await storyController.getImage();

      if (imageSelected != null) {
        final userName = _userProvider.user!.firstName ?? "";
        final userUrl = _userProvider.user!.profileUrl ?? "";

        storyController.createStory(userName: userName, userUrl: userUrl);
      }
    }

    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: SpacingConstants.size8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: <Widget>[
                StoryCircleImage(image: widget.image),
                Positioned(
                  bottom: SpacingConstants.size0,
                  right: -1,
                  child: GestureDetector(
                    onTap: handleCreateStory,
                    child: storyAddWidget(),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: SpacingConstants.size5,
            ),
            const Text(
              'My Story',
              style: TextStyle(
                color: AppColors.SmatCrowDefaultBlack,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class StoryCircleImage extends StatelessWidget {
  const StoryCircleImage({
    super.key,
    required this.image,
  });

  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SpacingConstants.double01),
      width: SpacingConstants.size50,
      height: SpacingConstants.size50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.SmatCrowPrimary500,
          width: SpacingConstants.size1point5,
        ),
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: image,
          fit: BoxFit.cover,
          placeholder: (context, url) => const LoadingStateWidget(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }
}
