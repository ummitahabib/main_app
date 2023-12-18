import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class StoryCommentEntity extends Equatable {
  final String? storyCommentId;
  final String? storyId;
  final String? creatorUid;
  final String? caption;
  final String? username;
  final String? userProfileUrl;
  final Timestamp? createAt;
  final List<String>? likes;
  final num? totalReplys;

  const StoryCommentEntity({
    this.storyCommentId,
    this.storyId,
    this.creatorUid,
    this.caption,
    this.username,
    this.userProfileUrl,
    this.createAt,
    this.likes,
    this.totalReplys,
  });

  @override
  List<Object?> get props => [
        storyCommentId,
        storyId,
        creatorUid,
        caption,
        username,
        userProfileUrl,
        createAt,
        likes,
        totalReplys,
      ];
}
