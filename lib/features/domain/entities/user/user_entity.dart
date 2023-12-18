import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? uid;
  final String? username;
  final String? name;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? profileUrl;
  final String? report;
  final String? reportReason;
  final List? followers;
  final List? following;
  final num? totalFollowers;
  final num? totalFollowing;
  final num? totalPosts;
  final bool? blockUser;

  // will not going to store in Firestore DB
  final Uint8List? imageFile;
  final String? password;
  final String? otherUid;

  const UserEntity({
    this.imageFile,
    this.uid,
    this.username,
    this.name,
    this.firstName,
    this.lastName,
    this.email,
    this.profileUrl,
    this.report,
    this.reportReason,
    this.followers,
    this.following,
    this.totalFollowers,
    this.totalFollowing,
    this.password,
    this.otherUid,
    this.totalPosts,
    this.blockUser,
  });

  @override
  List<Object?> get props => [
        uid,
        username,
        name,
        firstName,
        lastName,
        email,
        profileUrl,
        report,
        reportReason,
        followers,
        following,
        totalFollowers,
        totalFollowing,
        password,
        otherUid,
        totalPosts,
        imageFile,
        blockUser
      ];
}
