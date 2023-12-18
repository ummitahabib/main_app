import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/features/domain/entities/app_entity.dart';
import 'package:smat_crow/features/domain/entities/posts/post_entity.dart';
import 'package:smat_crow/features/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:smat_crow/features/presentation/pages/post/comment/comment_page.dart';
import 'package:smat_crow/features/presentation/pages/post/update_post_page.dart';
import 'package:smat_crow/features/presentation/pages/post/widget/like_animation_widget.dart';
import 'package:smat_crow/features/presentation/pages/profile/single_user_profile_page.dart';
import 'package:smat_crow/features/presentation/pages/socials/widgets/single_post_model.dart/comment_page_modal.dart';
import 'package:smat_crow/features/presentation/provider/post/post_state.dart';
import 'package:smat_crow/features/presentation/widgets/custom_reusable_modal.dart';
import 'package:smat_crow/utils2/app_helper.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/profile_widget.dart';
import 'package:smat_crow/utils2/service_locator.dart' as di;
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class SinglePostCardWidget extends StatefulWidget {
  final PostEntity post;
  const SinglePostCardWidget({Key? key, required this.post}) : super(key: key);

  @override
  State<SinglePostCardWidget> createState() => _SinglePostCardWidgetState();
}

class _SinglePostCardWidgetState extends State<SinglePostCardWidget> {
  String _currentUid = emptyString;
  ApplicationHelpers appHelpers = ApplicationHelpers();

  @override
  void initState() {
    di.locator<GetCurrentUidUseCase>().call().then((value) {
      setState(() {
        _currentUid = value;
      });
    });
    super.initState();
  }

