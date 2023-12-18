// ignore_for_file: constant_identifier_names

import 'dart:developer';
import 'dart:io';
import 'package:beamer/beamer.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart' as sender;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gpx/gpx.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as loc;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:one_context/one_context.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smat_crow/network/crow/models/email_operations.dart';
import 'package:smat_crow/screens/farmmanager/widgets/bottom_sheet_header.dart';
import 'package:smat_crow/screens/farmmanager/widgets/category_chip.dart';
import 'package:smat_crow/utils/colors.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils/session.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../network/crow/models/request/mailer/send_mail_request.dart';
import '../screens/widgets/header_text.dart';

class Pandora {
  void showToast(String message, BuildContext context, String messageType) {
    switch (messageType) {
      case "SUCCESS":
        displayToast(message, Colors.green);
        break;
      case "FAILED":
        displayToast(message, Colors.red);
        break;
      case "WARNING":
        displayToast(message, Colors.orangeAccent);

        break;
      case "INFO":
        displayToast(message, Colors.black54);
        break;
    }
  }

  String showTimeAgo(DateTime timedata) {
    final date = timeago.format(timedata);

    return date;
  }

  void clearUserData() {
    Session.FirebaseId = "";
    Session.userDetailsResponse = null;
    Session.SessionToken = "";
  }

  String camelCaseSentence(String str) {
    return str.toLowerCase().split(' ').map((word) {
      final String leftText = (word.length > 1) ? word.substring(1, word.length) : emptyString;
      return word[0].toUpperCase() + leftText;
    }).join(' ');
  }

