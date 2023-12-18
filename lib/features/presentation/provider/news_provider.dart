// ignore_for_file: always_declare_return_types, type_annotate_public_apis

import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/features/domain/entities/category_entity.dart';
import 'package:smat_crow/features/domain/entities/user/news_entity.dart';
import 'package:smat_crow/features/domain/repository/firebase_repository.dart';
import 'package:smat_crow/network/crow/models/user_response.dart';
import 'package:smat_crow/network/crow/user_operations.dart';
import 'package:smat_crow/utils/session.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class NewsProvider with ChangeNotifier {
  final FirebaseRepository? firebaseRepository;

  NewsProvider({this.firebaseRepository});

  // Properties
  Map<String, List> newsData = <String, List>{};
  bool isLoading = true;
  String text = constantSource;
  String title = constantTitle;

  final Color foregroundOn = AppColors.SmatCrowDefaultWhite;
  final Color foregroundOff = AppColors.SmatCrowDefaultBlack;
  final Color backgroundOn = AppColors.SmatCrowPrimary800;
  final Color backgroundOff = AppColors.SmatCrowDefaultWhite;

  UserDetailsResponse? userDetailsResponse;
  final AsyncMemoizer profileAsync = AsyncMemoizer();
  final ScrollController scrollController = ScrollController();
  String firstName = emptyString, lastName = emptyString, email = emptyString;
  TabController? controller;

  AnimationController? animationControllerOn;

  AnimationController? animationControllerOff;

  late Animation colorTweenBackgroundOn;
  Animation? colorTweenBackgroundOff;

  Animation? colorTweenForegroundOn;
  Animation? colorTweenForegroundOff;

  int currentIndex = 0;

  int prevControllerIndex = 0;

  double aniValue = 0.0;

  double prevAniValue = 0.0;

  final List keys = [];
  bool buttonTap = false;

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  handleTabAnimation(BuildContext context) {
    aniValue = controller!.animation!.value;

    if (!buttonTap && ((aniValue - prevAniValue).abs() < 1)) {
      setCurrentIndex(aniValue.round(), context);
    }

    prevAniValue = aniValue;
  }

  handleTabChange(BuildContext context) {
    if (buttonTap) setCurrentIndex(controller!.index, context);

    if ((controller!.index == prevControllerIndex) || (controller!.index == aniValue.round())) buttonTap = false;

    prevControllerIndex = controller!.index;
  }

  setCurrentIndex(int index, BuildContext context) {
    if (index != currentIndex) {
      currentIndex = index;
      notifyListeners();

      triggerAnimation();
      scrollTo(index, context);
    }
  }

  triggerAnimation() {
    animationControllerOn!.reset();
    animationControllerOff!.reset();

    animationControllerOn!.forward();
    animationControllerOff!.forward();
  }

  scrollTo(
    int index,
    BuildContext context,
  ) {
    double screenWidth = MediaQuery.of(context).size.width;

    RenderBox renderBox = keys[index].currentContext.findRenderObject();
    double size = renderBox.size.width;
    double position = renderBox.localToGlobal(Offset.zero).dx;
    double offset = (position + size / 2) - screenWidth / 2;
    if (offset < 0) {
      renderBox = keys[0].currentContext.findRenderObject();
      position = renderBox.localToGlobal(Offset.zero).dx;

      if (position > offset) offset = position;
    } else {
      renderBox = keys[categories.length - 1].currentContext.findRenderObject();
      position = renderBox.localToGlobal(Offset.zero).dx;
      size = renderBox.size.width;

      if (position + size < screenWidth) screenWidth = position + size;
      if (position + size - offset < screenWidth) {
        offset = position + size - screenWidth;
      }
    }

    scrollController.animateTo(
      offset + scrollController.offset,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOut,
    );
  }

  dynamic getBackgroundColor(int index) {
    if (index == currentIndex) {
      return colorTweenBackgroundOn.value;
    } else if (index == prevControllerIndex) {
      return colorTweenBackgroundOff!.value;
    } else {
      return backgroundOff;
    }
  }

  dynamic getForegroundColor(int index) {
    if (index == currentIndex) {
      return colorTweenForegroundOn!.value;
    } else if (index == prevControllerIndex) {
      return colorTweenForegroundOff!.value;
    } else {
      return foregroundOff;
    }
  }

  void onCategoryButtonPressed(int index, BuildContext context) {
    buttonTap = true;
    controller!.animateTo(index);
    setCurrentIndex(index, context);
    scrollTo(index, context);
  }

  Future<List<NewsEntity>> getNews(String country) async {
    final result = await firebaseRepository!.fetchNews(NewsEntity(category: "$agriculture+in+$country"));
    return result;
  }

  getData(BuildContext context) async {
    final repository = firebaseRepository!;
    await Future.wait([
      firebaseRepository!.fetchNews(const NewsEntity(category: agriculture)),
      repository.fetchNews(const NewsEntity(category: agricultureInNigeria)),
      repository.fetchNews(const NewsEntity(category: agricultureInAfrica)),
      repository.fetchNews(
        const NewsEntity(category: agricultureInNorthAmerica),
      ),
      repository.fetchNews(
        const NewsEntity(category: agricultureInSouthAmerica),
      ),
      repository.fetchNews(
        const NewsEntity(category: agricultureInEurope),
      ),
      repository.fetchNews(const NewsEntity(category: agricultureInMiddleEast)),
      repository.fetchNews(const NewsEntity(category: agricultureInAsia)),
      repository.fetchNews(const NewsEntity(category: agricultureInAustralia)),
    ])
        .then(
          (List<List<NewsEntity>> value) {
            newsData[agriculture] = value[SpacingConstants.int0];
            newsData[nigeria] = value[SpacingConstants.int1];

            isLoading = false;
            notifyListeners();
          } as FutureOr Function(List<List> value),
        )
        .timeout(const Duration(seconds: SpacingConstants.int10))
        .whenComplete(() {
      isLoading = false;
      notifyListeners();
    });
  }

  Future getProfileInformation() async {
    return profileAsync.runOnce(() async {
      userDetailsResponse = await getUserDetails();
      Session.userDetailsResponse = userDetailsResponse;

      firstName = userDetailsResponse!.user!.firstName!;
      email = userDetailsResponse!.user!.email!;
      notifyListeners();
      return userDetailsResponse;
    });
  }
}
