// ignore_for_file: use_setters_to_change_properties

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

import '../../../utils2/constants.dart';
import '../../data/models/onboarding_data_model.dart';

class OnboardingState extends ChangeNotifier {
  int currentIndex = SpacingConstants.int0;
  late PageController _pageController;
  List<OnboardingDataModel> contents = [];

  PageController get pageController => _pageController;

  void setPageController(PageController controller) {
    _pageController = controller;
  }

  Future<void> navigateToNextSlide() async {
    if (currentIndex < contents.length - SpacingConstants.int1) {
      await _pageController.nextPage(
        duration: const Duration(milliseconds: SpacingConstants.size300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> loadData({required bool isDesktop}) async {
    contents = onboardingContent.map((e) => OnboardingDataModel.fromJson(e)).toList();
    await Future.delayed(const Duration(milliseconds: 1)); // use await

    notifyListeners();
  }

  Future delayforSeconds(int seconds) {
    return Future.delayed(
      Duration(milliseconds: seconds * SpacingConstants.int1000),
    ).then((onValue) => true);
  }

  void loopSlide(PageController pageController) {
    final int newIndex = (currentIndex + SpacingConstants.int1) % contents.length;
    currentIndex = newIndex;
    pageController.animateToPage(
      newIndex,
      duration: const Duration(milliseconds: SpacingConstants.size300),
      curve: Curves.ease,
    );
  }
}
