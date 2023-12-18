import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smat_crow/features/domain/entities/reply/reply_entity.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/profile_widget.dart';
import 'package:smat_crow/utils2/service_locator.dart' as di;
import 'package:smat_crow/utils2/spacing_constants.dart';

import '../../../../../domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';

class SingleReplyWidget extends StatefulWidget {
  final ReplyEntity reply;
  final VoidCallback? onLongPressListener;
  final VoidCallback? onLikeClickListener;
  const SingleReplyWidget({
    Key? key,
    required this.reply,
    this.onLongPressListener,
    this.onLikeClickListener,
  }) : super(key: key);

  @override
  State<SingleReplyWidget> createState() => _SingleReplyWidgetState();
}

class _SingleReplyWidgetState extends State<SingleReplyWidget> {
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
    return InkWell(
      onLongPress: widget.reply.creatorUid == _currentUid
          ? widget.onLongPressListener
          : null,
      child: Container(
        margin: const EdgeInsets.only(
          left: SpacingConstants.size10,
          top: SpacingConstants.size10,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: SpacingConstants.size40,
              height: SpacingConstants.size40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(SpacingConstants.size20),
                child: profileWidget(
                  imageUrl: widget.reply.userProfileUrl ?? emptyString,
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
                          "${widget.reply.email}",
                          style: const TextStyle(
                            fontSize: SpacingConstants.size15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.SmatCrowDefaultBlack,
                          ),
                        ),
                        GestureDetector(
                          onTap: widget.onLikeClickListener,
                          child: Icon(
                            widget.reply.likes!.contains(_currentUid)
                                ? Icons.favorite
                                : Icons.favorite_outline,
                            size: SpacingConstants.size20,
                            color: widget.reply.likes!.contains(_currentUid)
                                ? AppColors.redColor
                                : AppColors.SmatCrowNeuBlue500,
                          ),
                        )
                      ],
                    ),
                    customSizedBoxHeight(SpacingConstants.size4),
                    Text(
                      "${widget.reply.description}",
                      style: const TextStyle(
                        color: AppColors.SmatCrowDefaultBlack,
                      ),
                    ),
                    customSizedBoxHeight(SpacingConstants.size4),
                    Text(
                      DateFormat(dateTime)
                          .format(widget.reply.createAt!.toDate()),
                      style:
                          const TextStyle(color: AppColors.SmatCrowNeuBlue500),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
