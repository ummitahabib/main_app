import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/features/domain/entities/posts/post_entity.dart';
import 'package:smat_crow/features/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:smat_crow/features/presentation/pages/post/widget/app_bar_widget.dart';
import 'package:smat_crow/features/presentation/pages/socials/widgets/single_post_card_widget.dart';
import 'package:smat_crow/features/presentation/pages/stories/widgets/story_view_full_screen.dart';
import 'package:smat_crow/features/presentation/pages/stories/widgets/story_widget.dart';
import 'package:smat_crow/features/presentation/pages/stories/widgets/user_create_story.dart';
import 'package:smat_crow/features/presentation/provider/get_single_user.dart';
import 'package:smat_crow/features/presentation/provider/post/post_state.dart';
import 'package:smat_crow/features/presentation/provider/stories_provider.dart';
import 'package:smat_crow/features/presentation/widgets/loading_state_widget.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/AppHelper.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/service_locator.dart' as di;
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class SocialHomePage extends StatefulWidget {
  const SocialHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<SocialHomePage> createState() => _SocialHomePageState();
}

class _SocialHomePageState extends State<SocialHomePage> {
  GetSingleUserProvider? _userProvider;

  ApplicationHelpers appHelper = ApplicationHelpers();

  String _currentUid = emptyString;

  String get currentUid => _currentUid;

  set currentUid(String value) {
    setState(() {
      _currentUid = value;
    });
  }

  @override
  void initState() {
    Pandora().getFromSharedPreferences(Const.uid).then((value) async {
      await Provider.of<GetSingleUserProvider>(context, listen: false)
          .getSingleUser();
    });

    Provider.of<StoryProviders>(context, listen: false).init();

    di.locator<GetCurrentUidUseCase>().call().then((value) {
      setState(() {
        _currentUid = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final storyController = Provider.of<StoryProviders>(context, listen: false);

    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const AppBarWidget(),
              SizedBox(
                height: size.height * SpacingConstants.size0point13,
                child: Padding(
                  padding: const EdgeInsets.only(left: SpacingConstants.size24),
                  child: Row(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _userProvider?.user != null
                              ? storyController.stories.length +
                                  SpacingConstants.int1
                              : storyController.stories.length,
                          itemBuilder: (context, index) {
                            try {
                              if (_userProvider?.user != null &&
                                  index == SpacingConstants.int0) {
                                final userUrl =
                                    _userProvider?.user!.profileUrl ??
                                        emptyString;
                                return UserStoryWidget(
                                  image: userUrl,
                                  onTap: () {
                                    appHelper.trackButtonAndDeviceEvent(
                                      'NAVIGATE_TO_STORY_VIEW_FULL_SCREEN',
                                    );
                                    appHelper.navigationHelper(
                                      context,
                                      StoryViewFullScreen(
                                        stories: [
                                          storyController
                                              .stories[SpacingConstants.int0]
                                        ],
                                      ),
                                    );
                                  },
                                );
                              } else {
                                if (_userProvider?.user != null) {
                                  return const SizedBox(
                                    height: SpacingConstants.size0,
                                    width: SpacingConstants.size0,
                                  );
                                } else {
                                  final storyIndex =
                                      index - SpacingConstants.int1;
                                  final story =
                                      storyController.stories[storyIndex];
                                  return StoryWidget(
                                    name: story.userName ?? emptyString,
                                    image: story.userUrl ?? emptyString,
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              StoryViewFullScreen(
                                            stories: [story],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                              }
                            } catch (e) {
                              return const SizedBox(
                                height: SpacingConstants.size0,
                                width: SpacingConstants.size0,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ChangeNotifierProvider<PostProvider>(
                create: (context) => di.locator<PostProvider>()
                  ..getPosts(post: const PostEntity()),
                child: Consumer<PostProvider>(
                  builder: (context, postState, _) {
                    try {
                      if (postState.status == PostProviderStatus.loading) {
                        return const Center(child: LoadingStateWidget());
                      }
                      if (postState.status == PostProviderStatus.failure) {}
                      if (postState.status == PostProviderStatus.loaded) {
                        if (_userProvider?.user != null) {
                          return postState.posts.isEmpty
                              ? _noPostsYetWidget()
                              : SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child: ListView.builder(
                                    itemCount: postState.posts.length,
                                    itemBuilder: (context, index) {
                                      final post = postState.posts[index];
                                      return SinglePostCardWidget(
                                        post: post,
                                      );
                                    },
                                  ),
                                );
                        } else {
                          return const Text(userDoesNotExist);
                        }
                      }
                    } catch (error) {
                      return const Center(
                        child: Text(errorOccured),
                      );
                    }

                    return const Center(
                      child: LoadingStateWidget(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Center _noPostsYetWidget() {
    return Center(
      child: Styles.noPostTextStyle(),
    );
  }
}
