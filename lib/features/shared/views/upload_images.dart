// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/app_container.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class UploadImage extends HookConsumerWidget {
  const UploadImage({
    super.key,
    required this.loading,
    this.subtitle,
    required this.title,
    required this.function,
    required this.value,
  });

  final bool loading;
  final String? subtitle;
  final String title;
  final ValueNotifier<List<String>> value;
  final VoidCallback function;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: function,
      child: AppContainer(
        padding: EdgeInsets.symmetric(
          horizontal: value.value.isEmpty ? SpacingConstants.size40 : SpacingConstants.size20,
          vertical: value.value.isEmpty ? SpacingConstants.size34 : SpacingConstants.size20,
        ),
        width: Responsive.xWidth(context),
        child: loading
            ? const SizedBox(
                width: SpacingConstants.size20,
                height: SpacingConstants.size20,
                child: CupertinoActivityIndicator(),
              )
            : value.value.isEmpty
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        AppAssets.weatherInfo,
                        color: AppColors.SmatCrowNeuBlue900,
                      ),
                      customSizedBoxHeight(SpacingConstants.size20),
                      Text(
                        title,
                        style: Styles.smatCrowMediumSubParagraph(
                          color: Colors.black,
                        ).copyWith(fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      customSizedBoxHeight(SpacingConstants.size10),
                      Text(
                        subtitle ?? uploadWarning,
                        style: Styles.smatCrowCaptionRegular(
                          color: AppColors.SmatCrowNeuBlue500,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  )
                : Column(
                    children: [
                      SvgPicture.asset(
                        AppAssets.weatherInfo,
                        color: AppColors.SmatCrowNeuBlue900,
                      ),
                      Text(
                        title,
                        style: Styles.smatCrowMediumSubParagraph(
                          color: Colors.black,
                        ).copyWith(fontWeight: FontWeight.bold),
                        maxLines: SpacingConstants.int2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      customSizedBoxHeight(SpacingConstants.size20),
                      Wrap(
                        spacing: SpacingConstants.font10,
                        runSpacing: SpacingConstants.font10,
                        children: [
                          ...value.value.map(
                            (e) => Container(
                              height: SpacingConstants.size61,
                              width: SpacingConstants.size61,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(e),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(
                                  SpacingConstants.font10,
                                ),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  value.value.remove(e);
                                  value.notifyListeners();
                                },
                                child: const Icon(Icons.clear),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: function,
                            child: Container(
                              height: SpacingConstants.size61,
                              width: SpacingConstants.size61,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  SpacingConstants.font10,
                                ),
                                color: AppColors.SmatCrowNeuBlue100,
                              ),
                              child: const Center(
                                child: Icon(Icons.add),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
      ),
    );
  }
}
