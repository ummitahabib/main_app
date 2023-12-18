import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/features/domain/entities/posts/post_entity.dart';
import 'package:smat_crow/features/domain/usecases/post/create_post_usecase.dart';
import 'package:smat_crow/features/domain/usecases/post/delete_post_usecase.dart';
import 'package:smat_crow/features/domain/usecases/post/like_post_usecase.dart';
import 'package:smat_crow/features/domain/usecases/post/read_posts_usecase.dart';
import 'package:smat_crow/features/domain/usecases/post/update_post_usecase.dart';
import 'package:smat_crow/utils2/constants.dart';

enum PostProviderStatus { initial, loading, loaded, failure }

class PostProvider extends ChangeNotifier {
  final CreatePostUseCase? createPostUseCase;
  final DeletePostUseCase? deletePostUseCase;
  final LikePostUseCase? likePostUseCase;
  final ReadPostsUseCase? readPostUseCase;
  final UpdatePostUseCase? updatePostUseCase;

  PostProvider({
    this.updatePostUseCase,
    this.deletePostUseCase,
    this.likePostUseCase,
    this.createPostUseCase,
    this.readPostUseCase,
  });

  String _error = emptyString;

  PostProviderStatus _status = PostProviderStatus.initial;
  PostProviderStatus get status => _status;

  set status(PostProviderStatus st) {
    _status = st;
    notifyListeners();
  }

  List<PostEntity> _posts = [];
  List<PostEntity> get posts => _posts;

  String get error => _error;

  Uint8List? image;

  Future<void> getPosts({PostEntity? post}) async {
    status = PostProviderStatus.loading;

    try {
      final streamResponse = readPostUseCase!.call(post!);
      streamResponse.listen(
        (posts) {
          _posts = posts.cast<PostEntity>();
          status = PostProviderStatus.loaded;
        },
        onError: (error) {
          if (error is FirebaseException) {
          } else {
            _error = "An error occurred: $error";
          }
          status = PostProviderStatus.failure;
        },
      );
    } on FirebaseException catch (error) {
      _error = "Firebase Error: ${error.message}";
      status = PostProviderStatus.failure;
    } catch (error) {
      _error = "An error occurred: $error";
      status = PostProviderStatus.failure;
    }
  }

  Future<void> likePost({required PostEntity post}) async {
    try {
      await likePostUseCase!.call(post);
    } on FirebaseException catch (_) {
      _status = PostProviderStatus.failure;
      notifyListeners();
    } catch (_) {
      _status = PostProviderStatus.failure;
      notifyListeners();
    }
  }

  Future<void> deletePost({required PostEntity post}) async {
    try {
      await deletePostUseCase!.call(post);
    } on FirebaseException catch (_) {
      _status = PostProviderStatus.failure;
      notifyListeners();
    } catch (_) {
      _status = PostProviderStatus.failure;
      notifyListeners();
    }
  }

  Future<void> createPost({required PostEntity post}) async {
    try {
      await createPostUseCase!.call(post);
    } on FirebaseException {
      _status = PostProviderStatus.failure;
      notifyListeners();
    } catch (e) {
      _status = PostProviderStatus.failure;
      notifyListeners();
    }
  }

  Future<void> updatePost({required PostEntity post}) async {
    try {
      await updatePostUseCase!.call(post);
    } on FirebaseException catch (_) {
      _status = PostProviderStatus.failure;
      notifyListeners();
    } catch (_) {
      _status = PostProviderStatus.failure;
      notifyListeners();
    }
  }

  Future<void> selectImage() async {
    try {
      final pickedFile = await FilePicker.platform.pickFiles();

      if (pickedFile != null) {
        final bytes = pickedFile.files.first.bytes;

        image = Uint8List.fromList(bytes!);
        notifyListeners();
      } else {}
    } catch (e) {
      rethrow;
    }
  }
}
