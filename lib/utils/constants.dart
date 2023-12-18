// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smat_crow/network/crow/models/user_by_id_response.dart';
import 'package:smat_crow/screens/widgets/sub_header_text.dart';
import 'package:smat_crow/utils/session.dart';
import 'package:smat_crow/utils2/api_client.dart';
import '../screens/splash/splash_page.dart';
import '../screens/widgets/header_text.dart';
import 'colors.dart';

// paystack keys
String kPaystackKey = ApiClient.isLiveEnvironment
    ? 'pk_live_ff5e318c880876ca12c33984ee857afe8569f095'
    : 'pk_test_6c50a0346bc976d183a31f70f5e1315a88a43e33';

String BUILD_CODE = (Session.APP_TYPE == "DEV") ? '2.4.14-insider-preview' : '2.6.1-public';
//: '2.4.1-release-build';
String WTH_KEY = '0e174b0b6b7a0029aa6efac5e3833589';
String BASE_URL = ApiClient()
    .baseUrl; // (Session.APP_TYPE == "DEV") ? 'http://sandbox.airsmat.com:8080/api' : 'https://api.airsmat.com/api';
String GROW_STUFF_BASE_URL = 'https://www.growstuff.org';
String GROW_STUFF_V1_BASE_URL = 'https://www.growstuff.org/api/v1';
String COMMODITY_SERVICE_BASE_URL = 'https://preprod.airsmat.com/api';
String OPEN_FARM_URL = 'https://openfarm.cc/en/crops/';
String GARDENATE_URL = 'https://www.gardenate.com/plant/';
String WIKI_HOW = 'https://www.wikihow.com/wikiHowTo?search=how+to+grow+';
String DEFAULT_IMAGE =
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80';
String AppId = '';
String TC =
    'https://docs.google.com/document/d/e/2PACX-1vRw9Xrrjkv7XHI2FZofKkfmAWzAU82baMXEPDWqap9aOap7P9f5eIHw-tJ7xOaZyg/pub';
String DeviceIp = '';
String DeviceManufacturer = '';
String DeviceName = '';
String DeviceType = '';
String DeviceModel = '';
String USER_NAME = '';
String USER_ID = '';
String tmp_url = '';
String Email = '';
GetUserByIdResponse? userData;
int PickedImageQuality = 30;

// const dashboardMenuList = <Map<String, dynamic>>[
//   {
//     "text": "Farm Management",
//     "image": "assets/nsvgs/dashboard/Icons_Farm_Management.svg",
//     "background": AppColors.dashFarmManagement,
//     "route": '/farmManager'
//   },
//   {
//     "text": "Field Agents",
//     "image": "assets/nsvgs/dashboard/Icons_Field_Agents.svg",
//     "background": AppColors.dashFieldAgents,
//     "route": '/fieldAgents'
//   },
//   {
//     "text": "Farm Chop",
//     "image": "assets/nsvgs/dashboard/Icons_Farm_Shop.svg",
//     "background": AppColors.dashFarmShop,
//     "route": '/farmShop'
//   },
//   {
//     "text": "Field Tools",
//     "image": "assets/nsvgs/dashboard/Icons_Field_Tools.svg",
//     "background": AppColors.dashFarmTools,
//     "route": '/farmTools'
//   },
//   {
//     "text": "Farm Sense",
//     "image": "assets/nsvgs/farm_tools/plant_database.svg",
//     "background": AppColors.dashFarmManagement,
//     "route": '/farmSense'
//   },
// ];

const fieldAgentTools = <Map<String, dynamic>>[
  {
    "text": "Soil\nSampling",
    "image": "assets/svgs/shovel.svg",
    "background": AppColors.dashFarmManagement,
    "route": '/soilSampling'
  },
  {
    "text": "Field\nMeasurement",
    "image": "assets/svgs/tape_measure.svg",
    "background": AppColors.dashFarmShop,
    "route": '/fieldMeasurement'
  },
  {
    "text": "Navigator\n& Compass",
    "image": "assets/svgs/compass.svg",
    "background": AppColors.dashFarmTools,
    "route": '/farmNavigator'
  },
  {"text": "Plant\nDatabase", "image": "assets/svgs/seed.svg", "background": Colors.white, "route": '/plantDatabase'},
  {
    "text": "Farm\nManagement",
    "image": "assets/svgs/diary.svg",
    "background": AppColors.dashFarmManagement,
    "route": '/farmManagement'
  },
];

