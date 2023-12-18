import 'package:firebase_auth/firebase_auth.dart';
import 'package:smat_crow/features/domain/repository/firebase_repository.dart';

import '../../../entities/user/user_entity.dart';

class SignInUserUseCase {
  final FirebaseRepository repository;

  SignInUserUseCase({
    required this.repository,
  });

  Future<UserCredential?> call(UserEntity userEntity) {
    return repository.signInUser(userEntity);
  }
}
