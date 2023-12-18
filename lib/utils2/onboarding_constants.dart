import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/features/presentation/provider/onboarding_state.dart';
import 'package:smat_crow/features/presentation/widgets/loading_state_widget.dart';
import 'package:smat_crow/utils2/decoration.dart';
import 'package:smat_crow/utils2/images_constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

import 'colors.dart';

class OnboardingConstants extends StatefulWidget {
  const OnboardingConstants({Key? key}) : super(key: key);

  @override
  State<OnboardingConstants> createState() => _OnboardingConstantsState();
}

class _OnboardingConstantsState extends State<OnboardingConstants> {
  late PageController _pageController;
  Timer? _timer;
  bool _dataLoaded = false;

  @override
  void initState() {
    if (mounted) {
      _pageController = PageController();

      final onboardingState =
          Provider.of<OnboardingState>(context, listen: false);
      if (onboardingState.contents.isNotEmpty) {
        _dataLoaded = true;
      }
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_dataLoaded) {
      final onboardingState =
          Provider.of<OnboardingState>(context, listen: false);
      onboardingState.loadData(isDesktop: true).then((_) {
        if(mounted){
          setState(() {
            _pageController =
                PageController(initialPage: onboardingState.currentIndex);
            _timer = Timer.periodic(
                const Duration(seconds: SpacingConstants.int5), (_) {
              onboardingState.loopSlide(_pageController);
            });
            _dataLoaded = true;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    if (mounted) {
      _pageController.dispose();
      if (_timer != null) {
        _timer!.cancel();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _dataLoaded ? Future.value() : _loadData(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !_dataLoaded) {
          return const LoadingStateWidget();
        } else if (snapshot.hasError) {
          return Container(
            decoration: const BoxDecoration(
              image:
                  DecorationImage(image: AssetImage(ImageConstants.errorImage)),
            ),
          );
        } else {
          return _buildPageView(context);
        }
      },
    );
  }

  Future<void> _loadData(BuildContext context) async {
    if(mounted){
      final onboardingState =
      Provider.of<OnboardingState>(context, listen: false);
      if (onboardingState.contents.isEmpty) {
        await onboardingState.loadData(isDesktop: true);
      }
    }
  }

  Widget _buildPageView(BuildContext context) {
    final onboardingState =
        Provider.of<OnboardingState>(context, listen: false);
    final mediaQuery = MediaQuery.of(context);
    return Stack(
      children: [
        ImageNetwork(
          image: onboardingState.contents[onboardingState.currentIndex].bgImage,
          onLoading: const LoadingStateWidget(),
          onError: const Icon(
            Icons.error,
            color: Colors.red,
          ),
          height: mediaQuery.size.height,
          width: SpacingConstants.size502,
        ),
        Column(
          children: [
            ImageNetwork(
              image: onboardingState.contents[0].logo,
              height: SpacingConstants.size77,
              width: SpacingConstants.size217,
              fitAndroidIos: BoxFit.scaleDown,
              fitWeb: BoxFitWeb.scaleDown,
              onLoading: const LoadingStateWidget(),
              onError: const Icon(
                Icons.error,
                color: Colors.red,
              ),
            ),
          ],
        ),

        _buildContent(context, onboardingState),
      ],
    );
  }

  Widget _buildContent(BuildContext context, OnboardingState onboardingState) {
    return SizedBox(
      width: SpacingConstants.size502,
      child: PageView.builder(
        controller: _pageController,
        itemCount: onboardingState.contents.length,
        onPageChanged: (int index) {
          setState(() {
            onboardingState.currentIndex = index;
          });
        },
        itemBuilder: (_, i) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                  padding: const EdgeInsets.all(SpacingConstants.size50),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        onboardingState.contents[i].title,
                        style: Styles.smatCrowHeadingBold2(),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: SpacingConstants.size24,
                      ),
                      Text(
                        onboardingState.contents[i].desc,
                        style: Styles.smatCrowParagraphRegular(
                          fontSize: SpacingConstants.font16,
                        ),
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: SpacingConstants.size24,
                      ),
                      Row(
                        children: List.generate(
                          onboardingState.contents.length,
                          (index) => buildDot(index, context),
                        ),
                      ),
                    ],
                  ),
              ),
            ],
          );
        },
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
