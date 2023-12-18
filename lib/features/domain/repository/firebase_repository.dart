import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/features/domain/entities/category_entity.dart';
import 'package:smat_crow/features/domain/entities/comment/comment_entity.dart';
import 'package:smat_crow/features/domain/entities/posts/post_entity.dart';
import 'package:smat_crow/features/domain/entities/reply/reply_entity.dart';
import 'package:smat_crow/features/domain/entities/user/news_entity.dart';
import 'package:smat_crow/features/domain/entities/user/user_entity.dart';

abstract class FirebaseRepository {
  // Credential
  Future<UserCredential?> signInUser(UserEntity user);
  Future<void> signUpUser(UserEntity user);
  Future<bool> isSignIn();
  Future<void> signOut();

  // User
  Stream<List<UserEntity>> getUsers(UserEntity user);
  Stream<List<UserEntity>> getSingleUser(String uid);
  Stream<List<UserEntity>> getSingleOtherUser(String otherUid);
  Future<String> getCurrentUid();
  Future<void> createUser(UserEntity user, String uid);
  Future<void> updateUser(UserEntity user);
  Future<void> followUnFollowUser(UserEntity user);

  // Cloud Storage Feature
  Future<String> uploadImageToStorage(
    Uint8List file,
    bool isPost,
    String childName,
  );

  //news
  Future<List<NewsEntity>> fetchNews(NewsEntity news);
  Future<void> fetchRandomAgricultureImage(BuildContext context);
  Future<List<CategoryEntity>> getCategories();

  // Post Features
  Future<void> createPost(PostEntity post);
  Stream<List<PostEntity>> readPosts(PostEntity post);
  Stream<List<PostEntity>> readSinglePost(String postId);
  Future<void> updatePost(PostEntity post);
  Future<void> deletePost(PostEntity post);
  Future<void> likePost(PostEntity post);

  // Comment Features
  Future<void> createComment(CommentEntity comment);
  Stream<List<CommentEntity>> readComments(String postId);
  Future<void> updateComment(CommentEntity comment);
  Future<void> deleteComment(CommentEntity comment);
  Future<void> likeComment(CommentEntity comment);

  // Reply Features
  Future<void> createReply(ReplyEntity reply);
  Stream<List<ReplyEntity>> readReplys(ReplyEntity reply);
  Future<void> updateReply(ReplyEntity reply);
  Future<void> deleteReply(ReplyEntity reply);
  Future<void> likeReply(ReplyEntity reply);
}
