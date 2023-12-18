// ignore_for_file: overridden_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smat_crow/features/domain/entities/posts/post_entity.dart';

class PostModel extends PostEntity {
  @override
  final String? postId;
  @override
  final String? creatorUid;
  @override
  final String? email;
  @override
  final String? description;
  @override
  final String? postImageUrl;
  @override
  final List<String>? likes;
  @override
  final num? totalLikes;
  @override
  final num? totalComments;
  @override
  final Timestamp? createAt;
  @override
  final String? userProfileUrl;

  const PostModel({
    this.postId,
    this.creatorUid,
    this.email,
    this.description,
    this.postImageUrl,
    this.likes,
    this.totalLikes,
    this.totalComments,
    this.createAt,
    this.userProfileUrl,
  }) : super(
          createAt: createAt,
          creatorUid: creatorUid,
          description: description,
          likes: likes,
          postId: postId,
          postImageUrl: postImageUrl,
          totalComments: totalComments,
          totalLikes: totalLikes,
          email: email,
          userProfileUrl: userProfileUrl,
        );

  factory PostModel.fromSnapshot(DocumentSnapshot snap) {
    final snapshot = snap.data() as Map<String, dynamic>;

    return PostModel(
      createAt: snapshot['createAt'],
      creatorUid: snapshot['creatorUid'],
      description: snapshot['description'],
      userProfileUrl: snapshot['userProfileUrl'],
      totalLikes: snapshot['totalLikes'],
      totalComments: snapshot['totalComments'],
      postImageUrl: snapshot['postImageUrl'],
      postId: snapshot['postId'],
      email: snapshot['email'],
      likes: List<String>.from(snap.get("likes")),
    );
  }

  Map<String, dynamic> toJson() => {
        "postId": postId,
        "creatorUid": creatorUid,
        "email": email,
        "description": description,
        "postImageUrl": postImageUrl,
        "likes": likes,
        "totalLikes": totalLikes,
        "totalComments": totalComments,
        "createAt": createAt,
        "userProfileUrl": userProfileUrl,
      };

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      postId: json['postId'],
      creatorUid: json['creatorUid'],
      email: json['email'],
      description: json['description'],
      postImageUrl: json['postImageUrl'],
      likes: List<String>.from(json['likes']),
      totalLikes: json['totalLikes'],
      totalComments: json['totalComments'],
      createAt: json['createAt'],
      userProfileUrl: json['userProfileUrl'],
    );
  }
}
