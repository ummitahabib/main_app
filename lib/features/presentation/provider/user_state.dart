// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/domain/entities/user/user_entity.dart';
import 'package:smat_crow/features/domain/usecases/firebase_usecases/user/follow_unfollow_user_usecase.dart';
import 'package:smat_crow/features/domain/usecases/firebase_usecases/user/get_users_usecase.dart';
import 'package:smat_crow/features/domain/usecases/firebase_usecases/user/update_user_usecase.dart';
import 'package:smat_crow/utils2/service_locator.dart';

enum UserProviderStatus { initial, loading, loaded, failure }

final userStateProvider = ChangeNotifierProvider<UserProvider>((ref) {
  return UserProvider(
    updateUserUseCase: locator.call(),
    getUsersUseCase: locator.call(),
    followUnFollowUseCase: locator.call(),
  );
});

class UserProvider extends ChangeNotifier {
  final UpdateUserUseCase updateUserUseCase;
  final GetUsersUseCase getUsersUseCase;
  final FollowUnFollowUseCase followUnFollowUseCase;

  UserProvider({
    required this.updateUserUseCase,
    required this.getUsersUseCase,
    required this.followUnFollowUseCase,
  });

  UserProviderStatus _status = UserProviderStatus.initial;
  UserProviderStatus get status => _status;

  List<UserEntity> _users = [];
  List<UserEntity> get users => _users;

  void _setStatus(UserProviderStatus newStatus) {
    _status = newStatus;
    notifyListeners();
  }

  final bool _isLoading = false;
  bool get isLoading => _isLoading;

  void getUsers({required UserEntity user}) {
    _setStatus(UserProviderStatus.loading);
    try {
      final streamResponse = getUsersUseCase.call(user);

      streamResponse.listen((users) {
        _users = users;
        _setStatus(UserProviderStatus.loaded);
      });
    } on SocketException catch (e) {
      debugPrint("SocketException: $e");
      _setStatus(UserProviderStatus.failure);
    } catch (e) {
      debugPrint("Error: $e");
      _setStatus(UserProviderStatus.failure);
    }
  }

  void updateUser({required UserEntity user}) {
    try {
      updateUserUseCase.call(user);
    } on SocketException catch (e) {
      debugPrint("SocketException: $e");
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  void followUnFollowUser({required UserEntity user}) {
    try {
      followUnFollowUseCase.call(user);
    } on SocketException catch (e) {
      debugPrint("SocketException: $e");
    } catch (e) {
      debugPrint("Error1: $e");
    }
  }
}
