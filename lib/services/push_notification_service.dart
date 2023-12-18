import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/splash/splash_page.dart';

import '../network/crow/crow_authentication.dart';
import '../network/social/authentication.dart';
import '../network/social/firebase.dart';
import '../routes.dart';
import '../screens/home/widgets/community/feed/feed_helpers.dart';
import '../screens/home/widgets/community/feed/post_functions.dart';
import '../screens/home/widgets/community/feed/upload_post.dart';
import '../screens/home/widgets/community/landing_utils.dart';
import '../screens/home/widgets/community/messaging/chatroom_helpers.dart';
import '../screens/home/widgets/community/messaging/group_message_helpers.dart';
import '../screens/home/widgets/community/stories/stories_helper.dart';
import '../screens/home/widgets/profile/alt_profile_helpers.dart';
import '../screens/home/widgets/profile/profile_helpers.dart';
import '../screens/home/widgets/profile/upload_profile_picture.dart';
import '../screens/home/widgets/smatml/upload_leaf_picture.dart';
import '../utils/device_details.dart';
import '../utils/session.dart';

class PushNotificationService {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final Pandora pandora = Pandora();

  Future<String> initialize() async {
    String firebaseToken = '';
    await messaging.getToken().then((token) {
      if (token != null) {
        firebaseToken = token;
        Session.FirebaseDeviceToken = token;
        debugPrint('token: $token');
      }
    });

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await FirebaseMessaging.instance.requestPermission();

    if (Platform.isIOS) {
      final NotificationSettings settings = await messaging.requestPermission(
        announcement: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
      );

      debugPrint('User granted permission: ${settings.authorizationStatus}');
    }

    // onLaunch: When the app is completely closed (not in the background) and opened directly from the push notification
    await FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        debugPrint('getInitialMessage data: ${message.data}');
        _serialiseAndNavigate(message);
      }
    });

    // onMessage: When the app is open and it receives a push notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("onMessage data: ${message.data}");
      _serialiseAndNavigate(message);
    });

    // onResume: When the app is in the background and opened directly from the push notification.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('onMessageOpenedApp data: ${message.data}');
      _serialiseAndNavigate(message);
    });

    return firebaseToken;
  }

  Future<void> _serialiseAndNavigate(RemoteMessage message) async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    debugPrint('Message Body: $message');
    if (message.data.isEmpty) return;
    final notifications = message.data;
    final messageSource = notifications['message_source'];

    if (messageSource != null) {
      switch (messageSource) {
        case "FARM_SENSE":
          final deviceId = notifications['id'];
          if (deviceId != null) {
            handleFarmSenseNotification(deviceId);
          }
          break;
        default:
          break;
      }
    }
  }

  void handleFarmSenseNotification(String deviceId) {
    runApp(
      NotificationApp(
        loginRouterArgs: LoginRouterArgs(
          true,
          true,
          '/farmSenseNotificationDetails',
          deviceId,
        ),
      ),
    );
  }
}

class NotificationApp extends StatelessWidget {
  final LoginRouterArgs loginRouterArgs;

  const NotificationApp({super.key, required this.loginRouterArgs});

  @override
  Widget build(BuildContext context) {
    //FirebaseCrashlytics.instance.crash();
    final DeviceDetails details = DeviceDetails();
    details.initPlatformState();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CrowAuthentication()),
        ChangeNotifierProvider(create: (_) => ChatroomHelper()),
        ChangeNotifierProvider(create: (_) => GroupMessagingHelper()),
        ChangeNotifierProvider(create: (_) => StoriesHelper()),
        ChangeNotifierProvider(create: (_) => Authentication()),
        ChangeNotifierProvider(create: (_) => LandingUtils()),
        ChangeNotifierProvider(create: (_) => FirebaseOperations()),
        ChangeNotifierProvider(create: (_) => ProfileHelpers()),
        ChangeNotifierProvider(create: (_) => UploadPost()),
        ChangeNotifierProvider(create: (_) => UploadProfilePicture()),
        ChangeNotifierProvider(create: (_) => UploadLeafPicture()),
        ChangeNotifierProvider(create: (_) => FeedHelpers()),
        ChangeNotifierProvider(create: (_) => PostFunctions()),
        ChangeNotifierProvider(create: (_) => AltProfileHelpers()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: const Locale('mn', 'MN'),
        //initialRoute: '/signIn',
        onGenerateRoute: AppRoutes.generateRoute,
        builder: OneContext().builder,
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        navigatorObservers: [FirebaseAnalyticsObserver(analytics: GetIt.I<FirebaseAnalytics>())],
        home: SplashPage(loginRouterArgs: loginRouterArgs),
      ),
    );
  }
}
