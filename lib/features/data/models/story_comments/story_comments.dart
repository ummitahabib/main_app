// ignore_for_file: overridden_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smat_crow/features/domain/entities/story_comment_entities/story_comment_entities.dart';

class StoryCommentModel extends StoryCommentEntity {
  @override
  final String? storyCommentId;
  @override
  final String? storyId;
  @override
  final String? creatorUid;
  @override
  final String? caption;
  @override
  final String? username;
  @override
  final String? userProfileUrl;
  @override
  final Timestamp? createAt;
  @override
  final List<String>? likes;
  @override
  final num? totalReplys;

  const StoryCommentModel({
    this.storyCommentId,
    this.storyId,
    this.creatorUid,
    this.caption,
    this.username,
    this.userProfileUrl,
    this.createAt,
    this.likes,
    this.totalReplys,
  }) : super(
          storyId: storyId,
          creatorUid: creatorUid,
          caption: caption,
          userProfileUrl: userProfileUrl,
          username: username,
          likes: likes,
          createAt: createAt,
          storyCommentId: storyCommentId,
          totalReplys: totalReplys,
        );

  factory StoryCommentModel.fromSnapshot(DocumentSnapshot snap) {
    final snapshot = snap.data() as Map<String, dynamic>;

    return StoryCommentModel(
      storyId: snapshot['storyId'],
      creatorUid: snapshot['creatorUid'],
      caption: snapshot['caption'],
      userProfileUrl: snapshot['userProfileUrl'],
      storyCommentId: snapshot['storyCommentId'],
      createAt: snapshot['createAt'],
      totalReplys: snapshot['totalReplys'],
      username: snapshot['username'],
      likes: List.from(snap.get("likes")),
    );
  }

  Map<String, dynamic> toJson() => {
        "creatorUid": creatorUid,
        "caption": caption,
        "userProfileUrl": userProfileUrl,
        "storyCommentId": storyCommentId,
        "createAt": createAt,
        "totalReplys": totalReplys,
        "storyId": storyId,
        "likes": likes,
        "username": username,
      };
}
