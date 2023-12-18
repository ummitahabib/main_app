// ignore_for_file: non_constant_identifier_names

class Errors {
  const Errors();

  static const String loginValidationError = 'Username or Password cannot be empty';
  static const String missingFieldsError = 'Fill all fields to proceed';
  static const String signInError = 'You need to sign in to view notifications';
  static const String polygonError = 'Site Data Incomplete';
  static const String sectorPolygonError = 'Sector coord Cannot be less than 4';
  static const String inCorrectPointError = 'Starting point must be same as the ending point';
  static const String sampleError = 'Sample Data Incomplete';
  static const String sectorError = 'Operation not Permitted';
  static const String missingEmailsError = 'Enter your Email to proceed';
  static const String passwordNotMatch = 'Password do not match';
  static const String passwordNotEmpty = 'Password cannot be Empty';
  static const String loginError = 'Authentication Failed';
  static const String unforseenException = 'Something went wrong';
  static const String invalidEmail = 'Email is Invalid';
  static const String invalidPhoneNumber = 'Phone Number is Invalid';
  static const String connectionError = 'Connection Error, Please check your Internet';

  static const String searchFieldError = 'Search field cannot be empty';
  static const String subsPlanError = "Error getting subscription plans";

  static const String unableloadsoil = 'Unable to load soil samples';
  static const String unableRunAsset = 'Unable to Fetch Asset Types';
}

class Success {
  const Success();

  static const String loginSuccess = 'Login Successful';
  static const String newAccount = 'Account Creation Successful';
}

class SubscriptionPlanString {
  const SubscriptionPlanString();
  static const String subscriptionTitle = 'Subscription';
  static const String noSubscriptionMessage = "You don’t have any subscription yet";
  static const String getPlanButtonLabel = "Get a Plan Now";
  static const String addSubscription = 'Add Subscription';
  // static const String
}

String Proceed = "Do you want to proceed with the action";
String Cancel = "Yes, Cancel Subscription";
String noCancel = "No, Cancel";
String notReversable = "NB: This is not reversible";
String noOfSubscription = "Number of Subscriptions";
String opps = "Oops!";
String canExpire = "Can Expire";
String canNotExpire = "Cannot Expire";
String purchaseDate = "Purchase Date";
String unAvailabeSite = "No Sites Available";
String createTask = 'Create new task';
String dateFormat = 'yyyy-MM-dd';
String completed = "Completed";
String weeks = 'Weeks';
String unknown = 'Unknown';
String noMission = 'You do not have any missions';
String assetNotCreated = 'No Asset Types Created';
String logNotCreated = 'No Log Types Created';
String unableToFetchLog = 'Unable to Fetch Log Types';
String unableFetchAssetStatus = "Unable to Fetch Asset Status";
String assetStatusNotCreated = 'No Asset Status Created';
String unableToFetchFlag = "Unable to Fetch Flags";
String defaultImage =
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80';
String noFlag = 'No Flags Created';

//Active

String Active = "Active";
