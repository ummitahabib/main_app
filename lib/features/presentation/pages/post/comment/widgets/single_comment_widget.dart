import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/features/domain/entities/comment/comment_entity.dart';
import 'package:smat_crow/features/domain/entities/reply/reply_entity.dart';
import 'package:smat_crow/features/domain/entities/user/user_entity.dart';
import 'package:smat_crow/features/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:smat_crow/features/presentation/pages/post/comment/widgets/single_reply_widget.dart';
import 'package:smat_crow/features/presentation/provider/reply_provider.dart';
import 'package:smat_crow/features/presentation/widgets/custom_text_field.dart';
import 'package:smat_crow/features/presentation/widgets/loading_state_widget.dart';
import 'package:smat_crow/utils2/app_helper.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/profile_widget.dart';
import 'package:smat_crow/utils2/service_locator.dart' as di;
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:uuid/uuid.dart';

class SingleCommentWidget extends StatefulWidget {
  final CommentEntity comment;
  final VoidCallback? onLongPressListener;
  final VoidCallback? onLikeClickListener;
  final UserEntity? currentUser;

  const SingleCommentWidget({
    Key? key,
    required this.comment,
    this.onLongPressListener,
    this.onLikeClickListener,
    this.currentUser,
  }) : super(key: key);

  @override
  State<SingleCommentWidget> createState() => _SingleCommentWidgetState();
}

class _SingleCommentWidgetState extends State<SingleCommentWidget> {
  final TextEditingController _replyDescriptionController = TextEditingController();
  String _currentUid = "";

  @override
  void initState() {
    di.locator<GetCurrentUidUseCase>().call().then((value) {
      setState(() {
        _currentUid = value;
      });
    });

    Provider.of<ReplyProvider>(context, listen: false).getReplys(
      reply: ReplyEntity(
        postId: widget.comment.postId,
        commentId: widget.comment.commentId,
      ),
    );

    super.initState();
  }

