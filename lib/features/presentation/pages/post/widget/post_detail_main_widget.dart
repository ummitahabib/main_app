import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/features/domain/entities/app_entity.dart';
import 'package:smat_crow/features/domain/entities/posts/post_entity.dart';
import 'package:smat_crow/features/presentation/pages/post/comment/comment_page.dart';
import 'package:smat_crow/features/presentation/pages/post/update_post_page.dart';
import 'package:smat_crow/features/presentation/pages/post/widget/like_animation_widget.dart';
import 'package:smat_crow/features/presentation/provider/post/get_single_post/get_single_post.dart';
import 'package:smat_crow/features/presentation/provider/post/post_state.dart';
import 'package:smat_crow/features/presentation/widgets/custom_reusable_modal.dart';
import 'package:smat_crow/utils2/AppHelper.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/profile_widget.dart';
import 'package:smat_crow/utils2/service_locator.dart' as di;
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

import '../../../../domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';

class PostDetailMainWidget extends StatefulWidget {
  final String postId;
  const PostDetailMainWidget({Key? key, required this.postId})
      : super(key: key);

  @override
  State<PostDetailMainWidget> createState() => _PostDetailMainWidgetState();
}

class _PostDetailMainWidgetState extends State<PostDetailMainWidget> {
  ApplicationHelpers appHelper = ApplicationHelpers();
  String _currentUid = emptyString;

  String get currentUid => _currentUid;

  set currentUid(String value) {
    setState(() {
      _currentUid = value;
    });
  }

  @override
  void initState() {
    Provider.of<GetSinglePostProvider>(context, listen: false)
        .getSinglePost(postId: widget.postId);

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        title: const Text("Post Detail"),
      ),
      backgroundColor: Colors.white,
      body: Consumer<GetSinglePostProvider>(
        builder: (context, getSinglePostState, _) {
          if (getSinglePostState.status == GetSinglePostProviderStatus.loaded) {
            final singlePost = getSinglePostState.post;

            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SpacingConstants.size10,
                vertical: SpacingConstants.size10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (singlePost!.creatorUid == _currentUid)
                        GestureDetector(
                          onTap: () {
                            _openUserOptionDialog(context, singlePost);
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
                            _openOthersOptionDialog(context, singlePost);
                          },
                          child: const Icon(
                            EvaIcons.moreHorizontal,
                            color: AppColors.SmatCrowNeuBlue900,
                            size: SpacingConstants.size24,
                          ),
                        )
                    ],
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
                          height: MediaQuery.of(context).size.height *
                              SpacingConstants.zeroPoint30,
                          child: profileWidget(
                            imageUrl: "${singlePost.postImageUrl}",
                          ),
                        ),
                        AnimatedOpacity(
                          duration: const Duration(
                            milliseconds: SpacingConstants.int200,
                          ),
                          opacity: _isLikeAnimating
                              ? SpacingConstants.double1
                              : SpacingConstants.double0,
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
                  customSizedBoxHeight(SpacingConstants.size10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: _likePost,
                            child: Icon(
                              singlePost.likes!.contains(_currentUid)
                                  ? Icons.favorite
                                  : Icons.favorite_outline,
                              color: singlePost.likes!.contains(_currentUid)
                                  ? AppColors.redColor
                                  : AppColors.black,
                            ),
                          ),
                          customSizedBoxWidth(SpacingConstants.size10),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CommentPage(
                                    appEntity: AppEntity(
                                      uid: _currentUid,
                                      postId: singlePost.postId,
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: const Icon(
                              EvaIcons.messageCircleOutline,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                      const Icon(
                        EvaIcons.bookOpenOutline,
                        color: Colors.black,
                      )
                    ],
                  ),
                  customSizedBoxHeight(SpacingConstants.size10),
                  Text(
                    "${singlePost.totalLikes} ${SinglePostString.likes}",
                    style: Styles.likeTextStyle(),
                  ),
                  customSizedBoxHeight(SpacingConstants.size10),
                  Row(
                    children: [
                      Text(
                        "${singlePost.email}",
                        style: Styles.emailTextStyle2(),
                      ),
                      customSizedBoxWidth(SpacingConstants.size10),
                      Text(
                        "${singlePost.description}",
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  customSizedBoxHeight(SpacingConstants.size10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommentPage(
                            appEntity: AppEntity(
                              uid: _currentUid,
                              postId: singlePost.postId,
                            ),
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "$viewAllText ${singlePost.totalComments} $commentText",
                      style:
                          const TextStyle(color: AppColors.SmatCrowNeuBlue700),
                    ),
                  ),
                  customSizedBoxHeight(SpacingConstants.size10),
                  Text(
                    DateFormat(dateTime).format(singlePost.createAt!.toDate()),
                    style: const TextStyle(color: AppColors.SmatCrowNeuBlue700),
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
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
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    updatePostModel(post: post);
                  },
                  title: const Center(
                    child: Text(
                      "Update Post",
                      style: TextStyle(
                        color: Color(
                          0xFF111A27,
                        ),
                        fontFamily: "Basier Circle",
                        fontSize: 16.0,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        height: 1.6,
                        letterSpacing: -0.16,
                      ),
                    ),
                  ),
                ),
                const Divider(
                  thickness: 1,
                  color: AppColors.SmatCrowNeuBlue100,
                ),
                ListTile(
                  onTap: () {
                    _deleteUserOptionDialog(context, post);
                  },
                  title: const Center(
                    child: Text(
                      "Delete Post",
                      style: TextStyle(
                        color: Color(
                          0xFF111A27,
                        ),
                        fontFamily: "Basier Circle",
                        fontSize: 16.0,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        height: 1.6,
                        letterSpacing: -0.16,
                      ),
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
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Are you sure you want to delete this post?",
                  style: TextStyle(
                    color: Color(0xFF111A27),
                    fontFamily: "Basier Circle",
                    fontSize: 16.0,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    height: 1.6,
                    letterSpacing: -0.16,
                  ),
                ),
                const Divider(
                  thickness: 1,
                  color: AppColors.SmatCrowNeuBlue100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: const Text(
                        "Yes",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: const Text(
                        "No",
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      ),
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

  _deletePost() {
    Provider.of<PostProvider>(context, listen: false)
        .deletePost(post: PostEntity(postId: widget.postId));
  }

  _likePost() {
    Provider.of<PostProvider>(context, listen: false)
        .likePost(post: PostEntity(postId: widget.postId));
  }
}
