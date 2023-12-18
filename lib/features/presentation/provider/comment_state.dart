import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/features/domain/entities/app_entity.dart';
import 'package:smat_crow/features/domain/entities/comment/comment_entity.dart';
import 'package:smat_crow/features/domain/entities/user/user_entity.dart';
import 'package:smat_crow/features/domain/usecases/comment/create_comment_usecase.dart';
import 'package:smat_crow/features/domain/usecases/comment/delete_comment_usecase.dart';
import 'package:smat_crow/features/domain/usecases/comment/like_comment_usecase.dart';
import 'package:smat_crow/features/domain/usecases/comment/read_comment_usecase.dart';
import 'package:smat_crow/features/domain/usecases/comment/update_comment_usecase.dart';
import 'package:uuid/uuid.dart';

enum CommentProviderStatus { initial, loading, loaded, failure }

class CommentProvider extends ChangeNotifier {
  final CreateCommentUseCase? createCommentUseCase;
  final DeleteCommentUseCase? deleteCommentUseCase;
  final LikeCommentUseCase? likeCommentUseCase;
  final ReadCommentsUseCase? readCommentsUseCase;
  final UpdateCommentUseCase? updateCommentUseCase;

  CommentProvider({
    this.updateCommentUseCase,
    this.readCommentsUseCase,
    this.likeCommentUseCase,
    this.deleteCommentUseCase,
    this.createCommentUseCase,
  });

  final TextEditingController _descriptionController = TextEditingController();
  final AppEntity appEntity = AppEntity();
  CommentProviderStatus _status = CommentProviderStatus.initial;
  CommentProviderStatus get status => _status;

  List<CommentEntity>? _comments;
  List<CommentEntity>? get comments => _comments;

  Future<void> getComments({required String postId}) async {
    _status = CommentProviderStatus.loading;
    notifyListeners();

    try {
      final streamResponse = readCommentsUseCase!.call(postId);
      streamResponse.listen((comments) {
        _comments = comments.cast<CommentEntity>();
        _status = CommentProviderStatus.loaded;
        notifyListeners();
      });
    } on FirebaseException catch (_) {
      _status = CommentProviderStatus.failure;
      notifyListeners();
    } catch (_) {
      _status = CommentProviderStatus.failure;
      notifyListeners();
    }
  }

  Future<void> likeComment({required CommentEntity comment}) async {
    try {
      await likeCommentUseCase!.call(comment);
    } on FirebaseException catch (_) {
      _status = CommentProviderStatus.failure;
      notifyListeners();
    } catch (_) {
      _status = CommentProviderStatus.failure;
      notifyListeners();
    }
  }

  Future<void> deleteComment({required CommentEntity comment}) async {
    try {
      await deleteCommentUseCase!.call(comment);
    } on FirebaseException catch (_) {
      _status = CommentProviderStatus.failure;
      notifyListeners();
    } catch (_) {
      _status = CommentProviderStatus.failure;
      notifyListeners();
    }
  }

  Future<void> createComment({required CommentEntity comment}) async {
    try {
      await createCommentUseCase!.call(comment);
    } on FirebaseException catch (_) {
      _status = CommentProviderStatus.failure;
      notifyListeners();
    } catch (_) {
      _status = CommentProviderStatus.failure;
      notifyListeners();
    }
  }

  Future<void> updateComment({required CommentEntity comment}) async {
    try {
      await updateCommentUseCase!.call(comment);
    } on FirebaseException catch (_) {
      _status = CommentProviderStatus.failure;
      notifyListeners();
    } catch (_) {
      _status = CommentProviderStatus.failure;
      notifyListeners();
    }
  }

  Future<void> createUserComment(
    UserEntity currentUser,
    BuildContext context,
  ) async {
    await Provider.of<CommentProvider>(context, listen: false)
        .createComment(
      comment: CommentEntity(
        totalReplys: SpacingConstants.size0,
        commentId: const Uuid().v1(),
        createAt: Timestamp.now(),
        likes: const [],
        email: currentUser.email,
        userProfileUrl: currentUser.profileUrl,
        description: _descriptionController.text,
        creatorUid: currentUser.uid,
        postId: appEntity.postId,
      ),
    )
        .then((value) {
      _descriptionController.clear();
      notifyListeners();
    });
  }
}
