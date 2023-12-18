import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:smat_crow/features/data/data_sources/remote_data_source.dart';
import 'package:smat_crow/features/data/data_sources/remote_data_source_impl.dart';
import 'package:smat_crow/features/data/repository/authentication_repository.dart';
import 'package:smat_crow/features/data/repository/firebase_repository_impl.dart';
import 'package:smat_crow/features/domain/repository/firebase_repository.dart';
import 'package:smat_crow/features/domain/usecases/comment/create_comment_usecase.dart';
import 'package:smat_crow/features/domain/usecases/comment/delete_comment_usecase.dart';
import 'package:smat_crow/features/domain/usecases/comment/like_comment_usecase.dart';
import 'package:smat_crow/features/domain/usecases/comment/read_comment_usecase.dart';
import 'package:smat_crow/features/domain/usecases/comment/update_comment_usecase.dart';
import 'package:smat_crow/features/domain/usecases/firebase_usecases/news_use_case.dart';
import 'package:smat_crow/features/domain/usecases/firebase_usecases/upload_image_to_storage_usecase.dart';
import 'package:smat_crow/features/domain/usecases/firebase_usecases/user/create_user_usecase.dart';
import 'package:smat_crow/features/domain/usecases/firebase_usecases/user/follow_unfollow_user_usecase.dart';
import 'package:smat_crow/features/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:smat_crow/features/domain/usecases/firebase_usecases/user/get_single_other_users_usecase.dart';
import 'package:smat_crow/features/domain/usecases/firebase_usecases/user/get_single_user_usecase.dart';
import 'package:smat_crow/features/domain/usecases/firebase_usecases/user/get_users_usecase.dart';
import 'package:smat_crow/features/domain/usecases/firebase_usecases/user/is_sign_in_usecase.dart';
import 'package:smat_crow/features/domain/usecases/firebase_usecases/user/sign_in_user_usecase.dart';
import 'package:smat_crow/features/domain/usecases/firebase_usecases/user/sign_out_usecase.dart';
import 'package:smat_crow/features/domain/usecases/firebase_usecases/user/sign_up_user_usecase.dart';
import 'package:smat_crow/features/domain/usecases/firebase_usecases/user/update_user_usecase.dart';
import 'package:smat_crow/features/domain/usecases/post/create_post_usecase.dart';
import 'package:smat_crow/features/domain/usecases/post/delete_post_usecase.dart';
import 'package:smat_crow/features/domain/usecases/post/like_post_usecase.dart';
import 'package:smat_crow/features/domain/usecases/post/read_posts_usecase.dart';
import 'package:smat_crow/features/domain/usecases/post/read_single_post_usecase.dart';
import 'package:smat_crow/features/domain/usecases/post/update_post_usecase.dart';
import 'package:smat_crow/features/domain/usecases/reply/create_reply_usecase.dart';
import 'package:smat_crow/features/domain/usecases/reply/delete_reply_usecase.dart';
import 'package:smat_crow/features/domain/usecases/reply/like_reply_usecase.dart';
import 'package:smat_crow/features/domain/usecases/reply/read_replys_usecase.dart';
import 'package:smat_crow/features/domain/usecases/reply/update_reply_usecase.dart';
import 'package:smat_crow/features/farm_manager/data/repository/farm_dashboard.dart';
import 'package:smat_crow/features/farm_manager/data/repository/farm_manager_repository.dart';
import 'package:smat_crow/features/institution/data/repository/institution_repository.dart';
import 'package:smat_crow/features/organisation/data/repository/batch_repository.dart';
import 'package:smat_crow/features/organisation/data/repository/organisation_repository.dart';
import 'package:smat_crow/features/organisation/data/repository/sector_repository.dart';
import 'package:smat_crow/features/organisation/data/repository/site_options_repositorty.dart';
import 'package:smat_crow/features/organisation/data/repository/site_repository.dart';
import 'package:smat_crow/features/organisation/data/repository/weather_soil_repository.dart';
import 'package:smat_crow/features/presentation/provider/auth_provider.dart';
import 'package:smat_crow/features/presentation/provider/comment_state.dart';
import 'package:smat_crow/features/presentation/provider/credentials.dart';
import 'package:smat_crow/features/presentation/provider/get_other_users.dart';
import 'package:smat_crow/features/presentation/provider/get_single_user.dart';
import 'package:smat_crow/features/presentation/provider/news_provider.dart';
import 'package:smat_crow/features/presentation/provider/post/get_single_post/get_single_post.dart';
import 'package:smat_crow/features/presentation/provider/post/post_state.dart';
import 'package:smat_crow/features/presentation/provider/reply_provider.dart';
import 'package:smat_crow/features/presentation/provider/user_state.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/features/shared/data/repository/assets_repository.dart';
import 'package:smat_crow/features/shared/data/repository/logs_repository.dart';
import 'package:smat_crow/features/shared/data/repository/shared_repository.dart';
import 'package:smat_crow/utils2/api_client.dart';

