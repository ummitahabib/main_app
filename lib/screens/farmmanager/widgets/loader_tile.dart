import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LoaderTileLarge extends StatelessWidget {
  const LoaderTileLarge({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: CustomFeaturedItem(),
    );
  }
}

class CustomFeaturedItem extends StatelessWidget {
  const CustomFeaturedItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[500],
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
