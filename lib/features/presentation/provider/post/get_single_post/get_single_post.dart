import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/features/domain/entities/posts/post_entity.dart';
import 'package:smat_crow/features/domain/usecases/post/read_single_post_usecase.dart';
import 'package:smat_crow/utils2/app_helper.dart';

enum GetSinglePostProviderStatus { initial, loading, loaded, failure }

class GetSinglePostProvider extends ChangeNotifier {
  final ReadSinglePostUseCase? readSinglePostUseCase;
  final String? postId;
  final String? uid;

  GetSinglePostProvider({this.readSinglePostUseCase, this.postId, this.uid});

  GetSinglePostProviderStatus _status = GetSinglePostProviderStatus.initial;
  GetSinglePostProviderStatus get status => _status;

  PostEntity? _post;
  PostEntity? get post => _post;
  ApplicationHelpers appHelper = ApplicationHelpers();

  Future<void> getSinglePost({required String postId}) async {
    _status = GetSinglePostProviderStatus.loading;
    notifyListeners();

    try {
      final streamResponse = readSinglePostUseCase!.call(postId);
      streamResponse.listen((posts) {
        _post = posts.first;
        _status = GetSinglePostProviderStatus.loaded;
        notifyListeners();
      });
    } on FirebaseException catch (_) {
      _status = GetSinglePostProviderStatus.failure;
      notifyListeners();
    } catch (_) {
      _status = GetSinglePostProviderStatus.failure;
      notifyListeners();
    }
  }
}