  bool _isLikeAnimating = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: SpacingConstants.size10,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 1.7,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: AppColors.SmatCrowNeuBlue100,
            ),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: SpacingConstants.size24,
                  vertical: SpacingConstants.size10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        appHelpers.trackButtonAndDeviceEvent(
                          'NAVIGATE_TO_SINGLE_USER_PROFILE',
                        );
                        appHelpers.navigationHelper(
                          context,
                          SingleUserProfilePage(
                            otherUserId: widget.post.creatorUid!,
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: SpacingConstants.size30,
                            height: SpacingConstants.size30,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                SpacingConstants.size15,
                              ),
                              child: profileWidget(
                                imageUrl: "${widget.post.userProfileUrl}",
                              ),
                            ),
                          ),
                          customSizedBoxWidth(SpacingConstants.size10),
                          customSizedBoxWidth(SpacingConstants.size10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "${widget.post.email}",
                                style: Styles.emailTextStyle(),
                              ),
                              Text(
                                DateFormat(SinglePostString.dateTime).format(widget.post.createAt!.toDate()),
                                style: Styles.dateTextStyle(),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    if (widget.post.creatorUid == _currentUid)
                      GestureDetector(
                        onTap: () {
                          appHelpers.trackButtonAndDeviceEvent(
                            'USER_OPTION_MODAL_CLICKED',
                          );

                          _openUserOptionDialog(context, widget.post);
                        },
                        child: const Icon(
                          EvaIcons.moreHorizontal,
                          color: AppColors.SmatCrowNeuBlue900,
                          size: SpacingConstants.size24,
                        ),
                      )
                    else
                      GestureDetector(
                        onTap: () {
                          appHelpers.trackButtonAndDeviceEvent(
                            'OTHER_USER_OPTION_CLICKED',
                          );

                          _openOthersOptionDialog(context, widget.post);
                        },
                        child: const Icon(
                          EvaIcons.moreHorizontal,
                          color: AppColors.SmatCrowNeuBlue900,
                          size: SpacingConstants.size24,
                        ),
                      )
                  ],
                ),
              ),
              customSizedBoxHeight(SpacingConstants.size10),
              GestureDetector(
                onDoubleTap: () {
                  _likePost();
                  setState(() {
                    _isLikeAnimating = true;
                  });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * SpacingConstants.int273 / SpacingConstants.int812,
                      child: profileWidget(
                        imageUrl: "${widget.post.postImageUrl}",
                      ),
                    ),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: SpacingConstants.int200),
                      opacity: _isLikeAnimating ? SpacingConstants.size1 : SpacingConstants.size0,
                      child: LikeAnimationWidget(
                        duration: const Duration(
                          milliseconds: SpacingConstants.int200,
                        ),
                        isLikeAnimating: _isLikeAnimating,
                        onLikeFinish: () {
                          setState(() {
                            _isLikeAnimating = false;
                          });
                        },
                        child: const Icon(
                          EvaIcons.heartOutline,
                          size: SpacingConstants.size100,
                          color: AppColors.redColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: SpacingConstants.size24,
                ),
                child: Column(
                  children: [
                    customSizedBoxHeight(SpacingConstants.size10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: _likePost,
                              child: Icon(
                                widget.post.likes!.contains(_currentUid) ? EvaIcons.heart : EvaIcons.heartOutline,
                                color: widget.post.likes!.contains(_currentUid)
                                    ? AppColors.SmatCrowRed600
                                    : AppColors.SmatCrowDefaultBlack,
                              ),
                            ),
                            customSizedBoxWidth(SpacingConstants.size10),
                            CommentModelWidget(
                              post: widget.post,
                            ),
                          ],
                        ),
                        const Icon(
                          EvaIcons.bookmarkOutline,
                          size: SpacingConstants.size24,
                          color: AppColors.SmatCrowDefaultBlack,
                        )
                      ],
                    ),
                    customSizedBoxHeight(SpacingConstants.size10),
                    Row(
                      children: [
                        Text(
                          "${widget.post.totalLikes} ${SinglePostString.likes}",
                          style: Styles.likeTextStyle(),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: SpacingConstants.size10,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "${widget.post.email}",
                                  style: Styles.emailTextStyle2(),
                                ),
                                const TextSpan(
                                  text: emptySpace,
                                ),
                                TextSpan(
                                  text: "${widget.post.description} ",
                                  style: Styles.smatCrowSmallTextRegular(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    customSizedBoxHeight(SpacingConstants.size10),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            appHelpers.trackButtonAndDeviceEvent(
                              'NAVIGATE_TO_COMMENT_PAGE',
                            );
                            appHelpers.navigationHelper(
                              context,
                              CommentPage(
                                appEntity: AppEntity(
                                  uid: _currentUid,
                                  postId: widget.post.postId,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            '$viewAllText ${widget.post.totalComments} $commentText',
                            style: Styles.viewAllTextStyle(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openUserOptionDialog(
    BuildContext context,
    PostEntity post,
  ) async {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SpacingConstants.size16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    appHelpers.trackButtonAndDeviceEvent(
                      'UPDATE_USER_POST_CLICKED',
                    );

                    updatePostModel(post: post);
                  },
                  title: const Center(
                    child: Text(
                      updateText,
                    ),
                  ),
                ),
                const Divider(
                  thickness: SpacingConstants.size1,
                  color: AppColors.SmatCrowNeuBlue100,
                ),
                ListTile(
                  onTap: () {
                    appHelpers.trackButtonAndDeviceEvent('CLICKED_ON_DELETE_POST');
                    _deleteUserOptionDialog(context, post);
                  },
                  title: const Center(
                    child: Text(
                      deletePostText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _deleteUserOptionDialog(
    BuildContext context,
    PostEntity post,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  areYouSureDeleteText,
                  style: Styles.deletePostAlertTextStyle(),
                ),
                const Divider(
                  thickness: SpacingConstants.size1,
                  color: AppColors.SmatCrowNeuBlue100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text(yes, style: Styles.modelTextStyleRed),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text(no, style: Styles.modelTextStyle),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
    if (confirmed == true) {
      _deletePost();
    }
  }

  Future<void> _openOthersOptionDialog(
    BuildContext context,
    PostEntity post,
  ) async {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return ReusableModal(
          width: SpacingConstants.size150,
          height: SpacingConstants.size100,
          backgroundColor: Colors.grey[200]!,
          items: [
            CustomModalItem(
              text: SinglePostString.reportPost,
            ),
            CustomModalItem(
              text: SinglePostString.reportUser,
              onTap: () {},
            ),
            CustomModalItem(
              text: SinglePostString.blockUser,
              onTap: () {},
            ),
          ],
        );
      },
    );
  }

  void _deletePost() {
    appHelpers.trackButtonAndDeviceEvent('DELETE_POST_CLICKED');
    Provider.of<PostProvider>(context, listen: false).deletePost(post: PostEntity(postId: widget.post.postId));
  }

  void _likePost() {
    appHelpers.trackButtonAndDeviceEvent('LIKE_POST_CLICKED');
    Provider.of<PostProvider>(context, listen: false).likePost(post: PostEntity(postId: widget.post.postId));
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
        return const Center(child: Text(errorLoadingData));
      },
    );
  }
}