const farmTools = <Map<String, dynamic>>[
  {
    "text": "Field Measurement",
    "image": "assets/nsvgs/farm_tools/ruller.svg",
    "background": Colors.white,
    "route": '/fieldMeasurement'
  },
/*  {
    "text": "Commodity Exchange",
    "image": "assets/svgs/market.svg",
    "background": Colors.white,
    "route": '/commodityPrice'
  },*/
  {
    "text": "Navigator & Compass",
    "image": "assets/nsvgs/farm_tools/navigation.svg",
    "background": Colors.white,
    "route": '/farmNavigator'
  },
  {
    "text": "Plant Database",
    "image": "assets/nsvgs/farm_tools/plant_database.svg",
    "background": Colors.white,
    "route": '/plantDatabase'
  },
  {
    "text": "Farm Management",
    "image": "assets/nsvgs/farm_tools/farm_diary.svg",
    "background": Colors.white,
    "route": '/farmManagement'
  },
];

const farmProbe = <Map<String, dynamic>>[
  {
    "text": "Capture Plant Disease",
    "image": "assets/images/cctv.png",
    "background": Colors.white,
    "route": '/farmProbe'
  },
  {
    "text": "Upload Plant Disease",
    "image": "assets/images/upload_leaf.png",
    "background": Colors.white,
    "route": '/gallery'
  },
  {
    "text": "Search Plant Disease",
    "image": "assets/images/search_leaf.png",
    "background": Colors.white,
    "route": '/search'
  },
  {
    "text": "Plant Disease from URL",
    "image": "assets/images/search_url.png",
    "background": Colors.white,
    "route": '/url'
  },
];

const farmManagementMenu = <Map<String, dynamic>>[
  {"text": "Farm Logs", "image": "assets/images/sun.png", "background": Colors.white, "route": '/farmLogs'},
  {"text": "Farm Assets", "image": "assets/images/tree.png", "background": Colors.white, "route": '/farmAssets'},
];

const farmMeasurements = <Map<String, dynamic>>[
  {"text": "SqMeters", "image": "assets/nsvgs/farm_tools/ruller.svg", "background": Colors.white, "route": '/metres'},
  {"text": "SqFeet", "image": "assets/nsvgs/farm_tools/ruller.svg", "background": Colors.white, "route": '/feet'},
  {"text": "Plots", "image": "assets/nsvgs/farm_tools/ruller.svg", "background": Colors.white, "route": '/plots'},
  {"text": "Acres", "image": "assets/nsvgs/farm_tools/ruller.svg", "background": Colors.white, "route": '/acres'},
  {"text": "Hectares", "image": "assets/nsvgs/farm_tools/ruller.svg", "background": Colors.white, "route": '/hectares'},
];

const editProfile = <Map<String, dynamic>>[
  {
    "text": "Personal Profile",
    "image": "assets/nsvgs/dashboard/profile.svg",
    "background": Colors.white,
    "route": '/editProfile'
  },
  {
    "text": "Change Password",
    "image": "assets/nsvgs/profile/unlock.svg",
    "background": Colors.white,
    "route": '/resetPasswordPage'
  },
  {
    "text": "Change subscription plan",
    "image": "assets/nsvgs/subscription/discount-shape.svg",
    "background": Color(0xFFFB9F00),
    "route": '/subscriptionPage'
  },
];

class CategoryModel {
  final String? name, imageUrl;

  CategoryModel({this.name, this.imageUrl});
}

List<CategoryModel> categories = [
  CategoryModel(name: "Top stories", imageUrl: "agriculture"),
  CategoryModel(name: "Nigeria", imageUrl: "nigeria"),
  CategoryModel(name: "Africa", imageUrl: "africa"),
  CategoryModel(name: "North America", imageUrl: "north-america"),
  CategoryModel(name: "South America", imageUrl: "south-america"),
  CategoryModel(name: "Europe", imageUrl: "europe"),
  CategoryModel(name: "Middle East", imageUrl: "middle-east"),
  CategoryModel(name: "Asia", imageUrl: "asia"),
  CategoryModel(name: "Australia", imageUrl: "australia"),
];

