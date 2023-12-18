import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/features/domain/entities/posts/post_entity.dart';
import 'package:smat_crow/features/presentation/pages/post/update_post_page.dart';
import 'package:smat_crow/features/presentation/provider/post/post_state.dart';
import 'package:smat_crow/features/presentation/widgets/custom_reusable_modal.dart';
import 'package:smat_crow/utils2/AppHelper.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class CurrentUserOptionWidget extends StatefulWidget {
  final PostEntity post;
  const CurrentUserOptionWidget({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  State<CurrentUserOptionWidget> createState() =>
      _CurrentUserOptionWidgetState();
}

class _CurrentUserOptionWidgetState extends State<CurrentUserOptionWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ApplicationHelpers().trackButtonAndDeviceEvent(
          'CURRENT_USER_MORE_OPTION_CLICK',
        );
        _currentUserOptions(context, widget.post);
      },
      child: const Icon(
        EvaIcons.moreHorizontal,
        color: AppColors.SmatCrowDefaultBlack,
      ),
    );
  }

  Future<dynamic> _currentUserOptions(BuildContext context, PostEntity post) {
    return showDialog(
      context: context,
      builder: (context) {
        return ReusableModal(
          width: SpacingConstants.size100,
          height: SpacingConstants.size100,
          items: [
            CustomModalItem(
              text: SinglePostString.deletePost,
              onTap: () {
                _deletePost(context);
              },
            ),
            CustomModalItem(
              text: SinglePostString.updatePost,
              onTap: () {
                updatePostModel(post: post);
              },
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> updatePostModel({
    final PostEntity? post,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        if (post != null) {
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: UpdatePostPage(
              post: post,
            ),
          );
        }
        return Center(child: Container(child: const Text(errorLoadingData)));
      },
    );
  }

  _deletePost(BuildContext context) {
    Provider.of<PostProvider>(context, listen: false)
        .deletePost(post: PostEntity(postId: widget.post.postId));
  }
}
