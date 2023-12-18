import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/features/domain/entities/app_entity.dart';
import 'package:smat_crow/features/domain/entities/posts/post_entity.dart';
import 'package:smat_crow/features/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:smat_crow/features/presentation/pages/post/comment/comment_page.dart';
import 'package:smat_crow/utils2/AppHelper.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/service_locator.dart' as di;

class CommentModelWidget extends StatefulWidget {
  final PostEntity post;
  const CommentModelWidget({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  State<CommentModelWidget> createState() => _CommentModelWidgetState();
}

class _CommentModelWidgetState extends State<CommentModelWidget> {
  String _currentUid = emptyString;

  @override
  void initState() {
    di.locator<GetCurrentUidUseCase>().call().then((value) {
      setState(() {
        _currentUid = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ApplicationHelpers().trackButtonAndDeviceEvent(
          'NAVIGATE_TO_COMMENT_PAGE',
        );
        if (widget.post.creatorUid == _currentUid) {
          commentPageModal(
            appEntity: AppEntity(
              uid: _currentUid,
              postId: widget.post.postId,
            ),
          );
        } else {
          const Center(
            child: Text(errorLoadingData),
          );
        }
      },
      child: const Icon(
        EvaIcons.messageCircleOutline,
        color: AppColors.SmatCrowDefaultBlack,
      ),
    );
  }

  Future<dynamic> commentPageModal({
    final AppEntity? appEntity,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        if (appEntity != null) {
          return Container(
            color: AppColors.SmatCrowDefaultWhite,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: CommentPage(
              appEntity: appEntity,
            ),
          );
        }
        return const Center(child: Text(errorLoadingData));
      },
    );
  }
}
