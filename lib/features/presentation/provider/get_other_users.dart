import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:smat_crow/features/domain/entities/user/user_entity.dart';
import 'package:smat_crow/features/domain/usecases/firebase_usecases/user/get_single_other_users_usecase.dart';

enum GetSingleOtherUserProviderStatus { initial, loading, loaded, failure }

class GetSingleOtherUserProvider extends ChangeNotifier {
  final GetSingleOtherUserUseCase? getSingleOtherUserUseCase;

  GetSingleOtherUserProvider({this.getSingleOtherUserUseCase});

  GetSingleOtherUserProviderStatus _status =
      GetSingleOtherUserProviderStatus.initial;
  GetSingleOtherUserProviderStatus get status => _status;

  UserEntity? _otherUser;
  UserEntity? get otherUser => _otherUser;

  Future<void> getSingleOtherUser({required String otherUid}) async {
    _status = GetSingleOtherUserProviderStatus.loading;
    notifyListeners();

    try {
      final streamResponse = getSingleOtherUserUseCase!.call(otherUid);
      streamResponse.listen((users) {
        _otherUser = users.first;
        _status = GetSingleOtherUserProviderStatus.loaded;
        notifyListeners();
      });
    } on FirebaseException catch (_) {
      _status = GetSingleOtherUserProviderStatus.failure;
      notifyListeners();
    } catch (_) {
      _status = GetSingleOtherUserProviderStatus.failure;
      notifyListeners();
    }
  }
}
