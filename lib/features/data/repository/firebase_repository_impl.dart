import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/features/data/data_sources/remote_data_source.dart';
import 'package:smat_crow/features/domain/entities/category_entity.dart';
import 'package:smat_crow/features/domain/entities/comment/comment_entity.dart';
import 'package:smat_crow/features/domain/entities/posts/post_entity.dart';
import 'package:smat_crow/features/domain/entities/reply/reply_entity.dart';
import 'package:smat_crow/features/domain/entities/user/news_entity.dart';
import 'package:smat_crow/features/domain/entities/user/user_entity.dart';
import 'package:smat_crow/features/domain/repository/firebase_repository.dart';

class FirebaseRepositoryImpl implements FirebaseRepository {
  final FirebaseRemoteDataSource remoteDataSource;

  FirebaseRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> createUser(UserEntity user, String uid) async =>
      remoteDataSource.createUser(user, uid);

  @override
  Future<String> getCurrentUid() async => remoteDataSource.getCurrentUid();

  // @override
  // Future<UserEntity?> getSingleUser(
  //   String uid,
  // ) =>
  //     remoteDataSource.getSingleUser(uid);

  @override
  Stream<List<UserEntity>> getSingleUser(String uid) =>
      remoteDataSource.getSingleUser(uid);

  @override
  Stream<List<UserEntity>> getUsers(UserEntity user) =>
      remoteDataSource.getUsers(user);

  @override
  Future<bool> isSignIn() async => remoteDataSource.isSignIn();

  @override
  Future<UserCredential?> signInUser(UserEntity user) async =>
      remoteDataSource.signInUser(user);

  @override
  Future<void> signOut() async => remoteDataSource.signOut();

  @override
  Future<void> signUpUser(
    UserEntity user,
  ) async =>
      remoteDataSource.signUpUser(
        user,
      );

  @override
  Future<String> uploadImageToStorage(
    Uint8List file,
    bool isPost,
    String childName,
  ) async =>
      remoteDataSource.uploadImageToStorage(file, isPost, childName);

  @override
  Future<void> updateUser(UserEntity user) async =>
      remoteDataSource.updateUser(user);

  @override
  Future<List<NewsEntity>> fetchNews(NewsEntity news) async =>
      remoteDataSource.fetchNews(news);

  @override
  Future<void> fetchRandomAgricultureImage(BuildContext context) async =>
      remoteDataSource.fetchRandomAgricultureImage(context);
  @override
  Future<List<CategoryEntity>> getCategories() async =>
      remoteDataSource.getCategories();

  @override
  Future<void> createPost(PostEntity post) async =>
      remoteDataSource.createPost(post);
  @override
  Future<void> deletePost(PostEntity post) async =>
      remoteDataSource.deletePost(post);

  @override
  Future<void> likePost(PostEntity post) async =>
      remoteDataSource.likePost(post);

  @override
  Stream<List<PostEntity>> readPosts(PostEntity post) =>
      remoteDataSource.readPosts(post);

  @override
  Future<void> updatePost(PostEntity post) async =>
      remoteDataSource.updatePost(post);

  @override
  Future<void> createComment(CommentEntity comment) async =>
      remoteDataSource.createComment(comment);

  @override
  Future<void> deleteComment(CommentEntity comment) async =>
      remoteDataSource.deleteComment(comment);

  @override
  Future<void> likeComment(CommentEntity comment) async =>
      remoteDataSource.likeComment(comment);

  @override
  Stream<List<CommentEntity>> readComments(String postId) =>
      remoteDataSource.readComments(postId);

  @override
  Future<void> updateComment(CommentEntity comment) async =>
      remoteDataSource.updateComment(comment);

  @override
  Stream<List<PostEntity>> readSinglePost(String postId) =>
      remoteDataSource.readSinglePost(postId);

  @override
  Future<void> createReply(ReplyEntity reply) async =>
      remoteDataSource.createReply(reply);

  @override
  Future<void> deleteReply(ReplyEntity reply) async =>
      remoteDataSource.deleteReply(reply);

  @override
  Future<void> likeReply(ReplyEntity reply) async =>
      remoteDataSource.likeReply(reply);

  @override
  Stream<List<ReplyEntity>> readReplys(ReplyEntity reply) =>
      remoteDataSource.readReplys(reply);

  @override
  Future<void> updateReply(ReplyEntity reply) async =>
      remoteDataSource.updateReply(reply);

  @override
  Future<void> followUnFollowUser(UserEntity user) async =>
      remoteDataSource.followUnFollowUser(user);

  @override
  Stream<List<UserEntity>> getSingleOtherUser(String otherUid) =>
      remoteDataSource.getSingleOtherUser(otherUid);
}
