import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/features/presentation/widgets/loading_state_widget.dart';
import 'package:smat_crow/utils2/assets/shared/shared/splash/splash_assets.dart';
import 'package:smat_crow/utils2/constants.dart';

Widget profileWidget({String? imageUrl, Uint8List? image}) {
  if (image == null) {
    if (imageUrl == null || imageUrl == doubleEmptyString) {
      return profileImage();
    } else {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, downloadProgress) {
          return const LoadingStateWidget();
        },
        errorWidget: (context, url, error) => profileImage(),
      );
    }
  } else {
    return Image.memory(
      image,
      fit: BoxFit.cover,
    );
  }
}