// final List<String> imgList = [
//   'https://firebasestorage.googleapis.com/v0/b/smatcrow.appspot.com/o/assets%2FArtboard%201.jpg?alt=media&token=2b284594-9d6c-47f0-b585-bcb0825f24b4',
//   'https://firebasestorage.googleapis.com/v0/b/smatcrow.appspot.com/o/assets%2FArtboard%202.jpg?alt=media&token=ac703a23-09cb-4679-bb47-8d001bcca6e0',
//   'https://firebasestorage.googleapis.com/v0/b/smatcrow.appspot.com/o/assets%2FArtboard%203.jpg?alt=media&token=1e13a2ed-32a4-4bd5-b040-ae605d6103b7',
//   'https://firebasestorage.googleapis.com/v0/b/smatcrow.appspot.com/o/assets%2FArtboard%204.jpg?alt=media&token=2e0e4b3e-e386-482a-9a72-9d3d226c6fe8'
//
// ];

class ImageListModel {
  final String urlLink;

  ImageListModel({required this.urlLink});
}

final List<ImageListModel> imgList = [
  ImageListModel(
    urlLink:
        'https://firebasestorage.googleapis.com/v0/b/smatcrow.appspot.com/o/assets%2FArtboard%201.jpg?alt=media&token=2b284594-9d6c-47f0-b585-bcb0825f24b4',
  ),
  ImageListModel(
    urlLink:
        'https://firebasestorage.googleapis.com/v0/b/smatcrow.appspot.com/o/assets%2FArtboard%202.jpg?alt=media&token=ac703a23-09cb-4679-bb47-8d001bcca6e0',
  ),
  ImageListModel(
    urlLink:
        'https://firebasestorage.googleapis.com/v0/b/smatcrow.appspot.com/o/assets%2FArtboard%203.jpg?alt=media&token=1e13a2ed-32a4-4bd5-b040-ae605d6103b7',
  ),
  ImageListModel(
    urlLink:
        'https://firebasestorage.googleapis.com/v0/b/smatcrow.appspot.com/o/assets%2FArtboard%204.jpg?alt=media&token=2e0e4b3e-e386-482a-9a72-9d3d226c6fe8',
  ),
];

class AppSplashText {
  AppSplashText();
  static const empower = SplashText(
    text: 'Empowering Farmers With Data',
    style: TextStyle(
      color: Colors.white,
      fontSize: 28.0,
      fontFamily: 'semibold',
    ),
  );

  static const helpFarmers = SplashText(
    text: 'Helping farmers achieve bountiful crop yield',
    style: TextStyle(
      color: AppColors.greyTextLogin,
      fontSize: 15.0,
      fontFamily: 'regular',
      fontWeight: FontWeight.w400,
    ),
  );
}

class AppHeaderText {
  static const weatherMonitoring = HeaderText(
    text: 'Weather Monitoring',
    color: Colors.black,
  );

  static const satelliteImagery = HeaderText(
    text: 'Satellite Imagery',
    color: Colors.black,
  );

  static const droneFlight = HeaderText(
    text: 'Drone Flight',
    color: Colors.black,
  );

  static const iot = HeaderText(
    text: 'IoT',
    color: Colors.black,
  );

  static const aiBacked = HeaderText(
    text: 'AI Backed',
    color: Colors.black,
  );

  static const agronomists = HeaderText(
    text: 'Agronomists',
    color: Colors.black,
  );
}

// class AppPlantLinksItem{
//   static const wikipedia =  PlantLinksItem(
//     message: 'Wikipedia (English)',
//     Url: plantData.enWikipediaUrl,
//   );
// }

class AppSubHeaderText {
  static const weatherMonitor = SubHeaderText(
    text: 'Leveraging on satellites and our AI, we keep an eye on weather'
        ' patterns, forecast and past weather data to let you know '
        'about possible harmful patterns that might affect your'
        ' crops before it happens.',
    color: AppColors.otpPhoneTextGrey,
  );

  static const dailySatelliteImagery = SubHeaderText(
    text: 'Access to daily 3.7-meter resolution satellite imagery, '
        'we support informed crop management decisions, '
        'enabling farmers and agronomists to monitor and '
        'maximize their crop health each season thereby '
        'driving precision digital agriculture at scale.',
    color: AppColors.otpPhoneTextGrey,
  );

  static const droneDataCapture = SubHeaderText(
    text: 'Using our mobile application, we autonomously fly top of range'
        ' fleet of multispectral drones to capture image data which '
        'feeds into our Agtech application platform for processing. '
        'The output is valuable and actionable insights for the farm'
        ' owner and agronomist.',
    color: AppColors.otpPhoneTextGrey,
  );

