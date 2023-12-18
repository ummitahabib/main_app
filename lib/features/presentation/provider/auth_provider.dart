import 'package:flutter/material.dart';
import 'package:smat_crow/features/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:smat_crow/features/domain/usecases/firebase_usecases/user/is_sign_in_usecase.dart';
import 'package:smat_crow/features/domain/usecases/firebase_usecases/user/sign_out_usecase.dart';
import 'package:smat_crow/utils2/app_helper.dart';

class AuthProvider extends ChangeNotifier {
  final SignOutUseCase _signOutUseCase;
  final IsSignInUseCase _isSignInUseCase;
  final GetCurrentUidUseCase _getCurrentUidUseCase;

  AuthProvider({
    required SignOutUseCase signOutUseCase,
    required IsSignInUseCase isSignInUseCase,
    required GetCurrentUidUseCase getCurrentUidUseCase,
  })  : _signOutUseCase = signOutUseCase,
        _isSignInUseCase = isSignInUseCase,
        _getCurrentUidUseCase = getCurrentUidUseCase;

  String? _uid;
  String? get uid => _uid;

  final ApplicationHelpers appHelpers = ApplicationHelpers();

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  Future<bool> initializeApp() async {
    try {
      final isSignedIn = await _isSignInUseCase.call();
      _isAuthenticated = isSignedIn;
      if (isSignedIn) {
        _uid = await _getCurrentUidUseCase.call();
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      _handleError('ERROR_APP_STARTED: $e');
      debugPrint('Error in initializeApp: $e');
    }
    return false;
  }

  Future<void> loggedIn() async {
    try {
      _uid = await _getCurrentUidUseCase.call();
      _isAuthenticated = true;
      notifyListeners();
    } catch (e) {
      _handleError('ERROR_LOGGED_IN: $e');
      debugPrint('Error in loggedIn: $e');
    }
  }

  Future<void> loggedOut() async {
    try {
      await _signOutUseCase.call();
      _uid = null;
      _isAuthenticated = false;
      notifyListeners();
    } catch (e) {
      _handleError('ERROR_LOGGED_OUT: $e');
      debugPrint('Error in loggedOut: $e');
    }
  }

  void _handleError(String error) {
    appHelpers.trackAPIEvent('LOGIN', 'LOGIN', 'FAILED', error);
    appHelpers.trackButtonAndDeviceEvent('ERROR_BUTTON_CLICKED');
  }
}
