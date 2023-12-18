import 'package:smat_crow/features/domain/repository/firebase_repository.dart';

import '../../../entities/user/user_entity.dart';

class GetUsersUseCase {
  final FirebaseRepository repository;

  GetUsersUseCase({required this.repository});

  Stream<List<UserEntity>> call(UserEntity userEntity) {
    return repository.getUsers(userEntity);
  }
}
