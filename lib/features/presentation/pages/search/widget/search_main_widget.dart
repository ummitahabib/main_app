import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/features/domain/entities/posts/post_entity.dart';
import 'package:smat_crow/features/domain/entities/user/user_entity.dart';
import 'package:smat_crow/features/presentation/pages/post/post_detail_page.dart';
import 'package:smat_crow/features/presentation/pages/profile/single_user_profile_page.dart';
import 'package:smat_crow/features/presentation/pages/search/widget/search_widget.dart';
import 'package:smat_crow/features/presentation/provider/post/post_state.dart';
import 'package:smat_crow/features/presentation/provider/user_state.dart';
import 'package:smat_crow/features/presentation/widgets/loading_state_widget.dart';
import 'package:smat_crow/utils2/AppHelper.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/profile_widget.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class SearchMainWidget extends StatefulWidget {
  const SearchMainWidget({Key? key}) : super(key: key);

  @override
  State<SearchMainWidget> createState() => _SearchMainWidgetState();
}

class _SearchMainWidgetState extends State<SearchMainWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false)
          .getUsers(user: const UserEntity());
      Provider.of<PostProvider>(context, listen: false)
          .getPosts(post: const PostEntity());
    });
    super.initState();

    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<UserProvider>(
          builder: (context, userState, _) {
            if (userState.status == UserProviderStatus.loaded) {
              try {
                final filterAllUsers = userState.users
                    .where(
                      (user) =>
                          user.email!.startsWith(_searchController.text) ||
                          user.email!.toLowerCase().startsWith(
                                _searchController.text.toLowerCase(),
                              ) ||
                          user.email!.contains(_searchController.text) ||
                          user.email!
                              .toLowerCase()
                              .contains(_searchController.text.toLowerCase()),
                    )
                    .toList();
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SpacingConstants.size10,
                    vertical: SpacingConstants.size10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SearchWidget(
                        controller: _searchController,
                      ),
                      customSizedBoxHeight(SpacingConstants.size10),
                      if (_searchController.text.isNotEmpty)
                        Expanded(
                          child: ListView.builder(
                            itemCount: filterAllUsers.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  ApplicationHelpers()
                                      .trackButtonAndDeviceEvent(
                                    'NAVIGATE_TO_SINGLE_USER_PROFILE',
                                  );
                                  ApplicationHelpers().navigationHelper(
                                    context,
                                    SingleUserProfilePage(
                                      otherUserId: filterAllUsers[index].uid!,
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: SpacingConstants.size10,
                                      ),
                                      width: SpacingConstants.size40,
                                      height: SpacingConstants.size40,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          SpacingConstants.size20,
                                        ),
                                        child: profileWidget(
                                          imageUrl:
                                              filterAllUsers[index].profileUrl,
                                        ),
                                      ),
                                    ),
                                    customSizedBoxWidth(
                                      SpacingConstants.size10,
                                    ),
                                    Text(
                                      "${filterAllUsers[index].email}",
                                      style: Styles.smatCrowMediumCaption(
                                        AppColors.SmatCrowNeuBlue900,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      else
                        Consumer<PostProvider>(
                          builder: (context, postState, _) {
                            if (postState.status == PostProviderStatus.loaded) {
                              final posts = postState.posts;
                              return Expanded(
                                child: GridView.builder(
                                  itemCount: posts.length,
                                  physics: const ScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: SpacingConstants.int3,
                                    crossAxisSpacing: SpacingConstants.size5,
                                    mainAxisSpacing: SpacingConstants.size5,
                                  ),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        ApplicationHelpers()
                                            .trackButtonAndDeviceEvent(
                                          'NAVIGATE_TO_POST_DETAIL_PAGE',
                                        );
                                        ApplicationHelpers().navigationHelper(
                                          context,
                                          PostDetailPage(
                                            postId: posts[index].postId!,
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
                                ),
                              );
                            }
                            return const Center(
                              child: LoadingStateWidget(),
                            );
                          },
                        )
                    ],
                  ),
                );
              } catch (error) {
                ApplicationHelpers().trackAPIEvent(
                  'SEARCH',
                  'SEARCH_USER',
                  'ERROR',
                  "Error in search: $error",
                );
              }
            }
            return const Center(
              child: LoadingStateWidget(),
            );
          },
        ),
      ),
    );
  }
}
