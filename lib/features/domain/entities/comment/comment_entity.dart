import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class CommentEntity extends Equatable {
  final String? commentId;
  final String? postId;
  final String? creatorUid;
  final String? description;
  final String? email;
  final String? userProfileUrl;
  final Timestamp? createAt;
  final List<String>? likes;
  final num? totalReplys;

  const CommentEntity({
    this.commentId,
    this.postId,
    this.creatorUid,
    this.description,
    this.email,
    this.userProfileUrl,
    this.createAt,
    this.likes,
    this.totalReplys,
  });

  @override
  List<Object?> get props => [
        commentId,
        postId,
        creatorUid,
        description,
        email,
        userProfileUrl,
        createAt,
        likes,
        totalReplys,
      ];
}
