import 'package:smat_crow/features/domain/entities/comment/comment_entity.dart';
import 'package:smat_crow/features/domain/repository/firebase_repository.dart';

class DeleteCommentUseCase {
  final FirebaseRepository repository;

  DeleteCommentUseCase({required this.repository});

  Future<void> call(CommentEntity comment) {
    return repository.deleteComment(comment);
  }
}
