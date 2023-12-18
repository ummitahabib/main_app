import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/features/domain/entities/posts/post_entity.dart';
import 'package:smat_crow/features/domain/entities/user/user_entity.dart';
import 'package:smat_crow/features/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:smat_crow/features/presentation/pages/credential/signin/signin.dart';
import 'package:smat_crow/features/presentation/pages/post/post_detail_page.dart';
import 'package:smat_crow/features/presentation/pages/profile/followers_page.dart';
import 'package:smat_crow/features/presentation/pages/profile/following_page.dart';
import 'package:smat_crow/features/presentation/pages/profile/widgets/edit_profile_show_model.dart';
import 'package:smat_crow/features/presentation/provider/get_other_users.dart';
import 'package:smat_crow/features/presentation/provider/post/post_state.dart';
import 'package:smat_crow/features/presentation/provider/user_state.dart';
import 'package:smat_crow/features/presentation/widgets/button_container_widget.dart';
import 'package:smat_crow/features/widgets/custom_button.dart';
import 'package:smat_crow/utils2/AppHelper.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/profile_widget.dart';
import 'package:smat_crow/utils2/service_locator.dart' as di;
import 'package:smat_crow/utils2/spacing_constants.dart';

class SingleUserProfileMainWidget extends StatefulWidget {
  final String otherUserId;
  const SingleUserProfileMainWidget({Key? key, required this.otherUserId})
      : super(key: key);

  @override
  State<SingleUserProfileMainWidget> createState() =>
      _SingleUserProfileMainWidgetState();
}

