import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:smat_crow/features/domain/entities/reply/reply_entity.dart';
import 'package:smat_crow/features/domain/usecases/reply/create_reply_usecase.dart';
import 'package:smat_crow/features/domain/usecases/reply/delete_reply_usecase.dart';
import 'package:smat_crow/features/domain/usecases/reply/like_reply_usecase.dart';
import 'package:smat_crow/features/domain/usecases/reply/read_replys_usecase.dart';
import 'package:smat_crow/features/domain/usecases/reply/update_reply_usecase.dart';

enum ReplyProviderStatus { initial, loading, loaded, failure }

class ReplyProvider extends ChangeNotifier {
  final CreateReplyUseCase createReplyUseCase;
  final DeleteReplyUseCase deleteReplyUseCase;
  final LikeReplyUseCase likeReplyUseCase;
  final ReadReplysUseCase readReplysUseCase;
  final UpdateReplyUseCase updateReplyUseCase;

  ReplyProvider({
    required this.createReplyUseCase,
    required this.updateReplyUseCase,
    required this.readReplysUseCase,
    required this.likeReplyUseCase,
    required this.deleteReplyUseCase,
  });

  ReplyProviderStatus _status = ReplyProviderStatus.initial;
  ReplyProviderStatus get status => _status;

  List<ReplyEntity>? _replys;
  List<ReplyEntity>? get replys => _replys;

  Future<void> getReplys({ReplyEntity? reply}) async {
    _status = ReplyProviderStatus.loading;
    notifyListeners();

    try {
      final streamResponse = readReplysUseCase.call(reply!);
      streamResponse.listen((replys) {
        _replys = replys.cast<ReplyEntity>();
        _status = ReplyProviderStatus.loaded;
        notifyListeners();
      });
    } on FirebaseException catch (_) {
      _status = ReplyProviderStatus.failure;
      notifyListeners();
    } catch (_) {
      _status = ReplyProviderStatus.failure;
      notifyListeners();
    }
  }

  Future<void> likeReply({required ReplyEntity reply}) async {
    try {
      await likeReplyUseCase.call(reply);
    } on FirebaseException catch (_) {
      _status = ReplyProviderStatus.failure;
      notifyListeners();
    } catch (_) {
      _status = ReplyProviderStatus.failure;
      notifyListeners();
    }
  }

  Future<void> createReply({required ReplyEntity reply}) async {
    try {
      await createReplyUseCase.call(reply);
    } on FirebaseException catch (_) {
      _status = ReplyProviderStatus.failure;
      notifyListeners();
    } catch (_) {
      _status = ReplyProviderStatus.failure;
      notifyListeners();
    }
  }

  Future<void> deleteReply({required ReplyEntity reply}) async {
    try {
      await deleteReplyUseCase.call(reply);
    } on FirebaseException catch (_) {
      _status = ReplyProviderStatus.failure;
      notifyListeners();
    } catch (_) {
      _status = ReplyProviderStatus.failure;
      notifyListeners();
    }
  }

  Future<void> updateReply({required ReplyEntity reply}) async {
    try {
      await updateReplyUseCase.call(reply);
    } on FirebaseException catch (_) {
      _status = ReplyProviderStatus.failure;
      notifyListeners();
    } catch (_) {
      _status = ReplyProviderStatus.failure;
      notifyListeners();
    }
  }
}
