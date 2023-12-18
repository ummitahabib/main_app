import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/features/presentation/widgets/loading_state_widget.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class StoryWidget extends StatelessWidget {
  const StoryWidget({
    Key? key,
    required this.image,
    required this.name,
    required this.onTap,
  }) : super(key: key);
  final String name;
  final String image;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: SpacingConstants.size8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StoryCircleImage(image: image),
            const SizedBox(
              height: SpacingConstants.size5,
            ),
            Text(
              name,
              style: const TextStyle(
                color: AppColors.SmatCrowDefaultBlack,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class StoryCircleImage extends StatelessWidget {
  const StoryCircleImage({
    super.key,
    required this.image,
  });

  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SpacingConstants.double01),
      width: SpacingConstants.size50,
      height: SpacingConstants.size50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.SmatCrowPrimary500,
          width: SpacingConstants.size1point5,
        ),
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: image,
          fit: BoxFit.cover,
          placeholder: (context, url) => const LoadingStateWidget(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }
}
