import 'package:smat_crow/features/domain/entities/user/user_entity.dart';

import 'package:smat_crow/features/domain/repository/firebase_repository.dart';

// class GetSingleUserUseCase {
//   final FirebaseRepository repository;

//   GetSingleUserUseCase({required this.repository});

//   Future<UserEntity?> call(
//     String uid,
//   ) {
//     return repository.getSingleUser(uid);
//   }
// }

class GetSingleUserUseCase {
  final FirebaseRepository repository;

  GetSingleUserUseCase({required this.repository});

  Stream<List<UserEntity>> call(String uid) {
    return repository.getSingleUser(uid);
  }
}
