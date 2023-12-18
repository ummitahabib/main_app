import 'package:smat_crow/features/domain/entities/reply/reply_entity.dart';
import 'package:smat_crow/features/domain/repository/firebase_repository.dart';

class CreateReplyUseCase {
  final FirebaseRepository repository;

  CreateReplyUseCase({required this.repository});

  Future<void> call(ReplyEntity reply) {
    return repository.createReply(reply);
  }
}
