import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils/session.dart';

import '../../utils/assets/nsvgs_assets.dart';
import '../../utils/styles.dart';
import '../../utils2/responsive.dart';
import '../login/login_page.dart';

class SplashPage extends StatefulWidget {
  final LoginRouterArgs? loginRouterArgs;

  const SplashPage({
    Key? key,
    this.loginRouterArgs,
  }) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Pandora pandora = Pandora();

  @override
  void initState() {
    // debugPrint('SPLASH REROUTE: ${widget.loginRouterArgs}');
    //
    // if (widget.loginRouterArgs != null) {
    //   if (widget.loginRouterArgs.canReroute) {
    //     debugPrint('SPLASH CAN REROUTE: ${widget.loginRouterArgs.canReroute}');
    //     pandora.delayforSeconds(1).whenComplete(() {
    //       reRouteUser('/signIn');
    //     });
    //   }
    // }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Material(
      child: Responsive(
        desktop: SizedBox(
          height: height,
          width: width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Image.asset(
                      NsvgsAssets.kLoginImage,
                      width: size.width,
                      height: size.height,
                      fit: BoxFit.fill,
                    ),
                    SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10, top: 25),
                            child: SvgPicture.asset(
                              NsvgsAssets.kWhiteLogo,
                              width: 45,
                              height: 45,
                            ),
                          ),
                          const Spacer(),
                          const Padding(
                            padding: EdgeInsets.only(left: 10, right: 9),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 14,
                                ),
                                AppSplashText.empower,
                                SizedBox(
                                  height: 14,
                                ),
                                AppSplashText.helpFarmers,
                                SizedBox(
                                  height: 50,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Get Started', style: Styles.semiBoldTextStyleBlack()),
                        const SizedBox(
                          width: 10,
                        ),
                        IconButton(
                          icon: SvgPicture.asset(
                            NsvgsAssets.kLoginFab,
                          ),
                          iconSize: 50,
                          onPressed: () {
                            reRouteUser('/signIn');
                            //reRouteUser('/offline');
                          },
                        ),
                      ],
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Container(
                        child: Text(
                          BUILD_CODE,
                          style: Styles.textSyleBlackw400(),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        tablet: Column(
          children: [
            Flexible(
              flex: 6,
              child: Stack(
                children: [
                  Image.asset(
                    NsvgsAssets.kLoginImage,
                    width: size.width,
                    height: size.height,
                    fit: BoxFit.fill,
                  ),
                  SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 25),
                          child: SvgPicture.asset(
                            NsvgsAssets.kWhiteLogo,
                            width: 45,
                            height: 45,
                          ),
                        ),
                        const Spacer(),
                        const Padding(
                          padding: EdgeInsets.only(left: 10, right: 9),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 14,
                              ),
                              AppSplashText.empower,
                              SizedBox(
                                height: 14,
                              ),
                              AppSplashText.helpFarmers,
                              SizedBox(
                                height: 50,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            BUILD_CODE,
                            style: Styles.textSyleBlackw400(),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Text('Get Started', style: Styles.semiBoldTextStyleBlack()),
                                const SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                  icon: SvgPicture.asset(
                                    NsvgsAssets.kLoginFab,
                                  ),
                                  iconSize: 50,
                                  onPressed: () {
                                    reRouteUser('/signIn');
                                    //reRouteUser('/offline');
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        mobile: Column(
          children: [
            Flexible(
              flex: 6,
              child: Stack(
                children: [
                  Image.asset(
                    NsvgsAssets.kLoginImage,
                    width: size.width,
                    height: size.height,
                    fit: BoxFit.fill,
                  ),
                  SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 25),
                          child: SvgPicture.asset(
                            NsvgsAssets.kWhiteLogo,
                            width: 45,
                            height: 45,
                          ),
                        ),
                        const Spacer(),
                        const Padding(
                          padding: EdgeInsets.only(left: 10, right: 9),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 14,
                              ),
                              AppSplashText.empower,
                              SizedBox(
                                height: 14,
                              ),
                              AppSplashText.helpFarmers,
                              SizedBox(
                                height: 50,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            BUILD_CODE,
                            style: Styles.textSyleBlackw400(),
                          ),
                          Row(
                            children: [
                              Text('Get Started', style: Styles.semiBoldTextStyleBlack()),
                              const SizedBox(
                                width: 10,
                              ),
                              IconButton(
                                icon: SvgPicture.asset(
                                  NsvgsAssets.kLoginFab,
                                ),
                                iconSize: 50,
                                onPressed: () {
                                  const LoginPage();
                                  // reRouteUser('/signIn');
                                  //reRouteUser('/offline');
                                },
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Container buildBackgroundGradient(Size size) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: Styles.boxDecoWithLinearGrad(),
    );
  }

  void reRouteUser(String route) {
    debugPrint('ABOUT TO REROUTE LOGIN: ');

    Navigator.of(context).pushNamed(route, arguments: widget.loginRouterArgs);
  }
}

class SplashText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const SplashText({
    Key? key,
    required this.text,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
    );
  }
}
