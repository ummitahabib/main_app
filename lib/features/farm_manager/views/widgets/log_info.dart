import 'package:flutter/material.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/app_container.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class LogInfoItem extends StatelessWidget {
  const LogInfoItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.function,
    required this.logList,
    this.width,
  });
  final String title;
  final String subtitle;
  final String body;
  final VoidCallback function;
  final List<Widget> logList;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return AppContainer(
      width: width,
      padding: const EdgeInsets.all(SpacingConstants.size15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppContainer(
            color: AppColors.SmatCrowNeuOrange900,
            padding: const EdgeInsets.all(SpacingConstants.font14),
            child: Row(
              children: [
                Text(
                  title,
                  style: Styles.smatCrowMediumSubParagraph(color: Colors.white).copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                InkWell(
                  onTap: function,
                  child: AppContainer(
                    padding: const EdgeInsets.all(SpacingConstants.font10),
                    child: Text(
                      subtitle,
                      style: Styles.smatCrowSubParagraphRegular(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
          const Ymargin(SpacingConstants.size15),
          if (logList.isEmpty)
            AppContainer(
              color: AppColors.SmatCrowNeuBlue100,
              padding: const EdgeInsets.all(SpacingConstants.size15),
              child: Row(
                children: [
                  Text(
                    body,
                    style: Styles.smatCrowSubParagraphRegular(color: AppColors.SmatCrowNeuBlue500),
                  ),
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              itemCount: logList.length,
              separatorBuilder: (context, index) => const Ymargin(SpacingConstants.font10),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Align(alignment: Alignment.topCenter, child: logList[index]);
              },
            ),
        ],
      ),
    );
  }
}
