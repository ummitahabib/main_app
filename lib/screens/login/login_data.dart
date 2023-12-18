import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../network/crow/crow_authentication.dart';
import '../../pandora/pandora.dart';
import '../../utils/constants.dart';
import '../../utils/session.dart';
import '../../utils/strings.dart';

class LoginData extends ChangeNotifier {
  final Pandora pandora = Pandora();
  TextEditingController emailAddress = TextEditingController();
  TextEditingController password = TextEditingController();
  String email = '', pass = '', field_pro_offline = '';
  final bool passwordVisible = false;

  Future<bool> waitForPrefLoad() async {
    bool value = false;
    await pandora.getFromSharedPreferences('field_pro_offline').then((value) {
      debugPrint(value);
      field_pro_offline = value;
      notifyListeners();
    });
    await pandora.getFromSharedPreferences('email').then((value) {
      emailAddress.text = value;
      Email = value;
      email = value;
    });
    await pandora.getFromSharedPreferences('password').then((value) {
      password.text = value;
      pass = value;
    }).whenComplete(() {
      value = true;
    });
    return value;
  }

  bool validateLogInCredentials(String emailAddress, String password) {
    return (password.isEmpty || emailAddress.isEmpty) ? false : true;
  }

  void logInUser(
    String emailAddress,
    String password,
    String route,
    String args,
    BuildContext context,
  ) {
    pandora.saveToSharedPreferences('email', emailAddress);
    pandora.saveToSharedPreferences('password', password);
    USER_NAME = Pandora.getEmailUserName(emailAddress);
    pandora.logAPPButtonClicksEvent('LOGIN_BUTTON_CLICKED');
    Provider.of<CrowAuthentication>(context, listen: false)
        .loginIntoAccount(context, emailAddress, password)
        .whenComplete(() {
      debugPrint(Session.FirebaseId);
      debugPrint(Session.SessionToken);
      resetPreviousUserSession();
      pandora.reRouteUser(context, route, args);
    });
  }

  void validateLoginRouter(
    LoginRouterArgs loginRouter,
    String email,
    String pass,
    BuildContext context,
  ) {
    debugPrint('reroute ID: ${loginRouter.rerouteId}');

    if (loginRouter.autoLogin && loginRouter.canReroute) {
      if (pass.isNotEmpty) {
        debugPrint('Email: $email');

        debugPrint('reroute ID: ${loginRouter.rerouteId}');
        logInUser(
          email,
          pass,
          loginRouter.reroutePage,
          loginRouter.rerouteId,
          context,
        );
      } else {
        Fluttertoast.showToast(
          msg: Errors.signInError,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
        );
      }
    }
  }

  void resetPreviousUserSession() {
    pandora.saveToSharedPreferences('field_pro_offline', 'N');
    pandora.saveToSharedPreferences('field_pro_in_app', 'N');
  }
}
