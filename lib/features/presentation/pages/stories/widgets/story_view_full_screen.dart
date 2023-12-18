import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/features/data/models/story/stories_model.dart';
import 'package:smat_crow/features/presentation/provider/stories_provider.dart';
import 'package:smat_crow/utils2/AppHelper.dart';

class StoryViewFullScreen extends StatefulWidget {
  final List<Story> stories;

  const StoryViewFullScreen({Key? key, required this.stories}) : super(key: key);

  @override
  State<StoryViewFullScreen> createState() => _StoryViewFullScreenState();
}

class _StoryViewFullScreenState extends State<StoryViewFullScreen> {
  //late StoryController controller;
  int currentStoryIndex = 0;
  Map<int, List<String>> viewersMap = {};

  @override
  void initState() {
    super.initState();
    //   controller = StoryController();
  }

  void onStoryChanged(int index) {
    setState(() {
      currentStoryIndex = index;
    });
  }

  void onDeletePressed(int index) {
    final storyUrlToDelete = widget.stories[index].url![0];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this story?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<StoryProviders>(context, listen: false).deleteStory(storyUrlToDelete).then((_) {
                  setState(() {
                    widget.stories.removeAt(index);
                    if (currentStoryIndex >= widget.stories.length) {
                      currentStoryIndex = widget.stories.length - 1;
                    }
                  });

                  ApplicationHelpers().routeBack(context);
                });
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void onStoryShow() {
    final currentViewers = viewersMap[currentStoryIndex] ?? [];
    if (!currentViewers.contains('viewer_name')) {
      setState(() {
        currentViewers.add('viewer_name');
      });
    }
  }

  void showViewerList() {
    final currentViewers = viewersMap[currentStoryIndex] ?? [];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Viewers'),
          content: currentViewers.isEmpty
              ? const Text('No one has viewed this story yet.')
              : Column(
                  children: [
                    Text('Total views: ${currentViewers.length}'),
                    const SizedBox(height: 10),
                    ListView.builder(
                      itemCount: currentViewers.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(currentViewers[index]),
                        );
                      },
                    ),
                  ],
                ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget buildStoryItem(int index) {
    final Story story = widget.stories[index];

    return Stack(
      children: [
        // StoryView(
        //   storyItems: story.url
        //           ?.map(
        //             (element) => StoryItem.pageImage(
        //               url: element,
        //               controller: controller,
        //             ),
        //           )
        //           .toList() ??
        //       [],
        //   controller: controller,
        //   onComplete: () {
        //     setState(() {
        //       if (currentStoryIndex < widget.stories.length - 1) {
        //         currentStoryIndex++;
        //       } else {
        //         Navigator.of(context).pop();
        //       }
        //     });
        //   },
        // ),
        Positioned(
          top: 10,
          right: 10,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.remove_red_eye,
                  color: Colors.white,
                ),
                onPressed: () {
                  onStoryShow();
                  showViewerList();
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.white,
                ),
                onPressed: () {
                  onDeletePressed(index);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            itemCount: widget.stories.length,
            controller: PageController(
              initialPage: currentStoryIndex,
            ),
            onPageChanged: (index) {
              onStoryChanged(index);
            },
            itemBuilder: (context, index) {
              return buildStoryItem(index);
            },
          ),
        ],
      ),
    );
  }
}
