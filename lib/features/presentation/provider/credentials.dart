// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/features/data/models/register_request.dart';
import 'package:smat_crow/features/data/repository/authentication_repository.dart';
import 'package:smat_crow/features/domain/entities/user/user_entity.dart';
import 'package:smat_crow/features/domain/usecases/firebase_usecases/user/sign_in_user_usecase.dart';
import 'package:smat_crow/features/domain/usecases/firebase_usecases/user/sign_up_user_usecase.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/utils2/AppHelper.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

enum CredentialStatus { initial, loading, success, failure }

class CredentialProvider extends ChangeNotifier {
  final SignInUserUseCase? signInUserUseCase;
  final SignUpUseCase? signUpUseCase;

  CredentialProvider({
    this.signInUserUseCase,
    this.signUpUseCase,
    required AuthenticationRepository authenticationRepository,
  }) : _authenticationRepository = authenticationRepository;

  CredentialStatus _status = CredentialStatus.initial;

  CredentialStatus get status => _status;

  final AuthenticationRepository _authenticationRepository;
  final appHelper = ApplicationHelpers();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();

  bool isLoading = false;

  void showSuccessSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void clearInputFields() {
    emailController.clear();
    passwordController.clear();
    firstnameController.clear();
    lastnameController.clear();
  }

  Future<UserCredential?> signInUser({
    required String email,
    required String password,
  }) async {
    _setStatus(CredentialStatus.loading);
    try {
      final result = await signInUserUseCase!.call(UserEntity(email: email, password: password));
      _setStatus(CredentialStatus.success);
      return result;
    } on FirebaseException catch (e) {
      if (e.code == firebaseUserNotFound) {
        return null;
      }
      _setStatus(CredentialStatus.failure);
    } catch (_) {
      _setStatus(CredentialStatus.failure);
    }
    return null;
  }

  Future<CredentialStatus> signUpUser({
    required UserEntity user,
  }) async {
    _setStatus(CredentialStatus.loading);
    try {
      await signUpUseCase!.call(user);
      _setStatus(CredentialStatus.success);
      return CredentialStatus.success;
    } on FirebaseException catch (_) {
      snackBarMsg(_.toString());
      _setStatus(CredentialStatus.failure);
      return CredentialStatus.failure;
    } catch (_) {
      snackBarMsg(_.toString());
      _setStatus(CredentialStatus.failure);
      return CredentialStatus.failure;
    }
  }

  void _setStatus(CredentialStatus newStatus) {
    _status = newStatus;
    notifyListeners();
  }

  Future<void> _navigateToVerificationPage(BuildContext context) async {
    await Future.delayed(const Duration(seconds: SpacingConstants.int3));
    appHelper.reRouteUser(
      context,
      ConfigRoute.verifyEmailPage,
      emptyString,
    );
  }

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: SpacingConstants.int3),
      ),
    );
  }

  Future<void> createUserAccount(BuildContext context) async {
    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      final firstName = firstnameController.text.trim();
      final lastName = lastnameController.text.trim();

      final apiCreationResponse = await _authenticationRepository.registerUser(
        RegisterRequest(
          email: email,
          firstName: firstName,
          lastName: lastName,
          password: password,
        ),
      );

      if (apiCreationResponse.hasError()) {
        showErrorSnackbar(
          context,
          apiCreationResponse.error!.message,
        );
      } else {
        await _navigateToVerificationPage(context);
      }
    } catch (e) {
      showErrorSnackbar(
        context,
        "Failed to create account. Please try again.",
      );
    }
  }

  Future<void> navigateToVerificationPage(BuildContext context) async {
    appHelper.reRouteUser(
      context,
      ConfigRoute.verifyEmailPage,
      emptyString,
    );
  }

  Future<void> navigateToLogin(BuildContext context) async {
    appHelper.reRouteUser(
      context,
      ConfigRoute.login,
      emptyString,
    );
  }
}
