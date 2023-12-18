// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/features/domain/entities/comment/comment_entity.dart';
import 'package:smat_crow/features/domain/entities/user/user_entity.dart';
import 'package:smat_crow/features/presentation/pages/post/comment/edit_comment_page.dart';
import 'package:smat_crow/features/presentation/pages/post/comment/widgets/comment_app_bar.dart';
import 'package:smat_crow/features/presentation/pages/post/comment/widgets/single_comment_widget.dart';
import 'package:smat_crow/features/presentation/provider/comment_state.dart';
import 'package:smat_crow/features/presentation/provider/get_single_user.dart';
import 'package:smat_crow/features/presentation/provider/post/get_single_post/get_single_post.dart';
import 'package:smat_crow/features/presentation/provider/reply_provider.dart';
import 'package:smat_crow/features/presentation/widgets/custom_text_field.dart';
import 'package:smat_crow/features/presentation/widgets/loading_state_widget.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/service_locator.dart' as di;
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';
import 'package:uuid/uuid.dart';

import '../../../../../domain/entities/app_entity.dart';

class CommentMainWidget extends StatefulWidget {
  final AppEntity appEntity;

  const CommentMainWidget({Key? key, required this.appEntity}) : super(key: key);

  @override
  State<CommentMainWidget> createState() => _CommentMainWidgetState();
}

class _CommentMainWidgetState extends State<CommentMainWidget> with SingleTickerProviderStateMixin {
  late Future<UserEntity?> _userFuture;

  @override
  void initState() {
    _userFuture = _initializeData();
    super.initState();
  }

  Future<UserEntity?> _initializeData() async {
    final user = await Provider.of<GetSingleUserProvider>(context, listen: false).getSingleUser();

    if (user != null) {
      await Provider.of<GetSinglePostProvider>(context, listen: false).getSinglePost(postId: widget.appEntity.postId!);

      await Provider.of<CommentProvider>(context, listen: false).getComments(postId: widget.appEntity.postId!);
    }

    return user;
  }

  void _initReplyProvider() {
    ChangeNotifierProvider<ReplyProvider>(
      create: (_) => di.locator<ReplyProvider>(),
    );
  }

  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommentsAppBar(
        onBackPress: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<UserEntity?>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingStateWidget());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(errorLoadingData),
            );
          } else if (snapshot.hasData) {
            final singleUser = snapshot.data!;
            return buildConsumerWidget(singleUser);
          } else {
            return const Center(
              child: Text(nullUserData),
            );
          }
        },
      ),
    );
  }

  Consumer<GetSinglePostProvider> buildConsumerWidget(UserEntity singleUser) {
    return Consumer<GetSinglePostProvider>(
      builder: (context, singlePostState, _) {
        if (singlePostState.status == GetSinglePostProviderStatus.loaded) {
          return Consumer<CommentProvider>(
            builder: (context, commentState, _) {
              if (commentState.status == CommentProviderStatus.loaded) {
                return Padding(
                  padding: const EdgeInsets.only(top: SpacingConstants.size20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: commentState.comments!.length,
                                itemBuilder: (context, index) {
                                  final singleComment = commentState.comments![index];

                                  return Consumer<ReplyProvider>(
                                    builder: (context, reply, child) {
                                      return SingleCommentWidget(
                                        currentUser: singleUser,
                                        comment: singleComment,
                                        onLongPressListener: () {
                                          _openBottomModalSheet(
                                            context: context,
                                            comment: singleComment,
                                          );
                                        },
                                        onLikeClickListener: () {
                                          _likeComment(
                                            comment: singleComment,
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            _commentSection(currentUser: singleUser),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }
              return const Center(child: LoadingStateWidget());
            },
          );
        }
        return const Center(child: LoadingStateWidget());
      },
    );
  }

  Container _commentSection({required UserEntity currentUser}) {
    return Container(
      width: double.infinity,
      color: AppColors.SmatCrowDefaultWhite,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: SpacingConstants.size35,
          left: SpacingConstants.size24,
          right: SpacingConstants.size24,
        ),
        child: SingleChildScrollView(
          child: Row(
            children: [
              Expanded(
                child: CustomTextField(
                  text: emptyString,
                  type: TextFieldType.Default,
                  hintText: SinglePostString.addComment,
                  textEditingController: _descriptionController,
                ),
              ),
              customSizedBoxWidth(SpacingConstants.size10),
              GestureDetector(
                onTap: () {
                  _createComment(currentUser);
                },
                child: Container(
                  width: SpacingConstants.size50,
                  height: SpacingConstants.size50,
                  decoration: BoxDecoration(
                    color: AppColors.SmatCrowDefaultBlack,
                    borderRadius: BorderRadius.circular(SpacingConstants.size100),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(SpacingConstants.size14),
                    child: Icon(
                      EvaIcons.paperPlaneOutline,
                      color: AppColors.SmatCrowDefaultWhite,
                      size: SpacingConstants.size16,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _createComment(UserEntity currentUser) {
    Provider.of<CommentProvider>(context, listen: false)
        .createComment(
      comment: CommentEntity(
        totalReplys: SpacingConstants.int0,
        commentId: const Uuid().v1(),
        createAt: Timestamp.now(),
        likes: const [],
        email: currentUser.email,
        userProfileUrl: currentUser.profileUrl,
        description: _descriptionController.text,
        creatorUid: currentUser.uid,
        postId: widget.appEntity.postId,
      ),
    )
        .then((value) {
      setState(() {
        _descriptionController.clear();
      });
    });
  }

  Future<void> _openBottomModalSheet({
    required BuildContext context,
    required CommentEntity comment,
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Container(
            width: 347,
            height: 227,
            decoration: const BoxDecoration(color: AppColors.SmatCrowDefaultWhite),
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(
                  vertical: SpacingConstants.size10,
                ),
                child: Column(
                  children: [
                    customSizedBoxHeight(SpacingConstants.size8),
                    Padding(
                      padding: const EdgeInsets.only(left: SpacingConstants.size10),
                      child: GestureDetector(
                        onTap: () {
                          _deleteComment(
                            commentId: comment.commentId!,
                            postId: comment.postId!,
                          );
                        },
                        child: Text(
                          deleteCommentText,
                          style: Styles.modelTextStyle,
                        ),
                      ),
                    ),
                    customSizedBoxHeight(SpacingConstants.size7),
                    const Divider(
                      thickness: SpacingConstants.double1,
                      color: AppColors.SmatCrowNeuBlue200,
                    ),
                    customSizedBoxHeight(SpacingConstants.size7),
                    Padding(
                      padding: const EdgeInsets.only(left: SpacingConstants.size10),
                      child: GestureDetector(
                        onTap: () {
                          updatePostModel(comment: comment);
                        },
                        child: Text(
                          updateCommentText,
                          style: Styles.modelTextStyle,
                        ),
                      ),
                    ),
                    customSizedBoxHeight(SpacingConstants.size7),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future updatePostModel({
    final CommentEntity? comment,
  }) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        if (comment != null) {
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: EditCommentPage(
              comment: comment,
            ),
          );
        }
        return const Text(errorLoadingData);
      },
    );
  }

  _deleteComment({required String commentId, required String postId}) {
    Provider.of<CommentProvider>(context, listen: false).deleteComment(
      comment: CommentEntity(commentId: commentId, postId: postId),
    );
  }

  _likeComment({required CommentEntity comment}) {
    Provider.of<CommentProvider>(context, listen: false).likeComment(
      comment: CommentEntity(
        commentId: comment.commentId,
        postId: comment.postId,
      ),
    );
  }
}