  static const iotInsight = SubHeaderText(
    text: 'Using our field monitoring Sensor, FarmSense, we gather data'
        ' ranging from soil conditions, moisture level and temperature.'
        ' With the use of our notification engine, farmers get real-time'
        ' notification of information from their farm.',
    color: AppColors.otpPhoneTextGrey,
  );

  static const aiInsight = SubHeaderText(
    text: 'Data using state of the art artificial intelligence, we take all'
        ' the data gathered from IoT, satellite and drones to generate'
        ' insight about your crop health.',
    color: AppColors.otpPhoneTextGrey,
  );

  static const agronomistAccessInsight = SubHeaderText(
    text: 'An accessible agronomist is always on hand to review each case/report'
        ' with a human touch to ensure easy interpretation of '
        'technical report.',
    color: AppColors.otpPhoneTextGrey,
  );
}

class Tabs {
  static const List<Tab> tabs = [
    Tab(text: 'Statistics'),
    Tab(text: 'History'),
    Tab(text: 'Settings'),
  ];
}

enum AuthResultStatus {
  successful,
  emailAlreadyExists,
  wrongPassword,
  invalidEmail,
  userNotFound,
  userDisabled,
  operationNotAllowed,
  tooManyRequests,
  undefined,
}

class CalculateHandleException {
  String calculateAlternativeValues(String route, String stringAsPrecision) {
    final NumberFormat numberFormat = NumberFormat('#,##0.00', 'en_US');
    String calculatedValue = '';
    final convertedValue = double.parse(stringAsPrecision);
    switch (route) {
      case '/metres':
        calculatedValue = numberFormat.format(convertedValue);
        break;
      case '/feet':
        calculatedValue = numberFormat.format(convertedValue * 10.7639);
        break;
      case '/plots':
        calculatedValue = numberFormat.format(convertedValue / 600);
        break;
      case '/acres':
        calculatedValue = numberFormat.format(convertedValue * 0.000247105);
        break;
      case '/hectares':
        calculatedValue = numberFormat.format(convertedValue * 0.0001);
        break;
    }
    return calculatedValue; //;
  }
}

class AuthExceptionHandler {
  static dynamic handleException(e) {
    debugPrint(e.code);
    AuthResultStatus status;
    switch (e.code) {
      case "ERROR_INVALID_EMAIL":
        status = AuthResultStatus.invalidEmail;
        break;
      case "ERROR_WRONG_PASSWORD":
        status = AuthResultStatus.wrongPassword;
        break;
      case "user-not-found":
        status = AuthResultStatus.userNotFound;
        break;
      case "ERROR_USER_DISABLED":
        status = AuthResultStatus.userDisabled;
        break;
      case "ERROR_TOO_MANY_REQUESTS":
        status = AuthResultStatus.tooManyRequests;
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
        status = AuthResultStatus.operationNotAllowed;
        break;
      case "ERROR_EMAIL_ALREADY_IN_USE":
        status = AuthResultStatus.emailAlreadyExists;
        break;
      default:
        status = AuthResultStatus.undefined;
    }
    return status;
  }

  static String generateExceptionMessage(exceptionCode) {
    String errorMessage;
    switch (exceptionCode) {
      case AuthResultStatus.invalidEmail:
        errorMessage = "Your email address appears to be malformed.";
        break;
      case AuthResultStatus.wrongPassword:
        errorMessage = "Your password is wrong.";
        break;
      case AuthResultStatus.userNotFound:
        errorMessage = "User with this email doesn't exist.";
        break;
      case AuthResultStatus.userDisabled:
        errorMessage = "User with this email has been disabled.";
        break;
      case AuthResultStatus.tooManyRequests:
        errorMessage = "Too many requests. Try again later.";
        break;
      case AuthResultStatus.operationNotAllowed:
        errorMessage = "Signing in with Email and Password is not enabled.";
        break;
      case AuthResultStatus.emailAlreadyExists:
        errorMessage = "The email has already been registered. Please login or reset your password.";
        break;
      default:
        errorMessage = "An undefined Error happened.";
    }

    return errorMessage;
  }
}

class SmtpConfig {
  static String SenderEmail = 'support@airsmat.com';
  static String SenderPassword = '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';
  static String SmtpAddress = 'smtp.sendgrid.net';
  static String SmtpUsername = 'apikey';
  static int SmtpPort = 587;
  static List<String> SmtpCCS = ['info@airsmat.com', 'ibikunle18@gmail.com'];
  static List<String> SmtpBCCS = ['support@airsmat.com'];
}

