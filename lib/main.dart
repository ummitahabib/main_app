import 'dart:io';

import 'package:beamer/beamer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart' as pro;
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/features/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:smat_crow/features/domain/usecases/firebase_usecases/user/is_sign_in_usecase.dart';
import 'package:smat_crow/features/domain/usecases/firebase_usecases/user/sign_out_usecase.dart';
import 'package:smat_crow/features/presentation/pages/credential/forget_password/forget_password.dart';
import 'package:smat_crow/features/presentation/pages/credential/reset_password/reset_page.dart';
import 'package:smat_crow/features/presentation/pages/credential/signin/signin.dart';
import 'package:smat_crow/features/presentation/pages/credential/signup/signup.dart';
import 'package:smat_crow/features/presentation/pages/onboarding/screens/onboarding_page.dart';
import 'package:smat_crow/features/presentation/pages/splash/screens/splash_page.dart';
import 'package:smat_crow/features/presentation/pages/verify/verify_email.dart';
import 'package:smat_crow/features/presentation/provider/credentials.dart';
import 'package:smat_crow/features/presentation/provider/get_other_users.dart';
import 'package:smat_crow/features/presentation/provider/get_single_user.dart';
import 'package:smat_crow/features/presentation/provider/news_provider.dart';
import 'package:smat_crow/features/presentation/provider/post/post_state.dart';
import 'package:smat_crow/features/presentation/provider/signin_state.dart';
import 'package:smat_crow/features/presentation/provider/signup_state.dart';
import 'package:smat_crow/features/shared/views/dashboard_view_web.dart';
import 'package:smat_crow/firebase_options.dart';
import 'package:smat_crow/routes.dart';
import 'package:smat_crow/screens/fieldagents/fieldagents_providers/create_soil_sample_provider.dart';
import 'package:smat_crow/screens/fieldagents/fieldagents_providers/field_measurement_page_provider.dart';
import 'package:smat_crow/screens/fieldagents/fieldagents_providers/plant_detail_provider.dart';
import 'package:smat_crow/screens/fieldagents/fieldagents_providers/planted_chart_item_provider.dart';
import 'package:smat_crow/screens/fieldagents/fieldagents_providers/popular_plant_provider.dart';
import 'package:smat_crow/screens/fieldagents/fieldagents_providers/sun_chart_provider.dart';
import 'package:smat_crow/screens/home/widgets/profile/profile_helpers.dart';
import 'package:smat_crow/screens/home/widgets/profile/upload_profile_picture.dart';
import 'package:smat_crow/screens/subscription/provider/subscriptions_provider.dart';
import 'package:smat_crow/utils/device_details.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/theme_config.dart';
import 'package:upgrader/upgrader.dart';

import 'features/presentation/provider/onboarding_state.dart';
import 'network/social/authentication.dart';
import 'network/social/firebase.dart';
import 'utils2/service_locator.dart' as di;
import 'utils2/service_locator.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupLocator();
  await Hive.initFlutter();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const pro.ProviderScope(child: MyApp()));
}

SignOutUseCase? signOutUseCase;
IsSignInUseCase? isSignInUseCase;
GetCurrentUidUseCase? getCurrentUidUseCase;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DeviceDetails details = DeviceDetails();
    details.initPlatformState();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FieldMeasurementPageProvider()),
        ChangeNotifierProvider(create: (_) => OnboardingState()),
        ChangeNotifierProvider(create: (_) => SigninState()),
        ChangeNotifierProvider(
          create: (_) => di.locator<NewsProvider>(),
        ),
        ChangeNotifierProvider(create: (_) => PopularPlantsProvider()),
        ChangeNotifierProvider(
          create: (_) => di.locator<SignUpState>(),
        ),
        ChangeNotifierProvider(create: (_) => SunChartProvider()),
        ChangeNotifierProvider(create: (_) => PlantDetailProvider()),
        ChangeNotifierProvider(create: (_) => PlantedChartItemProvider()),
        ChangeNotifierProvider(create: (_) => CreateSoilSamplesPageProvider()),
        ChangeNotifierProvider(create: (_) => SubscriptionsProvider()),
        ChangeNotifierProvider(
          create: (_) => di.locator<GetSingleOtherUserProvider>(),
        ),
        ChangeNotifierProvider(create: (_) => di.locator<GetSingleUserProvider>()),
        ChangeNotifierProvider(create: (_) => di.locator<CredentialProvider>()),
        ChangeNotifierProvider(create: (_) => di.locator<CredentialProvider>()),
        ChangeNotifierProvider(create: (_) => di.locator<PostProvider>()),
        ChangeNotifierProvider(create: (_) => Authentication()),
        ChangeNotifierProvider(create: (_) => FirebaseOperations()),
        ChangeNotifierProvider(create: (_) => ProfileHelpers()),
        ChangeNotifierProvider(create: (_) => UploadProfilePicture()),
      ],
      child: MaterialAppWrapper(),
    );
  }
}

