import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/app_helper.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

//activity demo

class ActivityDemoWidget extends StatefulWidget {
  final List<String>? activities;
  final List<String>? activityDescriptions;
  final VoidCallback? onSkip;
  final VoidCallback? onNext;

  const ActivityDemoWidget({
    super.key,
    this.activities,
    this.activityDescriptions,
    this.onSkip,
    this.onNext,
  });

  @override
  _ActivityDemoWidgetState createState() => _ActivityDemoWidgetState();
}

class _ActivityDemoWidgetState extends State<ActivityDemoWidget> {
  int currentIndex = SpacingConstants.int0;

  void handleSkip() {
    ApplicationHelpers().trackButtonAndDeviceEvent('SKIP_BUTTON_CLICK');
    setState(() {
      currentIndex = widget.activities!.length - SpacingConstants.int1;
      widget.onSkip!();
    });
  }

  void handleNext() {
    ApplicationHelpers().trackButtonAndDeviceEvent('ACTIVITY_NEXT_BUTTON_CLICK');
    if (currentIndex < widget.activities!.length - SpacingConstants.int1) {
      setState(() {
        currentIndex++;
        widget.onNext!();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final int totalActivities = widget.activities!.length;
    return Expanded(
      child: Stack(
        children: [
          Container(
            width: SpacingConstants.double324,
            height: SpacingConstants.double201,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SpacingConstants.double25),
            ),
            padding: const EdgeInsets.all(
              SpacingConstants.size16,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.activities![currentIndex],
                      style: Styles.smatCrowMediumCaption(
                        AppColors.SmatCrowNeuBlue900,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      '${currentIndex + SpacingConstants.int1} of $totalActivities',
                      style: const TextStyle(
                        color: AppColors.SmatCrowPrimary500,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Text(
                    widget.activityDescriptions![currentIndex],
                    style: Styles.smatCrowCaptionRegular(
                      color: AppColors.SmatCrowNeuBlue500,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                customSizedBoxHeight(SpacingConstants.size16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: handleSkip,
                      child: Container(
                        width: SpacingConstants.size100,
                        height: SpacingConstants.size28,
                        decoration: BoxDecoration(
                          color: AppColors.SmatCrowDefaultWhite,
                          borderRadius: BorderRadius.circular(SpacingConstants.size100),
                          border: Border.all(color: AppColors.SmatCrowPrimary500),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(
                            left: SpacingConstants.size12,
                            right: SpacingConstants.size12,
                          ),
                          child: Center(
                            child: Text(
                              skipText,
                              style: TextStyle(
                                color: AppColors.SmatCrowPrimary500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    customSizedBoxWidth(SpacingConstants.size16),
                    GestureDetector(
                      onTap: handleNext,
                      child: Container(
                        width: SpacingConstants.size100,
                        height: SpacingConstants.size28,
                        decoration: BoxDecoration(
                          color: AppColors.SmatCrowPrimary500,
                          borderRadius: BorderRadius.circular(SpacingConstants.size100),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(
                            left: SpacingConstants.size12,
                            right: SpacingConstants.size12,
                          ),
                          child: Center(
                            child: Text(
                              nextText,
                              style: TextStyle(
                                color: AppColors.SmatCrowDefaultBlack,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: SpacingConstants.double12,
            left: SpacingConstants.size34,
            child: Transform.rotate(
              angle: SpacingConstants.Pointint45 * SpacingConstants.PointDouble3 / SpacingConstants.int180,
              child: Container(
                width: SpacingConstants.size21,
                height: SpacingConstants.size21,
                color: AppColors.SmatCrowDefaultWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