class ContactConfig {
  static String RecipientEmail = 'sales@airsmat.com';
  static String ContactPhone = '07041000987';
}

class AppPermissions {
  const AppPermissions();

  static const String user_field_manager = 'CAN_ACCESS_FARM_MANAGER';
  static const String field_agents = 'agent';
  static const String farm_shop = 'CAN_ACCESS_FARMCHOP';
  static const String smat_sat = 'CAN_ACCESS_SMATSAT';
  static const String smat_star = 'CAN_ACCESS_SMATSTAR';
  static const String smat_ai = 'CAN_ACCESS_SMATAI';
  static const String smat_ml = 'CAN_ACCESS_SMATML';
  static const String smat_mapper = 'CAN_ACCESS_SMATMAPPER';
  static const String site_report = 'CAN_GENERATE_SITE_REPORT';
  static const String farm_sense_devices = 'CAN_ACCESS_FARM_SENSE';
  static const String field_pro_offline = 'CAN_ACCESS_OFFLINE_FIELD_PRO';
  static const String field_pro_in_app = 'CAN_VIEW_IN_APP_FIELD_MEASUREMENT';
  static const String farm_manager_agent = 'CAN_MANAGE_INSTITUTION_FARM';
  static const String farmProbe = "CAN_ACCESS_FARM_PROBE";
}

class OrthoPhotoStatus {
  const OrthoPhotoStatus();

  static const int NONE = 0;
  static const int QUEUED = 10;
  static const int RUNNING = 20;
  static const int FAILED = 30;
  static const int COMPLETED = 40;
  static const int CANCELED = 50;
}

class AssetTypes {
  static const String CHEMICALS = "Chemicals";
  static const String EQUIPMENT = "Equipment";
  static const String SENSOR = "Sensor";
  static const String PLANTS = "Plant";
  static const String SEEDS = "Seed";
  static const String BUILDING = "Building";
  static const String HUMAN = "Human Resource";
}

class LogTypes {
  static const String ACTIVITY = "Activity";
  static const String OBSERVATION = "Observation";
  static const String LABTEST = "Lab Tests";
  static const String PLANTS = "Plant Health (Pest & Diseases)";
  static const String PURCHASE = "Purchase";
}

const shopCategoriesDummy = <Map<String, dynamic>>[
  {"title": "All Categories", "id": 'all'},
  {"title": "Seeds", "id": 'seeds'},
  {"title": "Fertilizer", "id": 'fertilizer'},
  {"title": "Equipments", "id": 'equipments'},
  {"title": "Drones", "id": 'drones'},
  {"title": "Professional Services", "id": 'professionalServices'},
];

const shopCategoriesGroupDummy = <Map<String, dynamic>>[
  {"title": "Top Products", "id": 'top'},
  {"title": "Latest Products", "id": 'latest'},
  {"title": "Affordable Products", "id": 'affordable'},
  {"title": "Top Picks for You", "id": 'foryou'},
];

const shopDummyProductItems = <Map<String, dynamic>>[
  {
    "name": "Remi Yuan",
    "category": "Seed",
    "image":
        "https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'",
    "price": 30000.0,
    "discount": 40.0,
    "isFavourite": true,
    "id": 'all'
  },
  {
    "name": "Remi Yuan",
    "category": "Seed",
    "image":
        "https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'",
    "price": 30000.0,
    "discount": 40.0,
    "isFavourite": true,
    "id": 'all'
  },
  {
    "name": "Remi Yuan",
    "category": "Seed",
    "image":
        "https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'",
    "price": 30000.0,
    "discount": 40.0,
    "isFavourite": true,
    "id": 'all'
  },
  {
    "name": "Remi Yuan",
    "category": "Seed",
    "image":
        "https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'",
    "price": 30000.0,
    "discount": 40.0,
    "isFavourite": true,
    "id": 'all'
  },
  {
    "name": "Remi Yuan",
    "category": "Seed",
    "image":
        "https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'",
    "price": 30000.0,
    "discount": 40.0,
    "isFavourite": true,
    "id": 'all'
  },
  {
    "name": "Remi Yuan",
    "category": "Seed",
    "image":
        "https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'",
    "price": 30000.0,
    "discount": 40.0,
    "isFavourite": true,
    "id": 'all'
  },
  {
    "name": "Remi Yuan",
    "category": "Seed",
    "image":
        "https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'",
    "price": 30000.0,
    "discount": 40.0,
    "isFavourite": true,
    "id": 'all'
  },
];
