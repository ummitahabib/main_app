import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class StoryEntity extends Equatable {
  final String? storyId;
  final String? creatorUid;
  final String? username;
  final List<String>? storyImageUrls; // Change the property name to be plural
  final List<String>? likes;
  final num? totalLikes;
  final num? totalComments;
  final Timestamp? createAt;
  final String? userProfileUrl;

  const StoryEntity({
    this.storyId,
    this.creatorUid,
    this.username,
    this.storyImageUrls, // Change the property name to be plural
    this.likes,
    this.totalLikes,
    this.totalComments,
    this.createAt,
    this.userProfileUrl,
  });

  @override
  List<Object?> get props => [
        storyId,
        creatorUid,
        username,
        storyImageUrls, // Change the property name to be plural
        likes,
        totalLikes,
        totalComments,
        createAt,
        userProfileUrl,
      ];
}
