import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils/session.dart';

import 'firebase.dart';

class Authentication with ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  AuthResultStatus? _status;
  final Pandora _pandora = Pandora();

  String userUId = '';

  String get getUserUid => userUId;

  Future loginIntoAccount(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      final UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      final User user = userCredential.user!;
      userUId = user.uid;
      Session.FirebaseId = userUId;
      _pandora.logAPIEvent('FIREBASE_LOGIN', 'FIREBASE_AUTH', 'SUCCESS', '');
      notifyListeners();
    } catch (e) {
      debugPrint('Exception @createAccount: $e');
      _pandora.logAPIEvent('FIREBASE_LOGIN', 'FIREBASE_AUTH', 'FAILED', '$e');
      _status = AuthExceptionHandler.handleException(e);
      if (_status == AuthResultStatus.userNotFound) {
        await OneContext().showSnackBar(
          builder: (_) => const SnackBar(
            content: Text('Incorrect Login Details'),
            backgroundColor: Colors.red,
          ),
        );
        debugPrint('$_status Attempting to create account');
        await createAccount(email, password).whenComplete(() {
          Provider.of<FirebaseOperations>(context, listen: false).createUserCollection(
            context,
            {'useruid': userUId, 'useremail': email, 'username': 'Anonymous', 'userimage': ''},
          ).whenComplete(
            () => Provider.of<FirebaseOperations>(context, listen: false).updateUserField(
              context,
              {'username': Pandora.getEmailUserName(email)},
            ),
          );
        });
      }
    }
  }

  Future createAccount(String email, String password) async {
    final UserCredential userCredential =
        await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    final User user = userCredential.user!;
    userUId = user.uid;
    Session.FirebaseId = userUId;
    debugPrint('Created Account Uid=> $userUId');
    _pandora.logAPIEvent(
      'FIREBASE_CREATE_ACCOUNT',
      'FIREBASE_AUTH',
      'SUCCESS',
      '',
    );
    notifyListeners();
  }

  Future logoutViaEmail() {
    return firebaseAuth.signOut();
  }

  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleSIgnInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSIgnInAccount!.authentication;
    final AuthCredential authCredential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential userCredential = await firebaseAuth.signInWithCredential(authCredential);

    final User user = userCredential.user!;

    userUId = user.uid;
    debugPrint('Google User Uid=> $userUId');
    notifyListeners();
  }

  Future signOutWithGoogle() async {
    return googleSignIn.signOut();
  }
}
