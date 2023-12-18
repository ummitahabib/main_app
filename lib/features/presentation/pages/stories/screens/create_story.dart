import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/features/presentation/pages/stories/widgets/story_widget.dart';
import 'package:smat_crow/features/presentation/provider/get_single_user.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils2/decoration.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class CreateStory extends StatelessWidget {
  const CreateStory({Key? key, required this.onTap}) : super(key: key);
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final getSingleUserProvider = Provider.of<GetSingleUserProvider>(context, listen: false);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: <Widget>[
                StoryCircleImage(
                  image:
                      getSingleUserProvider.user == null ? DEFAULT_IMAGE : getSingleUserProvider.user!.profileUrl ?? "",
                ),
                Positioned(
                  bottom: SpacingConstants.size0,
                  right: -1,
                  child: storyAddWidget(),
                )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'My Story',
              style: TextStyle(
                color: Colors.black.withOpacity(.8),
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}
