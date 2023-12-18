// ignore_for_file: prefer_final_locals

import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as https;
import 'package:smat_crow/features/data/data_sources/remote_data_source.dart';
import 'package:smat_crow/features/data/models/comment/comment_model.dart';
import 'package:smat_crow/features/data/models/posts/post_model.dart';
import 'package:smat_crow/features/data/models/reply/reply_model.dart';
import 'package:smat_crow/features/data/models/user/user_model.dart';
import 'package:smat_crow/features/domain/entities/category_entity.dart';
import 'package:smat_crow/features/domain/entities/comment/comment_entity.dart';
import 'package:smat_crow/features/domain/entities/posts/post_entity.dart';
import 'package:smat_crow/features/domain/entities/reply/reply_entity.dart';
import 'package:smat_crow/features/domain/entities/user/news_entity.dart';
import 'package:smat_crow/features/domain/entities/user/user_entity.dart';
import 'package:smat_crow/features/presentation/widgets/alert.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/app_helper.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:uuid/uuid.dart';
import 'package:xml2json/xml2json.dart';

//This is remote data source implementation

class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;

  FirebaseRemoteDataSourceImpl({
    required this.firebaseStorage,
    required this.firebaseFirestore,
    required this.firebaseAuth,
  });

  void get http {}

  Future<void> createUserWithImage(
    UserEntity user,
    String profileUrl,
  ) async {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users);

    final uid = await getCurrentUid();

    await userCollection.doc(uid).get().then((userDoc) {
      final newUser = UserModel(
        uid: uid,
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        following: user.following,
        profileUrl: profileUrl,
        totalFollowers: user.totalFollowers,
        followers: user.followers,
        totalFollowing: user.totalFollowing,
        totalPosts: user.totalPosts,
      ).toJson();

      if (!userDoc.exists) {
        userCollection.doc(uid).set(newUser);
      } else {
        userCollection.doc(uid).update(newUser);
      }
    }).catchError((error) {
      ApplicationHelpers().trackAPIEvent(
        'SIGN_UP',
        'CREATE_USER_WITH_IMAGE',
        'FAILED',
        error.toString(),
      );
    });
  }

  @override
  Future<void> createUser(UserEntity user, String uid) async {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users);

    try {
      final userDoc = await userCollection.where('email', isEqualTo: user.email).get();
      log("userDoc: ${userDoc.docs.map((e) => e.data()).length}");
      if (userDoc.docs.isNotEmpty) {
        throw Exception('Email address already exists. Please log in.');
      } else {
        final newUser = UserModel(
          uid: uid,
          firstName: user.firstName,
          lastName: user.lastName,
          email: user.email,
          following: user.following,
          profileUrl: user.profileUrl,
          totalFollowers: user.totalFollowers,
          followers: user.followers,
          totalFollowing: user.totalFollowing,
          totalPosts: user.totalPosts,
        ).toJson();

        await userCollection.doc(uid).set(newUser);
        log("userDoc: ${userDoc.docs.map((e) => e.data()).length}");
      }
    } catch (error) {
      ApplicationHelpers().trackAPIEvent(
        'SIGN_UP',
        'CREATE_USER_WITH_IMAGE',
        'FAILED',
        error.toString(),
      );
      log("errorrrr: $error");
    }
  }

  @override
  Future<String> getCurrentUid() async => firebaseAuth.currentUser!.uid;

  @override
  Future<void> updateUser(UserEntity user) async {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users);
    Map<String, dynamic> userInformation = {};

    if (user.email != "" && user.email != null) {
      userInformation['email'] = user.email;
    }

    if (user.profileUrl != "" && user.profileUrl != null) {
      userInformation['profileUrl'] = user.profileUrl;
    }

    if (user.firstName != "" && user.firstName != null) {
      userInformation['name'] = user.firstName;
    }

    if (user.lastName != "" && user.lastName != null) {
      userInformation['name'] = user.lastName;
    }

    if (user.totalFollowing != null) {
      userInformation['totalFollowing'] = user.totalFollowing;
    }

    if (user.totalFollowers != null) {
      userInformation['totalFollowers'] = user.totalFollowers;
    }

    if (user.totalPosts != null) {
      userInformation['totalPosts'] = user.totalPosts;
    }

    await userCollection.doc(user.uid).update(userInformation);
  }

  @override
  Stream<List<UserEntity>> getSingleUser(String uid) {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users).where(Const.uid, isEqualTo: uid).limit(1);
    return userCollection.snapshots().map(
          (querySnapshot) => querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList(),
        );
  }

  @override
  Stream<List<UserEntity>> getUsers(UserEntity user) {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users);
    try {
      return userCollection.snapshots().map(
            (querySnapshot) => querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList(),
          );
    } catch (e) {
      debugPrint('Error in getUsers: $e');
      rethrow;
    }
  }

  @override
  Future<bool> isSignIn() async => firebaseAuth.currentUser?.uid != null;

  @override
  Future<UserCredential?> signInUser(UserEntity user) async {
    try {
      if (user.email!.isNotEmpty && user.password!.isNotEmpty) {
        final result = await firebaseAuth.signInWithEmailAndPassword(
          email: user.email!,
          password: user.password!,
        );

        if (result.user != null) {
          final userCollection = firebaseFirestore.collection(FirebaseConst.users);
          final userDoc = await userCollection.where('email', isEqualTo: user.email).get();

          if (userDoc.docs.isEmpty) {
            final newUser = UserModel(
              uid: result.user!.uid,
              firstName: user.firstName,
              lastName: user.lastName,
              email: user.email,
              following: user.following,
              profileUrl: user.profileUrl,
              totalFollowers: user.totalFollowers,
              followers: user.followers,
              totalFollowing: user.totalFollowing,
              totalPosts: user.totalPosts,
            ).toJson();
            await userCollection.doc(result.user!.uid).set(newUser);
          }
          log(result.user!.uid);
          await Pandora().saveToSharedPreferences('uid', result.user!.uid);
          ApplicationHelpers().trackButtonAndDeviceEvent("SIGN_IN_SUCCESS");
          return result;
        }
        return null;
      } else {
        ApplicationHelpers().trackAPIEvent(
          'SIGNIN',
          'signInUser',
          'EMPTY_FIELDS_ERROR',
          'Fields cannot be empty',
        );

        showErrorDialog(
          alertHeaderText: loginFailed,
          messageType: MessageTypes.WARNING.toString().split(splitString).last,
          alertBodyDescription: emptyFieldWarning,
          onPressedFirstbutton: () {},
          onPressedSecondbutton: () {},
          leftbuttonText: tryAgain,
          rightbuttonText: cancel,
        );
      }
    } on FirebaseAuthException catch (e) {
      log("errror: $e");
      if (e.code == "user-not-found") {
        ApplicationHelpers().trackAPIEvent(
          'SIGNIN',
          'signInUser',
          'USER_NOT_FOUND_ERROR',
          'User not found',
        );

        showErrorDialog(
          alertHeaderText: userNotFound,
          messageType: MessageTypes.WARNING.toString().split(splitString).last,
          alertBodyDescription: userNotFound,
          onPressedFirstbutton: () {},
          onPressedSecondbutton: () {},
          leftbuttonText: tryAgain,
          rightbuttonText: cancel,
        );
      } else if (e.code == "wrong-password") {
        ApplicationHelpers().trackAPIEvent(
          'SIGNIN',
          'signInUser',
          'INVALID_CREDENTIALS_ERROR',
          'Invalid email or password',
        );

        showErrorDialog(
          alertHeaderText: invalidCredentials,
          messageType: MessageTypes.WARNING.toString().split(splitString).last,
          alertBodyDescription: invalidEmailandPassword,
          onPressedFirstbutton: () {},
          onPressedSecondbutton: () {},
          leftbuttonText: tryAgain,
          rightbuttonText: cancel,
        );
      }
      showErrorDialog(
        alertHeaderText: invalidCredentials,
        messageType: MessageTypes.WARNING.toString().split(splitString).last,
        alertBodyDescription: e.toString(),
        onPressedFirstbutton: () {},
        onPressedSecondbutton: () {},
        leftbuttonText: tryAgain,
        rightbuttonText: cancel,
      );
    }
    return null;
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<void> signUpUser(UserEntity user) async {
    try {
      await firebaseAuth
          .createUserWithEmailAndPassword(
        email: user.email!,
        password: user.password!,
      )
          .then((currentUser) async {
        if (currentUser.user != null) {
          await createUser(user, currentUser.user!.uid);
          if (user.imageFile != null) {
            await uploadImageToStorage(
              user.imageFile,
              false,
              "profileImages",
            ).then((profileUrl) {
              createUserWithImage(user, profileUrl);
            });
          }
        }
      });
      ApplicationHelpers().trackAPIEvent(
        'FIREBASE_CREATE_ACCOUNT',
        'FIREBASE_AUTH',
        'SUCCESS',
        doubleEmptyString,
      );
    } catch (e) {
      if (e is FirebaseAuthException) {
        ApplicationHelpers().trackAPIEvent(
          'FIREBASE_CREATE_ACCOUNT',
          'FIREBASE_AUTH',
          'FAILED',
          ' ${e.code}, ${e.message}',
        );

        showErrorDialog(
          alertHeaderText: createAccountFailedHeader,
          messageType: MessageTypes.WARNING.toString().split(splitString).last,
          alertBodyDescription: createAccountFailedDescription,
          onPressedFirstbutton: () {},
          onPressedSecondbutton: () {},
          leftbuttonText: tryAgain,
          rightbuttonText: cancel,
        );
      }
    }
  }

  @override
  Future<String> uploadImageToStorage(
    Uint8List? file,
    bool isPost,
    String childName,
  ) async {
    Reference ref = firebaseStorage.ref().child(childName).child(firebaseAuth.currentUser!.uid);

    if (isPost) {
      final String id = const Uuid().v1();
      ref = ref.child(id);
    }

    final UploadTask uploadTask = ref.putData(file!);

    final imageUrl = (await uploadTask.whenComplete(() {})).ref.getDownloadURL();

    return imageUrl;
  }

//news

  late String randomImageUrl;

  @override
  Future<List<NewsEntity>> fetchNews(NewsEntity news) async {
    final baseUrl = 'https://news.google.com/rss/search?q=${news.category}&hl=en-NG&gl=NG&ceid=NG:en';
    final response = await https.get(Uri.parse(baseUrl));
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      final myTransformer = Xml2Json();
      myTransformer.parse(response.body);
      final json = myTransformer.toGData();
      final result = jsonDecode(json)['rss']['channel']['item'];
      log(result.toString());
      if (result is! List<dynamic>) {
        return [NewsEntity.fromJson(result)];
      }

      return result.map<NewsEntity>((item) => NewsEntity.fromJson(item)).toList();
    } else {
      ApplicationHelpers().trackAPIEvent(
        'NEWS',
        'FETCH_NEWS_FROM_API',
        'FAILED',
        '${response.statusCode}',
      );
      throw Exception(noNews);
    }
  }

  @override
  Future<void> fetchRandomAgricultureImage(BuildContext context) async {
    const apiKey = NewsConst.randomImageApi;
    final response = await https.get(
      Uri.parse(NewsConst.imageEndPoint),
      headers: {'Authorization': 'Client-ID $apiKey'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      randomImageUrl = data[NewsConst.urls][NewsConst.regular];
    } else {
      ApplicationHelpers().trackAPIEvent(
        'NEWS',
        'LOAD_RANDOM_AGRICULTURAL_IMAGES',
        'FAILED',
        '${response.statusCode}',
      );
    }
  }

  @override
  Future<List<CategoryEntity>> getCategories() async {
    final response = await https.get(Uri.parse(emptyString));

    if (response.statusCode == SpacingConstants.int200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map<CategoryEntity>((item) => CategoryEntity.fromJson(item)).toList();
    } else {
      ApplicationHelpers().trackAPIEvent(
        'CATEGORIES',
        'LOAD_RANDOM_CATEGORIES',
        'FAILED',
        '${response.statusCode}',
      );
      throw Exception(noCategories);
    }
  }

  @override
  Future<void> createPost(PostEntity post) async {
    final postCollection = firebaseFirestore.collection(FirebaseConst.posts);

    final newPost = PostModel(
      userProfileUrl: post.userProfileUrl,
      email: post.email,
      totalLikes: 0,
      totalComments: 0,
      postImageUrl: post.postImageUrl,
      postId: post.postId,
      likes: const [],
      description: post.description,
      creatorUid: post.creatorUid,
      createAt: post.createAt,
    ).toJson();

    try {
      final postDocRef = await postCollection.doc(post.postId).get();

      if (!postDocRef.exists) {
        await postCollection.doc(post.postId).set(newPost).then((value) async {
          final userCollection = firebaseFirestore.collection(FirebaseConst.users).doc(post.creatorUid);

          try {
            final userDocRef = await userCollection.get();
            if (userDocRef.exists) {
              final totalPosts = userDocRef.get('totalPosts');
              await userCollection.update({"totalPosts": totalPosts + 1});
            }
          } catch (userError) {
            debugPrint("Error updating user data: $userError");
          }
        });
      } else {
        await postCollection.doc(post.postId).update(newPost);
      }
    } catch (e) {
      debugPrint("Error occurred in createPost: $e");
    }
  }

  @override
  Future<void> deletePost(PostEntity post) async {
    final postCollection = firebaseFirestore.collection(FirebaseConst.posts);

    try {
      await postCollection.doc(post.postId).delete().then((value) {
        final userCollection = firebaseFirestore.collection(FirebaseConst.users).doc(post.creatorUid);

        userCollection.get().then((value) {
          if (value.exists) {
            final totalPosts = value.get('totalPosts');
            userCollection.update({"totalPosts": totalPosts - 1});
            return;
          }
        });
      });
    } catch (e) {
      debugPrint("some error occured $e");
    }
  }

  @override
  Future<void> likePost(PostEntity post) async {
    final postCollection = firebaseFirestore.collection(FirebaseConst.posts);

    final currentUid = await getCurrentUid();
    final postRef = await postCollection.doc(post.postId).get();

    if (postRef.exists) {
      final List likes = postRef.get("likes");
      final totalLikes = postRef.get("totalLikes");
      if (likes.contains(currentUid)) {
        await postCollection.doc(post.postId).update({
          "likes": FieldValue.arrayRemove([currentUid]),
          "totalLikes": totalLikes - 1
        });
      } else {
        await postCollection.doc(post.postId).update({
          "likes": FieldValue.arrayUnion([currentUid]),
          "totalLikes": totalLikes + 1
        });
      }
    }
  }

  @override
  Stream<List<PostEntity>> readPosts(PostEntity post) {
    final postCollection = firebaseFirestore.collection(FirebaseConst.posts).orderBy("createAt", descending: true);
    return postCollection.snapshots().map(
          (querySnapshot) => querySnapshot.docs.map((e) => PostModel.fromSnapshot(e)).toList(),
        );
  }

  @override
  Stream<List<PostEntity>> readSinglePost(String postId) {
    final postCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .orderBy("createAt", descending: true)
        .where("postId", isEqualTo: postId);
    return postCollection.snapshots().map(
          (querySnapshot) => querySnapshot.docs.map((e) => PostModel.fromSnapshot(e)).toList(),
        );
  }

  @override
  Future<void> updatePost(PostEntity post) async {
    final postCollection = firebaseFirestore.collection(FirebaseConst.posts);
    Map<String, dynamic> postInfo = {};

    if (post.description != "" && post.description != null) {
      postInfo['description'] = post.description;
    }
    if (post.postImageUrl != "" && post.postImageUrl != null) {
      postInfo['postImageUrl'] = post.postImageUrl;
    }

    await postCollection.doc(post.postId).update(postInfo);
  }

  @override
  Future<void> createComment(CommentEntity comment) async {
    final commentCollection =
        firebaseFirestore.collection(FirebaseConst.posts).doc(comment.postId).collection(FirebaseConst.comment);

    final newComment = CommentModel(
      userProfileUrl: comment.userProfileUrl,
      email: comment.email,
      totalReplys: comment.totalReplys,
      commentId: comment.commentId,
      postId: comment.postId,
      likes: const [],
      description: comment.description,
      creatorUid: comment.creatorUid,
      createAt: comment.createAt,
    ).toJson();

    try {
      final commentDocRef = await commentCollection.doc(comment.commentId).get();

      if (!commentDocRef.exists) {
        await commentCollection.doc(comment.commentId).set(newComment).then((value) {
          final postCollection = firebaseFirestore.collection(FirebaseConst.posts).doc(comment.postId);

          postCollection.get().then((value) {
            if (value.exists) {
              final totalComments = value.get('totalComments');
              postCollection.update({"totalComments": totalComments + 1});
              return;
            }
          });
        });
      } else {
        await commentCollection.doc(comment.commentId).update(newComment);
      }
    } catch (e) {
      debugPrint("some error occured $e");
    }
  }

  @override
  Future<void> deleteComment(CommentEntity comment) async {
    final commentCollection =
        firebaseFirestore.collection(FirebaseConst.posts).doc(comment.postId).collection(FirebaseConst.comment);

    try {
      await commentCollection.doc(comment.commentId).delete().then((value) {
        final postCollection = firebaseFirestore.collection(FirebaseConst.posts).doc(comment.postId);

        postCollection.get().then((value) {
          if (value.exists) {
            final totalComments = value.get('totalComments');
            postCollection.update({"totalComments": totalComments - 1});
            return;
          }
        });
      });
    } catch (e) {
      debugPrint("some error occured $e");
    }
  }

  @override
  Future<void> likeComment(CommentEntity comment) async {
    final commentCollection =
        firebaseFirestore.collection(FirebaseConst.posts).doc(comment.postId).collection(FirebaseConst.comment);
    final currentUid = await getCurrentUid();

    final commentRef = await commentCollection.doc(comment.commentId).get();

    if (commentRef.exists) {
      final List likes = commentRef.get("likes");
      if (likes.contains(currentUid)) {
        await commentCollection.doc(comment.commentId).update({
          "likes": FieldValue.arrayRemove([currentUid])
        });
      } else {
        await commentCollection.doc(comment.commentId).update({
          "likes": FieldValue.arrayUnion([currentUid])
        });
      }
    }
  }

  @override
  Stream<List<CommentEntity>> readComments(String postId) {
    final commentCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .doc(postId)
        .collection(FirebaseConst.comment)
        .orderBy("createAt", descending: true);
    return commentCollection.snapshots().map(
          (querySnapshot) => querySnapshot.docs.map((e) => CommentModel.fromSnapshot(e)).toList(),
        );
  }

  @override
  Future<void> updateComment(CommentEntity comment) async {
    final commentCollection =
        firebaseFirestore.collection(FirebaseConst.posts).doc(comment.postId).collection(FirebaseConst.comment);

    Map<String, dynamic> commentInfo = {};

    if (comment.description != "" && comment.description != null) {
      commentInfo["description"] = comment.description;
    }

    await commentCollection.doc(comment.commentId).update(commentInfo);
  }

  @override
  Future<void> createReply(ReplyEntity reply) async {
    final replyCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .doc(reply.postId)
        .collection(FirebaseConst.comment)
        .doc(reply.commentId)
        .collection(FirebaseConst.reply);

    final newReply = ReplyModel(
      userProfileUrl: reply.userProfileUrl,
      email: reply.email,
      replyId: reply.replyId,
      commentId: reply.commentId,
      postId: reply.postId,
      likes: const [],
      description: reply.description,
      creatorUid: reply.creatorUid,
      createAt: reply.createAt,
    ).toJson();

    try {
      final replyDocRef = await replyCollection.doc(reply.replyId).get();

      if (!replyDocRef.exists) {
        await replyCollection.doc(reply.replyId).set(newReply).then((value) {
          final commentCollection = firebaseFirestore
              .collection(FirebaseConst.posts)
              .doc(reply.postId)
              .collection(FirebaseConst.comment)
              .doc(reply.commentId);

          commentCollection.get().then((value) {
            if (value.exists) {
              final totalReplys = value.get('totalReplys');
              commentCollection.update({"totalReplys": totalReplys + 1});
              return;
            }
          });
        });
      } else {
        await replyCollection.doc(reply.replyId).update(newReply);
      }
    } catch (e) {
      debugPrint("some error occured $e");
    }
  }

  @override
  Future<void> deleteReply(ReplyEntity reply) async {
    final replyCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .doc(reply.postId)
        .collection(FirebaseConst.comment)
        .doc(reply.commentId)
        .collection(FirebaseConst.reply);

    try {
      await replyCollection.doc(reply.replyId).delete().then((value) {
        final commentCollection = firebaseFirestore
            .collection(FirebaseConst.posts)
            .doc(reply.postId)
            .collection(FirebaseConst.comment)
            .doc(reply.commentId);

        commentCollection.get().then((value) {
          if (value.exists) {
            final totalReplys = value.get('totalReplys');
            commentCollection.update({"totalReplys": totalReplys - 1});
            return;
          }
        });
      });
    } catch (e) {
      ApplicationHelpers().trackAPIEvent(
        'COMMEN_SCREEN',
        'COMMENT',
        'WARNING',
        "some error occured $e",
      );
    }
  }

  @override
  Future<void> likeReply(ReplyEntity reply) async {
    final replyCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .doc(reply.postId)
        .collection(FirebaseConst.comment)
        .doc(reply.commentId)
        .collection(FirebaseConst.reply);

    final currentUid = await getCurrentUid();

    final replyRef = await replyCollection.doc(reply.replyId).get();

    if (replyRef.exists) {
      final List likes = replyRef.get(RemoteDbConstants.likes);
      if (likes.contains(currentUid)) {
        await replyCollection.doc(reply.replyId).update({
          RemoteDbConstants.likes: FieldValue.arrayRemove([currentUid])
        });
      } else {
        await replyCollection.doc(reply.replyId).update({
          "likes": FieldValue.arrayUnion([currentUid])
        });
      }
    }
  }

  @override
  Stream<List<ReplyEntity>> readReplys(ReplyEntity reply) {
    final replyCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .doc(reply.postId)
        .collection(FirebaseConst.comment)
        .doc(reply.commentId)
        .collection(FirebaseConst.reply);
    return replyCollection.snapshots().map(
          (querySnapshot) => querySnapshot.docs.map((e) => ReplyModel.fromSnapshot(e)).toList(),
        );
  }

  @override
  Future<void> updateReply(ReplyEntity reply) async {
    final replyCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .doc(reply.postId)
        .collection(FirebaseConst.comment)
        .doc(reply.commentId)
        .collection(FirebaseConst.reply);

    Map<String, dynamic> replyInfo = {};

    if (reply.description != emptyString && reply.description != null) {
      replyInfo['description'] = reply.description;
    }

    await replyCollection.doc(reply.replyId).update(replyInfo);
  }

  @override
  Future<void> followUnFollowUser(UserEntity user) async {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users);

    try {
      final myDocRef = await userCollection.doc(user.uid).get();
      final otherUserDocRef = await userCollection.doc(user.otherUid).get();

      if (myDocRef.exists && otherUserDocRef.exists) {
        List? myFollowingList = myDocRef.get(followingText);
        List? otherUserFollowersList = otherUserDocRef.get(followersText);

        myFollowingList ??= [];
        otherUserFollowersList ??= [];

        // My Following List
        if (myFollowingList.contains(user.otherUid)) {
          await userCollection.doc(user.uid).update({
            followingText: FieldValue.arrayRemove([user.otherUid])
          }).then((value) {
            final userCollection = firebaseFirestore.collection(FirebaseConst.users).doc(user.uid);

            userCollection.get().then((value) {
              if (value.exists) {
                final totalFollowing = value.get('totalFollowing');
                userCollection.update({"totalFollowing": totalFollowing - 1});
                return;
              }
            });
          });
        } else {
          await userCollection.doc(user.uid).update({
            followingText: FieldValue.arrayUnion([user.otherUid])
          }).then((value) {
            final userCollection = firebaseFirestore.collection(FirebaseConst.users).doc(user.uid);

            userCollection.get().then((value) {
              if (value.exists) {
                final totalFollowing = value.get('totalFollowing');
                userCollection.update({"totalFollowing": totalFollowing + 1});
                return;
              }
            });
          });
        }

        // Other User Following List
        if (otherUserFollowersList.contains(user.uid)) {
          await userCollection.doc(user.otherUid).update({
            followersText: FieldValue.arrayRemove([user.uid])
          }).then((value) {
            final userCollection = firebaseFirestore.collection(FirebaseConst.users).doc(user.otherUid);

            userCollection.get().then((value) {
              if (value.exists) {
                final totalFollowers = value.get('totalFollowers');
                userCollection.update({"totalFollowers": totalFollowers - 1});
                return;
              }
            });
          });
        } else {
          await userCollection.doc(user.otherUid).update({
            followersText: FieldValue.arrayUnion([user.uid])
          }).then((value) {
            final userCollection = firebaseFirestore.collection(FirebaseConst.users).doc(user.otherUid);

            userCollection.get().then((value) {
              if (value.exists) {
                final totalFollowers = value.get('totalFollowers');
                userCollection.update({"totalFollowers": totalFollowers + 1});
                return;
              }
            });
          });
        }
      }
    } catch (e) {
      ApplicationHelpers().trackAPIEvent(
        'FOLLOW_UN_FOLLOW_USER',
        'FOLLOW_UN_FOLLOW_USER',
        'ERROR',
        "Error in followUnFollowUser: $e",
      );
    }
  }

  @override
  Stream<List<UserEntity>> getSingleOtherUser(String otherUid) {
    final userCollection =
        firebaseFirestore.collection(FirebaseConst.users).where(Const.uid, isEqualTo: otherUid).limit(1);
    return userCollection.snapshots().map(
          (querySnapshot) => querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList(),
        );
  }
}