class _SingleUserProfileMainWidgetState
    extends State<SingleUserProfileMainWidget> {
  String _currentUid = "";
  ApplicationHelpers appHelpers = ApplicationHelpers();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GetSingleOtherUserProvider>(context, listen: false)
          .getSingleOtherUser(otherUid: widget.otherUserId);
      Provider.of<PostProvider>(context, listen: false)
          .getPosts(post: const PostEntity());
    });
    super.initState();

    di.locator<GetCurrentUidUseCase>().call().then((value) {
      setState(() {
        _currentUid = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GetSingleOtherUserProvider>(
      builder: (context, userState, _) {
        if (userState.status == GetSingleOtherUserProviderStatus.loaded) {
          final singleUser = userState.otherUser;
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                "${singleUser!.email}",
                style: const TextStyle(color: Colors.black),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SpacingConstants.size10,
                vertical: SpacingConstants.size10,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      child: Center(
                        child: Container(
                          width: SpacingConstants.size342,
                          height: SpacingConstants.size312,
                          decoration: BoxDecoration(
                            color: AppColors.SmatCrowDefaultWhite,
                            borderRadius:
                                BorderRadius.circular(SpacingConstants.size24),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: SpacingConstants.size34,
                                ),
                                child: SizedBox(
                                  width: 274,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: SpacingConstants.size15,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              SpacingConstants.size40,
                                            ),
                                            border: Border.all(
                                              color:
                                                  AppColors.SmatCrowPrimary500,
                                              width: 1.875,
                                            ),
                                          ),
                                          width: SpacingConstants.size70,
                                          height: SpacingConstants.size70,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              SpacingConstants.size40,
                                            ),
                                            child: profileWidget(
                                              imageUrl: singleUser.profileUrl ??
                                                  doubleEmptyString,
                                            ),
                                          ),
                                        ),
                                      ),
                                      customSizedBoxHeight(
                                        SpacingConstants.size15,
                                      ),
                                      Text(
                                        "${singleUser.firstName} ${singleUser.lastName}",
                                        style: const TextStyle(
                                          color: AppColors.SmatCrowDefaultBlack,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "${singleUser.email}",
                                        style: const TextStyle(
                                          color: AppColors.SmatCrowDefaultBlack,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      customSizedBoxHeight(
                                        SpacingConstants.size28,
                                      ),
                                      SizedBox(
                                        width: SpacingConstants.size274,
                                        height: SpacingConstants.size49,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  "${singleUser.totalPosts}",
                                                  style: const TextStyle(
                                                    color: AppColors
                                                        .SmatCrowDefaultBlack,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                customSizedBoxHeight(
                                                  SpacingConstants.size8,
                                                ),
                                                const Text(
                                                  "Posts",
                                                  style: TextStyle(
                                                    color: AppColors
                                                        .SmatCrowDefaultBlack,
                                                  ),
                                                )
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                ApplicationHelpers()
                                                    .trackButtonAndDeviceEvent(
                                                  'NAVIGATE_TO_FOLLOWERS_SCREEN',
                                                );

                                                appHelpers.navigationHelper(
                                                  context,
                                                  FollowersPage(
                                                    user: singleUser,
                                                  ),
                                                );
                                              },
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "${singleUser.totalFollowers}",
                                                    style: const TextStyle(
                                                      color: AppColors
                                                          .SmatCrowDefaultBlack,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  customSizedBoxHeight(
                                                    SpacingConstants.size8,
                                                  ),
                                                  const Text(
                                                    "Followers",
                                                    style: TextStyle(
                                                      color: AppColors
                                                          .SmatCrowDefaultBlack,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                ApplicationHelpers()
                                                    .trackButtonAndDeviceEvent(
                                                  'NAVIGATE_TO_FOLLOWING_PAGE',
                                                );

                                                appHelpers.navigationHelper(
                                                  context,
                                                  FollowingPage(
                                                    user: singleUser,
                                                  ),
                                                );
                                              },
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "${singleUser.totalFollowing}",
                                                    style: const TextStyle(
                                                      color: AppColors
                                                          .SmatCrowDefaultBlack,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  customSizedBoxHeight(8),
                                                  const Text(
                                                    "Following",
                                                    style: TextStyle(
                                                      color: AppColors
                                                          .SmatCrowDefaultBlack,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      customSizedBoxHeight(30),
                                      if (_currentUid == singleUser.uid)
                                        Positioned(
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () {
                                              openCustomDialog(context);
                                            },
                                            child: Container(
                                              width: 299,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: AppColors.transperant,
                                                border: Border.all(
                                                  color: AppColors
                                                      .SmatCrowPrimary500,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  SpacingConstants.size8,
                                                ),
                                              ),
                                              child: const Center(
                                                child: Text('Edit Profile'),
                                              ),
                                            ),
                                          ),
                                        )
                                      else
                                        Container(),
                                      customSizedBoxHeight(
                                        SpacingConstants.size10,
                                      ),
                                      if (_currentUid == singleUser.uid)
                                        Container()
                                      else
                                        Row(
                                          children: [
                                            ButtonContainerWidget(
                                              text: singleUser.followers!
                                                      .contains(_currentUid)
                                                  ? "UnFollow"
                                                  : "Follow",
                                              color: singleUser.followers!
                                                      .contains(_currentUid)
                                                  ? AppColors.SmatCrowNeuBlue500
                                                  : AppColors
                                                      .SmatCrowPrimary500,
                                              onTapListener: () {
                                                Provider.of<UserProvider>(
                                                  context,
                                                  listen: false,
                                                ).followUnFollowUser(
                                                  user: UserEntity(
                                                    uid: _currentUid,
                                                    otherUid:
                                                        widget.otherUserId,
                                                  ),
                                                );
                                              },
                                            ),
                                            customSizedBoxWidth(
                                                SpacingConstants.size10),
                                            ButtonContainerWidget(
                                              text: singleUser.followers!
                                                      .contains(_currentUid)
                                                  ? "Add to Comm."
                                                  : "Add to Comm.",
                                              color: singleUser.followers!
                                                      .contains(_currentUid)
                                                  ? AppColors.SmatCrowNeuBlue500
                                                      .withOpacity(0.5)
                                                  : AppColors
                                                      .SmatCrowPrimary500,
                                              onTapListener: () {
                                                Provider.of<UserProvider>(
                                                  context,
                                                  listen: false,
                                                ).followUnFollowUser(
                                                  user: UserEntity(
                                                    uid: _currentUid,
                                                    otherUid:
                                                        widget.otherUserId,
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    customSizedBoxHeight(SpacingConstants.size10),
                    Text(
                      "${singleUser.firstName == "" ? singleUser.email : singleUser.firstName}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    customSizedBoxHeight(SpacingConstants.size10),
                    Consumer<PostProvider>(
                      builder: (context, postState, _) {
                        if (postState.status == PostProviderStatus.loaded) {
                          final posts = postState.posts
                              .where(
                                (post) => post.creatorUid == widget.otherUserId,
                              )
                              .toList();
                          return GridView.builder(
                            itemCount: posts.length,
                            physics: const ScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                            ),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PostDetailPage(
                                        postId: posts[index].postId!,
                                      ),
                                    ),
                                  );
                                },
                                child: SizedBox(
                                  width: SpacingConstants.size100,
                                  height: SpacingConstants.size100,
                                  child: profileWidget(
                                    imageUrl: posts[index].postImageUrl,
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Future<void> openCustomDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Spacer(),
            Dialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                ),
              ),
              backgroundColor: Colors.white,
              child: SizedBox(
                width: 390.0,
                height: 532.0,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: SpacingConstants.size24,
                        right: SpacingConstants.size24,
                        top: SpacingConstants.size48,
                      ),
                      child: SizedBox(
                        width: 342,
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          children: [
                            ProfileOptionsWidget(
                              onTap: () {
                                ApplicationHelpers().trackButtonAndDeviceEvent(
                                  'NAVIGATE_TO_EDIT_PROFILE',
                                );

                                ApplicationHelpers().reRouteUser(
                                  context,
                                  ConfigRoute.editProfilePage,
                                  emptyString,
                                );
                              },
                            ),
                            const ProfileOptionsWidget(
                              text: 'Edit Password',
                              icon: Icon(
                                EvaIcons.lockOutline,
                                color: AppColors.SmatCrowPrimary500,
                                size: SpacingConstants.size24,
                              ),
                            ),
                            const ProfileOptionsWidget(
                              text: 'Manage Subscriptions',
                              icon: Icon(
                                EvaIcons.paperPlaneOutline,
                                color: AppColors.SmatCrowPrimary500,
                                size: SpacingConstants.size24,
                              ),
                            ),
                            const ProfileOptionsWidget(
                              text: 'Help Center',
                              icon: Icon(
                                EvaIcons.infoOutline,
                                color: AppColors.SmatCrowPrimary500,
                                size: SpacingConstants.size24,
                              ),
                            ),
                            customSizedBoxHeight(SpacingConstants.size88),
                            CustomButton(
                              text: 'Log out',
                              onPressed: () {
                                ApplicationHelpers().trackButtonAndDeviceEvent(
                                  'LOG_OUT_BUTTON_CLCIKED',
                                );
                                ApplicationHelpers().navigationHelper(
                                  context,
                                  const SigninPage(),
                                );
                              },
                              color: AppColors.SmatCrowRed50,
                              textColor: AppColors.SmatCrowRed500,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
