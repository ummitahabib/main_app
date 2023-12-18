import 'package:smat_crow/features/domain/entities/posts/post_entity.dart';
import 'package:smat_crow/features/domain/repository/firebase_repository.dart';

class UpdatePostUseCase {
  final FirebaseRepository repository;

  UpdatePostUseCase({required this.repository});

  Future<void> call(PostEntity post) {
    return repository.updatePost(post);
  }
}
