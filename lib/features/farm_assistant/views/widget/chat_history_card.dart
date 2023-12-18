import 'package:flutter/material.dart';
import 'package:smat_crow/features/farm_assistant/data/model/user_session_model.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class ChatHistoryCard extends StatelessWidget {
  const ChatHistoryCard({
    required this.userSessionData,
    required this.onDelete,
    required this.onTap,
    this.isSelected = false,
    super.key,
  });
  final USerSessionModel? userSessionData;
  final Function(USerSessionModel? sessionId) onTap;
  final Function(USerSessionModel? sessionId) onDelete;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        SpacingConstants.size20,
        0,
        SpacingConstants.size20,
        SpacingConstants.size20,
      ),
      height: 50,
      child: Material(
        child: InkWell(
          onTap: () {
            onTap(userSessionData);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: SpacingConstants.size10,
              vertical: SpacingConstants.size5,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: isSelected ? AppColors.SmatCrowPrimary400 : AppColors.SmatCrowNeuBlue100,
            ),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: SpacingConstants.size2),
                  child: Icon(
                    Icons.message_outlined,
                    size: SpacingConstants.size14,
                  ),
                ),
                const SizedBox(width: SpacingConstants.size5),
                SizedBox(
                  width: SpacingConstants.size150,
                  child: Text(
                    userSessionData?.name ?? "",
                    style: Styles.smatCrowMediumLabel(
                      color: AppColors.SmatCrowPrimary900,
                    ).copyWith(
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    onDelete(userSessionData);
                  },
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