  String epochToDate(int epoch) {
    return DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(epoch));
  }

  void loadDialogs(String title, Widget widget, double height) {
    OneContext().showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      builder: (context) => Container(
        alignment: Alignment.topCenter,
        height: height,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.inactiveTabTextColor.withOpacity(.2),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 30,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CategoryChip(
                      Icons.close,
                      'Close',
                      () {
                        logAPPButtonClicksEvent('CLOSE_STAR_ANALYSIS_CLICKED');
                        Navigator.pop(context);
                      },
                      Colors.redAccent[50]!,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                BottomSheetHeaderText(text: title),
                widget,
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Snackbar Renderer
  void displayToast(String message, Color color) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: color,
      timeInSecForIosWeb: 5,
      fontSize: SpacingConstants.font16,
      gravity: ToastGravity.TOP,
    );
  }

  //Internet Connection manager
  Future<bool> hasInternet() async {
    bool hasInternet = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasInternet = true;
      }
    } on SocketException catch (_) {
      hasInternet = false;
    }
    return hasInternet;
  }

  String moneyFormat(double price) {
    final formatCurrency = NumberFormat.currency(decimalDigits: 3, name: "", locale: "en_ZA");
    if (price > 1000) return formatCurrency.format(price);
    return price.toString();
  }

  String newMoneyFormat(double price) {
    final MoneyFormatter fmf = MoneyFormatter(amount: price);

    return fmf.output.nonSymbol;
  }

  String moneyFormatNew(String price) {
    if (price.length > 2) {
      var value = price;
      value = value.replaceAll(RegExp(r'\D'), emptyString);
      value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
      return value;
    }
    return price;
  }

  static String dateFormat(DateTime date) {
    var processedDate = DateTimeFormat.format(date, format: DateTimeFormats.americanAbbr);
    return processedDate = processedDate.substring(0, processedDate.length - 8);
  }

  Future<bool> saveToSharedPreferences(String key, String value) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setString(key, value);
  }

  Future<String> getFromSharedPreferences(String key) async {
    final pref = await SharedPreferences.getInstance();
    final value = pref.getString(key) ?? emptyString;
    return value;
  }

  String removeAllHtmlTags(String htmlText) {
    final RegExp exp = RegExp("<[^>]*>", multiLine: true);

    return htmlText.replaceAll(exp, emptyString);
  }

  static String reverse(String s) {
    if (s.isNotEmpty) {
      return s.split(emptyString).reversed.join();
    }
    return s;
  }

  static String getStringsAfter(String s, int subString) {
    if (s.isNotEmpty) {
      return s.substring(subString);
    }
    return s;
  }

  static String getEmailUserName(String s) {
    if (s.isNotEmpty) {
      if (s.substring(0, s.indexOf('@')).replaceAll(".", "").toUpperCase() != "INFO") {
        return s.substring(0, s.indexOf('@')).replaceAll(".", "");
      } else {
        final String val = s.substring(s.indexOf('@') + 1);
        return val.substring(0, val.indexOf('.')).replaceAll(".", "");
      }
    }
    return s;
  }

  Future delayforSeconds(int seconds) {
    return Future.delayed(Duration(milliseconds: seconds * 1000)).then((onValue) => true);
  }

  void reRouteUser(BuildContext context, String route, Object? args) {
    if (kIsWeb) {
      Beamer.of(context).beamToNamed(route, data: args, routeState: args);
    } else {
      Navigator.of(context).pushNamed(route, arguments: args);
    }
  }

  void reRouteUserPop(BuildContext context, String route, Object? args) {
    if (kIsWeb) {
      Beamer.of(context).beamToReplacementNamed(route, data: args, routeState: args);
    } else {
      Navigator.of(context).pushReplacementNamed(route, arguments: args);
    }
  }

  void reRouteUserPopCurrent(BuildContext context, String route, Object? args) {
    Navigator.of(context).popAndPushNamed(route, arguments: args);
  }

  static final formatCurrency = NumberFormat.currency(symbol: "");

  String capitalizeFirstLetter(String s) => (s.isNotEmpty) ? '${s[0].toUpperCase()}${s.substring(1)}' : s;

  Future<String> get _getDirPath async {
    final dir = await getTemporaryDirectory();
    return dir.path;
  }

  Future<void> _writeData(String name, String kmlData, String type) async {
    final dirPath = await _getDirPath;

    final myFile = File('$dirPath/${name.replaceAll(" ", "-")}-${type.replaceAll(" ", "-")}.kml');

    await myFile.writeAsString(kmlData).whenComplete(() {
      // sendEmailWithFile(name, myFile);
      log(myFile.path);
      sendEmailWithAirSmat(name, myFile);
    });
  }

  bool isValidEmail(String email) {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(email);
  }

  bool isValidPhoneNumber(String phone) {
    return RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(phone);
  }

  Future<void> sendEmailWithFile(String name, File attachment) async {
    final String username = SmtpConfig.SenderEmail;
    final String password = SmtpConfig.SenderPassword;
    final smtpServer = SmtpServer(
      SmtpConfig.SmtpAddress,
      //allowInsecure: false,
      //ignoreBadCertificate: true,
      // ssl: true,
      name: SmtpConfig.SmtpUsername,
      password: password,
      port: SmtpConfig.SmtpPort,
      username: SmtpConfig.SmtpUsername,
    );

    final String userName = Session.userName;
    log(userName);
    log(Session.userEmail);
    final message = Message()
      ..from = Address(username, 'AirSmat')
      ..recipients.add(Session.userEmail)
      ..ccRecipients.addAll(SmtpConfig.SmtpCCS)
      ..bccRecipients.addAll(SmtpConfig.SmtpBCCS)
      ..subject = 'Site Map for $name Generated at ${DateTime.now()}'
      ..text =
          'Dear $userName ,\n\nThis is to confirm that your request to export your Map for $name was successful.\nPlease, find attached .kml file import into your mapping application to view your map\n\n Site Name: $name\nRequest Date: ${DateTime.now()}\n\nIf you require further assistance, please reach out us via email at support@airsmat.com\n\nThank you for your continued patronage\n\n\n Sincerely,\nAirSmat,\n'
      ..attachments = [FileAttachment(attachment)];

    try {
      final result = await send(message, smtpServer);
      log(result.mail.toString());
    } on MailerException catch (e) {
      log(e.toString());
      rethrow;
    }

    final connection = PersistentConnection(smtpServer);
    await connection.send(message);
    await connection.close();
  }

  Future<bool> sendEmailWithAirSmat(String name, File myFile) async {
    log(Session.userEmail);
    final response = await sendMail(
      SendMailRequest(
        body:
            'Dear ${Session.userName} ,\n\nThis is to confirm that your request to export your Site Map for $name was successful.\nPlease, find attached .kml file import into your mapping application to view your sector map\n\nSite Name: $name\nRequest Date: ${DateTime.now()}\n\nIf you require further assistance, please reach out us via email at support@airsmat.com\n\nThank you for your continued patronage\n\n\n Sincerely,\nAirSmat,\n',
        cc: SmtpConfig.SmtpCCS,
        from: 'AirSmat',
        subject: 'Site Map for $name Generated at ${DateTime.now()}',
        to: Session.userEmail,
      ),
      myFile,
    );

    return response;
  }

  Future<void> requestLocation() async {
    final loc.Location location = loc.Location();

    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;
    //   loc.LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        return;
      }
    }

    //  locationData = await location.getLocation();
  }

  bool isValidPassword(String password) {
    return password.length >= 6;
  }

  void generateKML(
    String name,
    List<List<List<double>>> sectorCoordinates,
    String type,
  ) {
    final gpx = Gpx();
    gpx.creator = "smat-crow-mobile:ibikunle-adeoluwa";
    for (int i = 0; i < sectorCoordinates[0].length; i++) {
      gpx.wpts.add(
        Wpt(
          lat: sectorCoordinates[0][i][0],
          lon: sectorCoordinates[0][i][1],
          name: 'Position $i',
        ),
      );
    }
    GpxWriter().asString(gpx, pretty: true);

    final kmlString = KmlWriter().asString(gpx, pretty: true);

    _writeData(name, kmlString, type).whenComplete(() {
      OneContext().showSnackBar(
        builder: (_) => const SnackBar(
          content: Text('Map Exported to Email'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  void generateKMLForPolygon(String name, List<LatLng> polygon, String type) {
    final gpx = Gpx();
    gpx.creator = "smat-crow-mobile:ibikunle-adeoluwa";
    for (int i = 0; i < polygon.length; i++) {
      gpx.wpts.add(
        Wpt(
          lat: polygon[i].latitude,
          lon: polygon[i].longitude,
          name: 'Position $i',
        ),
      );
    }
    GpxWriter().asString(gpx, pretty: true);

    final kmlString = KmlWriter().asString(gpx, pretty: true);

    _writeData(name, kmlString, type).whenComplete(() {
      showToast(
        mapExportedToEmail,
        OneContext().context!,
        MessageTypes.SUCCESS.toString().split('.').last,
      );
    });
  }

  Future<File> downloadFile(String url, String filename) async {
    final httpClient = HttpClient();
    final request = await httpClient.getUrl(Uri.parse(url));
    final response = await request.close();
    final bytes = await consolidateHttpClientResponseBytes(response);
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final File file = File('$dir/$filename');
    await file.writeAsBytes(bytes);

    await OpenFilex.open(file.path);
    return file;
  }

  void logAPIEvent(String action, String endpoint, String status, String error) {
    log("Error: $error::::::::::::::::::API: $endpoint");
    GetIt.I<FirebaseAnalytics>().logEvent(
      name: USER_NAME,
      parameters: <String, dynamic>{
        'device_name': DeviceName,
        'action': action,
        'endpoint': endpoint,
        'status': status,
        'error': error
      },
    );
  }

  void logAPPButtonClicksEvent(String buttonName) {
    //var time = DateTime.now();
    GetIt.I<FirebaseAnalytics>().logEvent(
      name: USER_NAME,
      parameters: <String, dynamic>{
        'device_name': DeviceName,
        'action': buttonName,
        //'time': time,
      },
    );

    GetIt.I<FirebaseAnalytics>().logEvent(
      name: buttonName,
      parameters: <String, dynamic>{
        'device_name': DeviceName,
        //'time': DateTime.now(),
      },
    );
  }

  Future<void> composeEmail() async {
    final email = sender.Email(
      body: 'Dear Team, \n\n',
      subject: 'INQUIRY ABOUT AIRSMAT',
      recipients: [ContactConfig.RecipientEmail],
      cc: SmtpConfig.SmtpCCS,
      bcc: SmtpConfig.SmtpBCCS,
    );

    await sender.FlutterEmailSender.send(email);
  }
}

Future<dynamic> displayModalWithChild(
  Widget child,
  String header,
  BuildContext context,
) {
  return showModalBottomSheet(
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    clipBehavior: Clip.antiAliasWithSaveLayer,
    context: context,
    builder: (context) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  HeaderText(
                    text: header,
                    color: Colors.black,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.closeButtonGrey,
                      size: 20,
                    ),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(
                  height: 1.0,
                ),
              ),
              child,
            ],
          ),
        ),
      );
    },
  );
}

enum MessageTypes { SUCCESS, FAILED, WARNING, INFO }
