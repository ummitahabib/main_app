import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/features/domain/entities/user/user_entity.dart';
import 'package:smat_crow/features/presentation/pages/home_page/screens/desktop/home_desktop.dart';
import 'package:smat_crow/features/presentation/pages/profile/profile_main_screen.dart';
import 'package:smat_crow/features/presentation/pages/socials/screens/social_page.dart';
import 'package:smat_crow/features/presentation/widgets/custom_button.dart';
import 'package:smat_crow/utils2/assets/shared/shared/splash/splash_assets.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/decoration.dart';
import 'package:smat_crow/utils2/images_constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

//home page desktop widget

class HomePageDesktop extends StatefulWidget {
  final String? uid;
  final UserEntity? currentUser;

  final Map<String, List>? newsData;
  const HomePageDesktop({
    Key? key,
    this.newsData,
    this.currentUser,
    this.uid,
  }) : super(key: key);

  @override
  State<HomePageDesktop> createState() => _HomePageDesktopState();
}

class _HomePageDesktopState extends State<HomePageDesktop> {
  Map<String, List> newsData = <String, List>{};
  int currentIndex = SpacingConstants.int0;
  void selectedTab(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  Widget getPageContent() {
    switch (currentIndex) {
      case SpacingConstants.int0:
        return const HomeDesktop();
      case SpacingConstants.int1:
        if (widget.currentUser != null && widget.uid != null) {
          return const SocialHomePage();
        } else {
          return const Text("User data not available.");
        }
      case SpacingConstants.int2:
        return const ProfileMainScreen();
      default:
        return const Text(errorSelectedTab);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: SpacingConstants.size270,
                  height: SpacingConstants.double900,
                  color: AppColors.SmatCrowDefaultWhite,
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: SpacingConstants.size55,
                          bottom: SpacingConstants.size82,
                          right: SpacingConstants.size102,
                          top: SpacingConstants.size45,
                        ),
                        child: Image.asset(
                          SplashAssets.splashLogo,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: SpacingConstants.size53,
                        ),
                        child: ListTile(
                          leading: Icon(
                            EvaIcons.home,
                            color: currentIndex == SpacingConstants.int0
                                ? AppColors.SmatCrowPrimary500
                                : AppColors.SmatCrowNeuBlue300,
                          ),
                          title: Text(
                            home,
                            style: Styles.smatCrowMediumSubParagraph(
                              color: AppColors.SmatCrowNeuBlue900,
                            ),
                          ),
                          onTap: () => selectedTab(SpacingConstants.int0),
                        ),
                      ),
                      customSizedBoxHeight(SpacingConstants.size16),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: SpacingConstants.size53,
                        ),
                        child: ListTile(
                          leading: Icon(
                            EvaIcons.navigation,
                            color: currentIndex == SpacingConstants.int2
                                ? AppColors.SmatCrowPrimary500
                                : AppColors.SmatCrowNeuBlue300,
                          ),
                          title: Text(
                            socials,
                            style: Styles.smatCrowMediumSubParagraph(
                              color: AppColors.SmatCrowNeuBlue900,
                            ),
                          ),
                          onTap: () => selectedTab(SpacingConstants.int2),
                        ),
                      ),
                      customSizedBoxHeight(SpacingConstants.size16),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: SpacingConstants.size53,
                        ),
                        child: ListTile(
                          leading: Icon(
                            EvaIcons.person,
                            color: currentIndex == SpacingConstants.int3
                                ? AppColors.SmatCrowPrimary500
                                : AppColors.SmatCrowNeuBlue300,
                          ),
                          title: Text(
                            profile,
                            style: Styles.smatCrowMediumSubParagraph(
                              color: AppColors.SmatCrowNeuBlue900,
                            ),
                          ),
                          onTap: () => selectedTab(SpacingConstants.int3),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: SpacingConstants.size600,
                          left: SpacingConstants.size16,
                          right: SpacingConstants.size16,
                          bottom: SpacingConstants.size20,
                        ),
                        child: Container(
                          width: SpacingConstants.size213,
                          height: SpacingConstants.size246,
                          decoration: DecorationBox.boxDecorationWithShadow(),
                          child: Column(
                            children: [
                              desktopAdImageWidget(),
                              customSizedBoxHeight(SpacingConstants.size16),
                              Expanded(
                                child: Text(
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  expandHorizon,
                                  style: Styles.desktopTextStyle(),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                  top: SpacingConstants.double24,
                                  bottom: SpacingConstants.double20,
                                ),
                                child: CustomButton(
                                  color: AppColors.SmatCrowPrimary500,
                                  borderColor: AppColors.SmatCrowPrimary500,
                                  text: getStartedNow,
                                  textColor: AppColors.SmatCrowDefaultBlack,
                                  width: SpacingConstants.double164,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: getPageContent(),
          )
        ],
      ),
    );
  }
}
