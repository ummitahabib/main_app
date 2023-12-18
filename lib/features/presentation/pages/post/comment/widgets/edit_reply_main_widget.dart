import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/features/domain/entities/reply/reply_entity.dart';
import 'package:smat_crow/features/presentation/provider/reply_provider.dart';
import 'package:smat_crow/features/presentation/widgets/button_container_widget.dart';
import 'package:smat_crow/features/presentation/widgets/custom_text_field.dart';
import 'package:smat_crow/features/presentation/widgets/loading_state_widget.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class EditReplyMainWidget extends StatefulWidget {
  final ReplyEntity reply;
  const EditReplyMainWidget({Key? key, required this.reply}) : super(key: key);

  @override
  State<EditReplyMainWidget> createState() => _EditReplyMainWidgetState();
}

class _EditReplyMainWidgetState extends State<EditReplyMainWidget> {
  TextEditingController? _descriptionController;

  bool _isReplyUpdating = false;

  @override
  void initState() {
    _descriptionController =
        TextEditingController(text: widget.reply.description);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.SmatCrowDefaultWhite,
      appBar: AppBar(
        backgroundColor: AppColors.SmatCrowDefaultWhite,
        title: const Text(editReplyText),
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
            ButtonContainerWidget(
              color: AppColors.SmatCrowPrimary500,
              text: saveChanges,
              onTapListener: () {
                _editReply();
              },
            ),
            customSizedBoxHeight(SpacingConstants.size10),
            if (_isReplyUpdating == true)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    updateText,
                    style: TextStyle(color: AppColors.SmatCrowDefaultBlack),
                  ),
                  customSizedBoxWidth(SpacingConstants.size10),
                  const LoadingStateWidget(),
                ],
              )
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

  _editReply() {
    setState(() {
      _isReplyUpdating = true;
    });
    Provider.of<ReplyProvider>(context, listen: false)
        .updateReply(
      reply: ReplyEntity(
        postId: widget.reply.postId,
        commentId: widget.reply.commentId,
        replyId: widget.reply.replyId,
        description: _descriptionController!.text,
      ),
    )
        .then((value) {
      setState(() {
        _isReplyUpdating = false;
        _descriptionController!.clear();
      });
      Navigator.pop(context);
    });
  }
}