final locator = GetIt.instance;

void setupLocator() {
  //API
  locator
    ..registerFactory<ApiClient>(() => ApiClient())
    ..registerSingleton<FirebaseAnalytics>(FirebaseAnalytics.instance)
    //Service
    ..registerLazySingleton<OrganizationRepostiory>(
      () => OrganizationRepostiory(),
    )
    ..registerLazySingleton<SiteRepository>(() => SiteRepository())
    ..registerLazySingleton<WeatherSoilRepository>(
      () => WeatherSoilRepository(),
    )
    ..registerLazySingleton<SectorRepository>(() => SectorRepository())
    ..registerLazySingleton<BatchRepository>(() => BatchRepository())
    ..registerLazySingleton<SiteOptionRepository>(() => SiteOptionRepository())
    ..registerLazySingleton<SharedRepository>(() => SharedRepository())
    ..registerLazySingleton<LogsRepository>(() => LogsRepository())
    ..registerLazySingleton<AssetsRepository>(() => AssetsRepository())
    ..registerLazySingleton<SharedNotifier>(() => SharedNotifier())
    ..registerLazySingleton<InstitutionRepository>(
      () => InstitutionRepository(),
    )
    ..registerLazySingleton<FarmManagerRepository>(
      () => FarmManagerRepository(),
    )
    ..registerLazySingleton<FarmDashboardRepository>(
      () => FarmDashboardRepository(),
    )
    ..registerLazySingleton<AuthenticationRepository>(
      () => AuthenticationRepository(),
    );

// Providers
  locator.registerFactory(
    () => AuthProvider(
      signOutUseCase: locator.call(),
      isSignInUseCase: locator.call(),
      getCurrentUidUseCase: locator.call(),
    ),
  );

  locator.registerFactory(
    () => CredentialProvider(
      signUpUseCase: locator.call(),
      signInUserUseCase: locator.call(),
      authenticationRepository: locator.call(),
    ),
  );

  locator.registerFactory(
    () => UserProvider(
      updateUserUseCase: locator.call(),
      getUsersUseCase: locator.call(),
      followUnFollowUseCase: locator.call(),
    ),
  );

  locator.registerFactory(
    () => GetSingleUserProvider(getSingleUserUseCase: locator.call()),
  );

  locator.registerFactory(
    () => GetSingleOtherUserProvider(getSingleOtherUserUseCase: locator.call()),
  );

  // Post Provider Injection
  locator.registerFactory(
    () => PostProvider(
      createPostUseCase: locator.call(),
      deletePostUseCase: locator.call(),
      likePostUseCase: locator.call(),
      readPostUseCase: locator.call(),
      updatePostUseCase: locator.call(),
    ),
  );

  locator.registerFactory(
    () => GetSinglePostProvider(readSinglePostUseCase: locator.call()),
  );

  // Comment Provider Injection
  locator.registerFactory(
    () => CommentProvider(
      createCommentUseCase: locator.call(),
      deleteCommentUseCase: locator.call(),
      likeCommentUseCase: locator.call(),
      readCommentsUseCase: locator.call(),
      updateCommentUseCase: locator.call(),
    ),
  );

  // Replay Provider Injection
  locator.registerFactory(
    () => ReplyProvider(
      createReplyUseCase: locator.call(),
      deleteReplyUseCase: locator.call(),
      likeReplyUseCase: locator.call(),
      readReplysUseCase: locator.call(),
      updateReplyUseCase: locator.call(),
    ),
  );

//News Provider

  locator.registerFactory(
    () => NewsProvider(firebaseRepository: locator.call()),
  );

  locator.registerLazySingleton(() => GetNewsUseCase(repository: locator.call()));

  // Use Cases
  // User
  locator.registerLazySingleton(() => SignOutUseCase(repository: locator.call()));
  locator.registerLazySingleton(() => IsSignInUseCase(repository: locator.call()));
  locator.registerLazySingleton(
    () => GetCurrentUidUseCase(repository: locator.call()),
  );
  locator.registerLazySingleton(() => SignUpUseCase(repository: locator.call()));
  locator.registerLazySingleton(
    () => SignInUserUseCase(repository: locator.call()),
  );
  locator.registerLazySingleton(
    () => UpdateUserUseCase(repository: locator.call()),
  );
  locator.registerLazySingleton(() => GetUsersUseCase(repository: locator.call()));
  locator.registerLazySingleton(
    () => CreateUserUseCase(repository: locator.call()),
  );
  locator.registerLazySingleton(
    () => GetSingleUserUseCase(repository: locator.call()),
  );
  locator.registerLazySingleton(
    () => FollowUnFollowUseCase(repository: locator.call()),
  );
  locator.registerLazySingleton(
    () => GetSingleOtherUserUseCase(repository: locator.call()),
  );

  // Cloud Storage
  locator.registerLazySingleton(
    () => UploadImageToStorageUseCase(repository: locator.call()),
  );

  // Post
  locator.registerLazySingleton(
    () => CreatePostUseCase(repository: locator.call()),
  );
  locator.registerLazySingleton(
    () => ReadPostsUseCase(repository: locator.call()),
  );
  locator.registerLazySingleton(() => LikePostUseCase(repository: locator.call()));
  locator.registerLazySingleton(
    () => UpdatePostUseCase(repository: locator.call()),
  );
  locator.registerLazySingleton(
    () => DeletePostUseCase(repository: locator.call()),
  );
  locator.registerLazySingleton(
    () => ReadSinglePostUseCase(repository: locator.call()),
  );

  // Comment
  locator.registerLazySingleton(
    () => CreateCommentUseCase(repository: locator.call()),
  );
  locator.registerLazySingleton(
    () => ReadCommentsUseCase(repository: locator.call()),
  );
  locator.registerLazySingleton(
    () => LikeCommentUseCase(repository: locator.call()),
  );
  locator.registerLazySingleton(
    () => UpdateCommentUseCase(repository: locator.call()),
  );
  locator.registerLazySingleton(
    () => DeleteCommentUseCase(repository: locator.call()),
  );

  // Replay
  locator.registerLazySingleton(
    () => CreateReplyUseCase(repository: locator.call()),
  );
  locator.registerLazySingleton(
    () => ReadReplysUseCase(repository: locator.call()),
  );
  locator.registerLazySingleton(
    () => LikeReplyUseCase(repository: locator.call()),
  );
  locator.registerLazySingleton(
    () => UpdateReplyUseCase(repository: locator.call()),
  );
  locator.registerLazySingleton(
    () => DeleteReplyUseCase(repository: locator.call()),
  );

  // Repository

  locator.registerLazySingleton<FirebaseRepository>(
    () => FirebaseRepositoryImpl(remoteDataSource: locator.call()),
  );

  // Remote Data Source
  locator.registerLazySingleton<FirebaseRemoteDataSource>(
    () => FirebaseRemoteDataSourceImpl(
      firebaseFirestore: locator.call(),
      firebaseAuth: locator.call(),
      firebaseStorage: locator.call(),
    ),
  );

  // Externals

  final firebaseFirestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseStorage = FirebaseStorage.instance;

  locator.registerLazySingleton(() => firebaseFirestore);
  locator.registerLazySingleton(() => firebaseAuth);
  locator.registerLazySingleton(() => firebaseStorage);
}

List repositories = [
  locator.get<OrganizationRepostiory>(),
  locator.get<SiteRepository>(),
  locator.get<SiteOptionRepository>(),
  locator.get<WeatherSoilRepository>(),
  locator.get<SectorRepository>(),
  locator.get<BatchRepository>(),
  locator.get<AuthenticationRepository>(),
  locator.get<SharedRepository>(),
  locator.get<LogsRepository>(),
  locator.get<AssetsRepository>(),
  locator.get<InstitutionRepository>(),
  locator.get<FarmManagerRepository>(),
  locator.get<FarmDashboardRepository>(),
];