  bool _isUserReplying = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: widget.comment.creatorUid == _currentUid ? widget.onLongPressListener : null,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: SpacingConstants.size10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: SpacingConstants.size40,
              height: SpacingConstants.size40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(SpacingConstants.size20),
                child: profileWidget(
                  imageUrl: widget.comment.userProfileUrl ?? emptyString,
                ),
              ),
            ),
            customSizedBoxWidth(SpacingConstants.size10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(SpacingConstants.size8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${widget.comment.email}",
                          style: const TextStyle(
                            fontSize: SpacingConstants.size15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.SmatCrowDefaultBlack,
                          ),
                        ),
                        GestureDetector(
                          onTap: widget.onLikeClickListener,
                          child: Icon(
                            widget.comment.likes!.contains(_currentUid) ? Icons.favorite : Icons.favorite_outline,
                            size: 20,
                            color:
                                widget.comment.likes!.contains(_currentUid) ? Colors.red : AppColors.SmatCrowNeuBlue500,
                          ),
                        )
                      ],
                    ),
                    customSizedBoxHeight(SpacingConstants.size4),
                    Text(
                      "${widget.comment.description}",
                      style: const TextStyle(
                        color: AppColors.SmatCrowDefaultBlack,
                      ),
                    ),
                    customSizedBoxHeight(SpacingConstants.size4),
                    Row(
                      children: [
                        Text(
                          DateFormat(dateTime).format(widget.comment.createAt!.toDate()),
                          style: const TextStyle(
                            color: AppColors.SmatCrowNeuBlue500,
                          ),
                        ),
                        customSizedBoxWidth(SpacingConstants.size15),
                        GestureDetector(
                          onTap: () {
                            ApplicationHelpers().trackButtonAndDeviceEvent(
                              'USER_REPLY_EVENT_CLICK',
                            );
                            setState(() {
                              _isUserReplying = !_isUserReplying;
                            });
                          },
                          child: const Text(
                            replyText,
                            style: TextStyle(
                              color: AppColors.SmatCrowNeuBlue500,
                              fontSize: SpacingConstants.font12,
                            ),
                          ),
                        ),
                        customSizedBoxWidth(SpacingConstants.size15),
                        GestureDetector(
                          onTap: () {
                            ApplicationHelpers().trackButtonAndDeviceEvent(
                              'REPLY_COMMENT_EVEVNT_CLICKED',
                            );
                            widget.comment.totalReplys == SpacingConstants.int0
                                ? const Text(noRepliesText)
                                : Provider.of<ReplyProvider>(
                                    context,
                                    listen: false,
                                  ).getReplys(
                                    reply: ReplyEntity(
                                      postId: widget.comment.postId,
                                      commentId: widget.comment.commentId,
                                    ),
                                  );
                          },
                          child: const Text(
                            viewReplyText,
                            style: TextStyle(
                              color: AppColors.SmatCrowNeuBlue500,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Consumer<ReplyProvider>(
                      builder: (context, replyProvider, _) {
                        if (replyProvider.status == ReplyProviderStatus.loaded) {
                          final replys = replyProvider.replys!
                              .where(
                                (element) => element.commentId == widget.comment.commentId,
                              )
                              .toList();
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemCount: replys.length,
                            itemBuilder: (context, index) {
                              return SingleReplyWidget(
                                reply: replys[index],
                                onLongPressListener: () {
                                  _openBottomModalSheet(
                                    context: context,
                                    reply: replys[index],
                                  );
                                },
                                onLikeClickListener: () {
                                  _likeReply(reply: replys[index]);
                                },
                              );
                            },
                          );
                        }
                        return const Center(
                          child: LoadingStateWidget(),
                        );
                      },
                    ),
                    if (_isUserReplying == true)
                      customSizedBoxHeight(SpacingConstants.size10)
                    else
                      customSizedBoxHeight(0),
                    if (_isUserReplying == true)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomTextField(
                            text: emptyString,
                            type: TextFieldType.Default,
                            hintText: "Post your reply...",
                            textEditingController: _replyDescriptionController,
                          ),
                          customSizedBoxHeight(SpacingConstants.size10),
                          GestureDetector(
                            onTap: () {
                              ApplicationHelpers().trackButtonAndDeviceEvent(
                                'CREATE_REPLY_BUTTON_CLICKED',
                              );
                              _createReply();
                            },
                            child: const Text(
                              "Post",
                              style: TextStyle(color: AppColors.SmatCrowBlue500),
                            ),
                          )
                        ],
                      )
                    else
                      const SizedBox(
                        width: 0,
                        height: 0,
                      )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _createReply() {
    Provider.of<ReplyProvider>(context, listen: false)
        .createReply(
      reply: ReplyEntity(
        replyId: const Uuid().v1(),
        createAt: Timestamp.now(),
        likes: const [],
        email: widget.currentUser!.email,
        userProfileUrl: widget.currentUser!.profileUrl,
        creatorUid: widget.currentUser!.uid,
        postId: widget.comment.postId,
        commentId: widget.comment.commentId,
        description: _replyDescriptionController.text,
      ),
    )
        .then((value) {
      setState(() {
        _replyDescriptionController.clear();
        _isUserReplying = false;
      });
    });
  }

  Future _openBottomModalSheet({
    required BuildContext context,
    required ReplyEntity reply,
  }) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 150,
          decoration: BoxDecoration(
            color: AppColors.SmatCrowDefaultWhite.withOpacity(.8),
          ),
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      "More Options",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.SmatCrowDefaultBlack,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Divider(
                    thickness: 1,
                    color: AppColors.SmatCrowAccentBlue,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: GestureDetector(
                      onTap: () {
                        ApplicationHelpers().trackButtonAndDeviceEvent(
                          'DELETE_REPLY_BUTTON_CLICK',
                        );
                        _deleteReply(reply: reply);
                      },
                      child: const Text(
                        "Delete Reply",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: AppColors.SmatCrowDefaultBlack,
                        ),
                      ),
                    ),
                  ),
                  customSizedBoxHeight(SpacingConstants.size7),
                  const Divider(
                    thickness: 1,
                    color: AppColors.SmatCrowAccentBlue,
                  ),
                  customSizedBoxHeight(SpacingConstants.size7),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: GestureDetector(
                      onTap: () {
                        ApplicationHelpers().trackButtonAndDeviceEvent('UPDATE_REPLY_BUTTON');

                        ApplicationHelpers().reRouteUser(
                          context,
                          ConfigRoute.updateReplyPage,
                          reply,
                        );
                      },
                      child: const Text(
                        "Update Reply",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: AppColors.SmatCrowDefaultBlack,
                        ),
                      ),
                    ),
                  ),
                  customSizedBoxHeight(SpacingConstants.size7),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _deleteReply({required ReplyEntity reply}) {
    Provider.of<ReplyProvider>(context, listen: false).deleteReply(
      reply: ReplyEntity(
        postId: reply.postId,
        commentId: reply.commentId,
        replyId: reply.replyId,
      ),
    );
  }

  _likeReply({required ReplyEntity reply}) {
    Provider.of<ReplyProvider>(context, listen: false).likeReply(
      reply: ReplyEntity(
        postId: reply.postId,
        commentId: reply.commentId,
        replyId: reply.replyId,
      ),
    );
  }
}
