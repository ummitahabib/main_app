// ignore_for_file: overridden_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smat_crow/features/domain/entities/comment/comment_entity.dart';

class CommentModel extends CommentEntity {
  @override
  final String? commentId;
  @override
  final String? postId;
  @override
  final String? creatorUid;
  @override
  final String? description;
  @override
  final String? email;
  @override
  final String? userProfileUrl;
  @override
  final Timestamp? createAt;
  @override
  final List<String>? likes;
  @override
  final num? totalReplys;

  CommentModel({
    this.commentId,
    this.postId,
    this.creatorUid,
    this.description,
    this.email,
    this.userProfileUrl,
    this.createAt,
    this.likes,
    this.totalReplys,
  }) : super(
          postId: postId,
          creatorUid: creatorUid,
          description: description,
          userProfileUrl: userProfileUrl,
          email: email,
          likes: likes,
          createAt: createAt,
          commentId: commentId,
          totalReplys: totalReplys,
        );

  factory CommentModel.fromSnapshot(DocumentSnapshot snap) {
    final snapshot = snap.data() as Map<String, dynamic>;

    return CommentModel(
      postId: snapshot['postId'],
      creatorUid: snapshot['creatorUid'],
      description: snapshot['description'],
      userProfileUrl: snapshot['userProfileUrl'],
      commentId: snapshot['commentId'],
      createAt: snapshot['createAt'],
      totalReplys: snapshot['totalReplys'],
      email: snapshot['email'],
      likes: List<String>.from(snap.get("likes")),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "commentId": commentId,
      "postId": postId,
      "creatorUid": creatorUid,
      "description": description,
      "email": email,
      "userProfileUrl": userProfileUrl,
      "createAt": createAt,
      "likes": likes,
      "totalReplys": totalReplys,
    };
  }

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      commentId: json['commentId'],
      postId: json['postId'],
      creatorUid: json['creatorUid'],
      description: json['description'],
      email: json['email'],
      userProfileUrl: json['userProfileUrl'],
      createAt: json['createAt'],
      likes: List<String>.from(json['likes']),
      totalReplys: json['totalReplys'],
    );
  }
}
