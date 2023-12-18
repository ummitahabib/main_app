import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onboarding/onboarding.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/colors.dart';
import '../../utils/assets/onboarding_assets.dart';
import '../../utils/constants.dart';
import '../../utils/styles.dart';

class TutorialPage extends StatefulWidget {
  const TutorialPage({super.key});

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  int index = 0;

  final onBoardingPagesList = [
    PageModel(
      widget: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Container()),
            SvgPicture.asset(
              OnboardingAssets.kIcon1,
            ),
            const SizedBox(
              height: 25,
            ),
            AppHeaderText.weatherMonitoring,
            const SizedBox(
              height: 25,
            ),
            AppSubHeaderText.weatherMonitor,
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    ),
    PageModel(
      widget: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Container()),
            SvgPicture.asset(
              OnboardingAssets.kIcon2,
            ),
            const SizedBox(
              height: 25,
            ),
            AppHeaderText.satelliteImagery,
            const SizedBox(
              height: 25,
            ),
            AppSubHeaderText.dailySatelliteImagery,
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    ),
    PageModel(
      widget: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Container()),
            SvgPicture.asset(
              OnboardingAssets.kIcon3,
            ),
            const SizedBox(
              height: 25,
            ),
            AppHeaderText.droneFlight,
            const SizedBox(
              height: 25,
            ),
            AppSubHeaderText.droneDataCapture,
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    ),
    PageModel(
      widget: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Container()),
            SvgPicture.asset(
              OnboardingAssets.kIcon4,
            ),
            const SizedBox(
              height: 25,
            ),
            AppHeaderText.iot,
            const SizedBox(
              height: 25,
            ),
            AppSubHeaderText.iotInsight,
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    ),
    PageModel(
      widget: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Container()),
            SvgPicture.asset(
              OnboardingAssets.kIcon5,
            ),
            const SizedBox(
              height: 25,
            ),
            AppHeaderText.aiBacked,
            const SizedBox(
              height: 25,
            ),
            AppSubHeaderText.aiInsight,
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    ),
    PageModel(
      widget: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Container()),
            SvgPicture.asset(
              OnboardingAssets.kIcon6,
            ),
            const SizedBox(
              height: 25,
            ),
            AppHeaderText.agronomists,
            const SizedBox(
              height: 25,
            ),
            AppSubHeaderText.agronomistAccessInsight,
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    index = 0;
  }

  Material _buildButton({
    required VoidCallback onPressed,
    required String text,
    Color? color,
  }) {
    return Material(
      borderRadius: defaultSkipButtonBorderRadius,
      color: color,
      child: InkWell(
        borderRadius: defaultSkipButtonBorderRadius,
        onTap: onPressed,
        child: Padding(
          padding: defaultSkipButtonPadding,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              fontFamily: 'semibold',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int previousPageIndex = 0;

    final Pandora pandora = Pandora();
    return Container(
      color: Colors.white,
      child: Onboarding(
        pages: onBoardingPagesList,
        onPageChange: (int pageIndex) {
          setState(() {
            previousPageIndex = index;
            index = pageIndex;
            if (index < previousPageIndex) {}
          });
        },
        footerBuilder: (context, dragDistance, pagesLength, setIndex) {
          final isLastPage = index == pagesLength - 1;
          final button = isLastPage
              ? _buildButton(
                  onPressed: () {
                    pandora.reRouteUser(context, '/homePage', '');
                  },
                  text: 'Continue',
                  color: AppColors.landingOrangeButton,
                )
              : _buildButton(
                  onPressed: () {
                    index = pagesLength - 1;
                    setIndex(pagesLength - 1);
                  },
                  text: 'Skip',
                  color: AppColors.landingOrangeButton,
                );
          return DecoratedBox(
            decoration: Styles.boxDecoStyle2(),
            child: ColoredBox(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(45.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomIndicator(
                      netDragPercent: dragDistance,
                      pagesLength: pagesLength,
                      indicator: Styles.indicator(),
                    ),
                    button,
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
