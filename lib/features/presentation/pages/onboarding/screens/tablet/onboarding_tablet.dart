import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/features/presentation/provider/onboarding_state.dart';
import 'package:smat_crow/features/presentation/widgets/loading_state_widget.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/decoration.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

import '../../widgets/onboarding_button.dart';

class TabletOnboarding extends StatefulWidget {
  const TabletOnboarding({Key? key}) : super(key: key);

  @override
  State<TabletOnboarding> createState() => _TabletOnboardingState();
}

class _TabletOnboardingState extends State<TabletOnboarding> {
  late PageController _pageController;
  final List<String> _preloadedImages = [];

  @override
  void initState() {
    if (mounted) {
      _pageController = PageController();
      Future.delayed(Duration.zero).then((value) {
        final onboardingState =
            Provider.of<OnboardingState>(context, listen: false);
        onboardingState.loadData(isDesktop: false);
        onboardingState.setPageController(_pageController);
      });
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final onboardingState = Provider.of<OnboardingState>(context);
    for (final content in onboardingState.contents) {
      _preloadedImages.add(content.bgImage);
    }
  }

  @override
  void dispose() {
    if (mounted) {
      _pageController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onboardingState =
        Provider.of<OnboardingState>(context, listen: false);
    final buttonWidth = calculateButtonWidth(context);
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: AppColors.SmatCrowPrimary500,
      body: GestureDetector(
        onTap: onboardingState.navigateToNextSlide,
        child: PageView.builder(
          controller: _pageController,
          itemCount: onboardingState.contents.length,
          onPageChanged: (int index) {
            setState(() {
              onboardingState.currentIndex = index;
            });
          },
          itemBuilder: (_, i) {
            return Stack(
              children: [
                ImageNetwork(
                  image: _preloadedImages[i],
                  height: mediaQuery.size.height,
                  width: mediaQuery.size.width,
                  onLoading: const LoadingStateWidget(),
                  onError: const Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: SpacingConstants.size25,
                      ),
                      child: ImageNetwork(
                        image: onboardingState.contents[i].logo,
                        height: SpacingConstants.size44,
                        width: SpacingConstants.size217,
                        fitAndroidIos: BoxFit.scaleDown,
                        fitWeb: BoxFitWeb.scaleDown,
                        onLoading: const LoadingStateWidget(),
                        onError: const Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: SpacingConstants.size20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: SpacingConstants.size160,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  onboardingState.contents[i].title,
                                  style: Styles.smatCrowHeadingBold2(),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: SpacingConstants.size15,
                                ),
                                Text(
                                  onboardingState.contents[i].desc,
                                  style: Styles.smatCrowParagraphRegular(
                                    fontSize: SpacingConstants.font16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: SpacingConstants.size15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              onboardingState.contents.length,
                              (index) => buildDot(index, context),
                            ),
                          ),
                          const SizedBox(
                            height: SpacingConstants.size20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: SpacingConstants.size160,
                            ),
                            child: OnboardingButton(
                              buttonWidth: buttonWidth,
                              buttonHeight: SpacingConstants.size48,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return DecorationBox.buildBDotContainer(
      color:
          Provider.of<OnboardingState>(context, listen: false).currentIndex ==
                  index
              ? AppColors.SmatCrowDefaultWhite
              : AppColors.SmatCrowNeuBlue400,
    );
  }
}
