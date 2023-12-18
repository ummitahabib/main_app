import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:smat_crow/features/domain/entities/user/user_entity.dart';
import 'package:smat_crow/features/domain/usecases/firebase_usecases/user/get_single_user_usecase.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/constants.dart';

enum GetSingleUserProviderStatus {
  initial,
  loading,
  loaded,
  failure,
}

class GetSingleUserProvider extends ChangeNotifier {
  final GetSingleUserUseCase getSingleUserUseCase;

  GetSingleUserProvider({
    required this.getSingleUserUseCase,
  });

  GetSingleUserProviderStatus _status = GetSingleUserProviderStatus.initial;
  GetSingleUserProviderStatus get status => _status;
  UserEntity? _user;
  UserEntity? get user => _user;

  bool isLoading = false;

  Future<UserEntity?> getSingleUser() async {
    _status = GetSingleUserProviderStatus.loading;
    notifyListeners();

    try {
      final uid = await Pandora().getFromSharedPreferences(Const.uid);
      final users = await getSingleUserUseCase.call(uid).first;
      _user = users.first;
      _status = GetSingleUserProviderStatus.loaded;
      notifyListeners();
      return _user;
    } on SocketException catch (_) {
      _status = GetSingleUserProviderStatus.failure;
      notifyListeners();
      return null;
    } catch (_) {
      _status = GetSingleUserProviderStatus.failure;
      notifyListeners();
      return null;
    }
  }
}
