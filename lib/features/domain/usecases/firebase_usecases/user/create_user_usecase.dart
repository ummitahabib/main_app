import 'package:smat_crow/features/domain/repository/firebase_repository.dart';

import '../../../entities/user/user_entity.dart';

class CreateUserUseCase {
  final FirebaseRepository repository;

  CreateUserUseCase({required this.repository});

  Future<void> call(UserEntity user, String uid) {
    return repository.createUser(user, uid);
  }
}
