import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final String? postId;
  final String? creatorUid;
  final String? email;
  final String? description;
  final String? postImageUrl;
  final List<String>? likes;
  final num? totalLikes;
  final num? totalComments;
  final Timestamp? createAt;
  final String? userProfileUrl;

  const PostEntity({
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
  });

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'creatorUid': creatorUid,
      'email': email,
      'description': description,
      'postImageUrl': postImageUrl,
      'likes': likes,
      'totalLikes': totalLikes,
      'totalComments': totalComments,
      'createAt': createAt,
      'userProfileUrl': userProfileUrl,
    };
  }

  @override
  List<Object?> get props => [
        postId,
        creatorUid,
        email,
        description,
        postImageUrl,
        likes,
        totalLikes,
        totalComments,
        createAt,
        userProfileUrl,
      ];
}
