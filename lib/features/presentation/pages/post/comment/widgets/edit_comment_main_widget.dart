import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/features/domain/entities/comment/comment_entity.dart';
import 'package:smat_crow/features/presentation/provider/comment_state.dart';
import 'package:smat_crow/features/presentation/widgets/custom_button.dart';
import 'package:smat_crow/features/presentation/widgets/custom_text_field.dart';
import 'package:smat_crow/features/presentation/widgets/loading_state_widget.dart';
import 'package:smat_crow/utils2/AppHelper.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

import '../../../../../../utils2/constants.dart';

class EditCommentMainWidget extends StatefulWidget {
  final CommentEntity comment;
  const EditCommentMainWidget({Key? key, required this.comment})
      : super(key: key);

  @override
  State<EditCommentMainWidget> createState() => _EditCommentMainWidgetState();
}

class _EditCommentMainWidgetState extends State<EditCommentMainWidget> {
  TextEditingController? _descriptionController;

  bool _isCommentUpdating = false;

  @override
  void initState() {
    _descriptionController =
        TextEditingController(text: widget.comment.description);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.SmatCrowDefaultWhite,
      appBar: AppBar(
        backgroundColor: AppColors.SmatCrowDefaultWhite,
        title: const Text(editCommentText),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: SpacingConstants.size10,
          vertical: SpacingConstants.size10,
        ),
        child: Column(
          children: [
            CustomTextField(
              hintText: writeYourCaptionText,
              type: TextFieldType.Default,
              textEditingController: _descriptionController,
            ),
            customSizedBoxHeight(SpacingConstants.size10),
            CustomButton(
              color: AppColors.SmatCrowPrimary500,
              text: saveChanges,
              onPressed: () {
                ApplicationHelpers()
                    .trackButtonAndDeviceEvent('EDIT_SAVE_CHANGES_CLICK');

                _editComment();
              },
            ),
            customSizedBoxHeight(SpacingConstants.size10),
            if (_isCommentUpdating == true)
              const Center(child: LoadingStateWidget())
            else
              const SizedBox(
                width: SpacingConstants.size0,
                height: SpacingConstants.size0,
              )
          ],
        ),
      ),
    );
  }

  _editComment() {
    setState(() {
      _isCommentUpdating = true;
    });
    Provider.of<CommentProvider>(context, listen: false)
        .updateComment(
      comment: CommentEntity(
        postId: widget.comment.postId,
        commentId: widget.comment.commentId,
        description: _descriptionController!.text,
      ),
    )
        .then((value) {
      setState(() {
        _isCommentUpdating = false;
        _descriptionController!.clear();
      });
      Navigator.pop(context);
    });
  }
}
