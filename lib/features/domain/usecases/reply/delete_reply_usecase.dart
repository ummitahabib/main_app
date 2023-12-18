import 'package:smat_crow/features/domain/entities/reply/reply_entity.dart';
import 'package:smat_crow/features/domain/repository/firebase_repository.dart';

class DeleteReplyUseCase {
  final FirebaseRepository repository;

  DeleteReplyUseCase({required this.repository});

  Future<void> call(ReplyEntity reply) {
    return repository.deleteReply(reply);
  }
}
