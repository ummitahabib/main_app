import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smat_crow/features/domain/entities/posts/post_entity.dart';
import 'package:smat_crow/features/presentation/widgets/custom_reusable_modal.dart';
import 'package:smat_crow/utils2/AppHelper.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/profile_widget.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class OtherUsersMoreWidget extends StatefulWidget {
  final PostEntity post;
  const OtherUsersMoreWidget({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  State<OtherUsersMoreWidget> createState() => _OtherUsersMoreWidgetState();
}

class _OtherUsersMoreWidgetState extends State<OtherUsersMoreWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: SpacingConstants.size10,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: SpacingConstants.size502,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: AppColors.SmatCrowNeuBlue100,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: SpacingConstants.size20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: SpacingConstants.size10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        ApplicationHelpers().trackButtonAndDeviceEvent(
                          'NAVIGATE_TO_SINGLE_USER_PROFILE_SCREEN',
                        );

                        ApplicationHelpers().reRouteUser(
                          context,
                          ConfigRoute.singleUserProfilePage,
                          widget.post.creatorUid,
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${widget.post.email}",
                                style: const TextStyle(
                                  color: AppColors.SmatCrowDefaultBlack,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                DateFormat(SinglePostString.dateTime)
                                    .format(widget.post.createAt!.toDate()),
                                style: const TextStyle(
                                  color: AppColors.SmatCrowNeuBlue500,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        ApplicationHelpers().trackButtonAndDeviceEvent(
                          'OTHER_USER_MORE_OPTION_CLICK',
                        );
                        _otherUserMoreOption(context, widget.post);
                      },
                      child: const Icon(
                        EvaIcons.moreHorizontal,
                        color: AppColors.SmatCrowDefaultBlack,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> _otherUserMoreOption(BuildContext context, PostEntity post) {
    return showDialog(
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
}
