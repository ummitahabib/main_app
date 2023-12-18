// ignore_for_file: overridden_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smat_crow/features/domain/entities/user/user_entity.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

//user model

class UserModel extends UserEntity {
  @override
  final String? uid;
  @override
  final String? username;

  @override
  final String? firstName;
  @override
  final String? lastName;
  @override
  final String? email;
  @override
  final String? profileUrl;

  @override
  final String? report;
  @override
  final String? reportReason;

  @override
  final List? followers;
  @override
  final List? following;
  @override
  final num? totalFollowers;
  @override
  final num? totalFollowing;
  @override
  final num? totalPosts;

  @override
  final bool? blockUser;

  UserModel({
    this.uid,
    this.username,
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
    this.totalPosts,
    this.blockUser,
  }) : super(
          uid: uid,
          totalFollowing: totalFollowing ?? 0,
          followers: followers ?? [],
          totalFollowers: totalFollowers ?? 0,
          username: username ?? emptyString,
          profileUrl: profileUrl ?? emptyString,
          report: report ?? emptyString,
          reportReason: reportReason ?? emptyString,
          following: following ?? [],
          firstName: firstName ?? emptyString,
          lastName: lastName ?? emptyString,
          email: email ?? emptyString,
          totalPosts: totalPosts ?? SpacingConstants.int0,
          blockUser: blockUser ?? false,
        );

  factory UserModel.fromSnapshot(DocumentSnapshot snap) {
    try {
      final snapshot = snap.data() as Map<String, dynamic>;

      return UserModel(
        email: snapshot['email'],
        firstName: snapshot['firstName'],
        lastName: snapshot['lastName'],
        username: snapshot['username'],
        totalFollowers: (snapshot['totalFollowers'] is num)
            ? snapshot['totalFollowers'] as num
            : int.tryParse(snapshot['totalFollowers'].toString()) ?? 0,
        totalFollowing: (snapshot['totalFollowing'] is num)
            ? snapshot['totalFollowing'] as num
            : int.tryParse(snapshot['totalFollowing'].toString()) ?? 0,
        totalPosts: (snapshot['totalPosts'] is num)
            ? snapshot['totalPosts'] as num
            : int.tryParse(snapshot['totalPosts'].toString()) ?? 0,
        uid: snapshot['uid'],
        profileUrl: snapshot['profileUrl'],
        report: snapshot['report'],
        reportReason: snapshot['reportReason'],
        followers: snapshot['followers'] != null ? List.from(snapshot['followers']) : [],
        following: snapshot['following'] != null ? List.from(snapshot['following']) : [],
        blockUser: snapshot['block'] ?? false,
      );
    } catch (e) {
      // Handle the error gracefully or re-throw it if needed
      return UserModel(); // Return a default UserModel or handle the error differently
    }
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "username": username,
        "totalFollowers": totalFollowers,
        "totalFollowing": totalFollowing,
        "totalPosts": totalPosts,
        "profileUrl": profileUrl,
        "followers": followers,
        "following": following,
        "block": blockUser,
      };
}
