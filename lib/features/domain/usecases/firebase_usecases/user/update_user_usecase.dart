import 'package:smat_crow/features/domain/entities/user/user_entity.dart';

import 'package:smat_crow/features/domain/repository/firebase_repository.dart';

class UpdateUserUseCase {
  final FirebaseRepository repository;

  UpdateUserUseCase({required this.repository});

  Future<void> call(UserEntity userEntity) {
    return repository.updateUser(userEntity);
  }
}