class MaterialAppWrapper extends StatelessWidget {
  MaterialAppWrapper({
    Key? key,
  }) : super(key: key);
  final routerDelegate = BeamerDelegate(
    initialPath: ConfigRoute.splash,
    notFoundPage: const BeamPage(
      child: NoPageFound(),
      key: ValueKey("NoPageFound"),
    ),
    transitionDelegate: const NoAnimationTransitionDelegate(),
    locationBuilder: RoutesLocationBuilder(
      routes: {
        "*": (context, state, data) {
          GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'SINGLE_USER_PROFILE_SCREEN');
          return const BeamPage(
            child: Responsive(
              desktop: DashboardView(),
              mobile: DashboardView(),
              tablet: DashboardView(),
            ),
            key: ValueKey("Main-Dash-board"),
            type: BeamPageType.noTransition,
          );
        },
        "/": (context, state, data) {
          GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'SINGLE_USER_PROFILE_SCREEN');
          return const BeamPage(
            child: Responsive(
              desktop: DashboardView(),
              mobile: DashboardView(),
              tablet: DashboardView(),
            ),
            key: ValueKey("MainDashboard"),
            type: BeamPageType.noTransition,
          );
        },
        ConfigRoute.onboarding: (context, state, data) {
          GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'ONBOARDING_SCREEN');
          return const BeamPage(
            child: OnboardingPage(),
            key: ValueKey("OnboardingPage"),
            type: BeamPageType.slideLeftTransition,
          );
        },
        ConfigRoute.splash: (context, state, data) {
          GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'SPLASH_SCREEN');
          return BeamPage(
            child: const SplashScreen(),
            key: ValueKey("splash - ${DateTime.now()}"),
            type: BeamPageType.slideLeftTransition,
          );
        },
        ConfigRoute.login: (context, state, data) {
          GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'SIGNIN_SCREEN');
          return BeamPage(
            child: const SigninPage(),
            key: ValueKey("SigninPage - ${DateTime.now()}"),
            type: BeamPageType.slideLeftTransition,
          );
        },
        ConfigRoute.signup: (context, state, data) {
          GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'SIGNUP_SCREEN');
          return BeamPage(
            child: const SignUpPage(),
            key: ValueKey("signUp - ${DateTime.now()}"),
            type: BeamPageType.slideLeftTransition,
          );
        },
        ConfigRoute.resetPasswordPage: (context, state, data) {
          GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'ResetPasswordPage_SCREEN');
          return const BeamPage(
            child: ResetPasswordPage(),
            key: ValueKey("ResetPasswordPage"),
            type: BeamPageType.noTransition,
          );
        },
        ConfigRoute.verifyEmailPage: (context, state, data) {
          GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'SIGNUP_SCREEN');
          return const BeamPage(
            child: VerifyEmail(),
            key: ValueKey("VerifyEmail"),
            type: BeamPageType.noTransition,
          );
        },
        ConfigRoute.userForgetPassword: (context, state, data) {
          GetIt.I<FirebaseAnalytics>().setCurrentScreen(screenName: 'SIGNUP_SCREEN');
          return const BeamPage(
            child: ForgetPassword(),
            key: ValueKey("ForgetPassword"),
            type: BeamPageType.noTransition,
          );
        },
      },
    ),
    navigatorObservers: [FirebaseAnalyticsObserver(analytics: GetIt.I<FirebaseAnalytics>())],
  );

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return BeamerProvider(
        key: myGlobalKey,
        routerDelegate: routerDelegate,
        child: MaterialApp.router(
          key: UniqueKey(),
          debugShowCheckedModeBanner: false,
          routeInformationParser: BeamerParser(),
          routerDelegate: routerDelegate,
          locale: const Locale('mn', 'MN'),
          builder: OneContext().builder,
          theme: ThemeConfig.lightTheme,
        ),
      );
    }
    return MaterialApp(
      key: UniqueKey(),
      debugShowCheckedModeBanner: false,
      locale: const Locale('mn', 'MN'),
      //  initialRoute: ConfigRoute.onboarding,
      onGenerateRoute: AppRoutes.generateRoute,
      builder: OneContext().builder,
      theme: ThemeConfig.lightTheme,
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: GetIt.I<FirebaseAnalytics>()),
      ],
      home: UpgradeAlert(
        upgrader: Upgrader(
          showIgnore: false,
          durationUntilAlertAgain: const Duration(hours: 6),
          dialogStyle: Platform.isIOS ? UpgradeDialogStyle.cupertino : UpgradeDialogStyle.material,
        ),
        child: const OnboardingPage(),
      ),
      navigatorKey: navigatorKey,
    );
  }
}

final myGlobalKey = GlobalKey();
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
