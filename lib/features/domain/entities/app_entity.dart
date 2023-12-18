// import 'package:smat_crow/features/domain/entities/posts/post_entity.dart';
// import 'package:smat_crow/features/domain/entities/user/user_entity.dart';

// class AppEntity {
//   final UserEntity? currentUser;
//   final PostEntity? postEntity;

//   final String? uid;
//   final String? postId;

//   AppEntity({this.currentUser, this.postEntity, this.uid, this.postId});
// }

import 'package:smat_crow/features/domain/entities/posts/post_entity.dart';
import 'package:smat_crow/features/domain/entities/user/user_entity.dart';

class AppEntity {
  final UserEntity? currentUser;
  final PostEntity? postEntity;

  final String? uid;
  final String? postId;

  AppEntity({this.currentUser, this.postEntity, this.uid, this.postId});
}
