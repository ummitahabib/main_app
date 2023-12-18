import 'package:smat_crow/features/domain/entities/reply/reply_entity.dart';
import 'package:smat_crow/features/domain/repository/firebase_repository.dart';

class ReadReplysUseCase {
  final FirebaseRepository repository;

  ReadReplysUseCase({required this.repository});

  Stream<List<ReplyEntity>> call(ReplyEntity reply) {
    return repository.readReplys(reply);
  }
}
