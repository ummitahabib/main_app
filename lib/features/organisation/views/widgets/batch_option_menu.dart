import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:smat_crow/features/organisation/data/controller/batch_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/map_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/navigation_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/site_controller.dart';
import 'package:smat_crow/features/shared/data/controller/firebase_controller.dart';

import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class BatchOptionMenu extends HookConsumerWidget {
  const BatchOptionMenu({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton(
      splashRadius: 20,
      position: PopupMenuPosition.under,
      offset: kIsWeb ? const Offset(-10, 0) : Offset.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 12,
      shadowColor: Colors.black.withOpacity(0.07),
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () {
            ref.read(firebaseProvider).downloadUrl = null;
            ref.read(organizationProvider).uploadToFirebase("organization/batch/images");
          },
          child: PointerInterceptor(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.add,
                  color: AppColors.SmatCrowNeuBlue900,
                ),
                const SizedBox(width: SpacingConstants.size5),
                Text(
                  addImage,
                  style: Styles.smatCrowSubParagraphRegular(color: AppColors.SmatCrowNeuBlue900),
                )
              ],
            ),
          ),
        ),
        PopupMenuItem(
          onTap: () {},
          child: PointerInterceptor(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  FontAwesomeIcons.circleCheck,
                  color: AppColors.SmatCrowNeuBlue900,
                ),
                const SizedBox(width: SpacingConstants.size5),
                Text(
                  selectImage,
                  style: Styles.smatCrowSubParagraphRegular(color: AppColors.SmatCrowNeuBlue900),
                )
              ],
            ),
          ),
        ),
        PopupMenuItem(
          onTap: () {
            if (kIsWeb) {
              pageController.jumpToPage(2);
            } else {
              pageController.jumpToPage(7);
            }
          },
          child: PointerInterceptor(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.border_color_outlined,
                  color: AppColors.SmatCrowNeuBlue900,
                ),
                const SizedBox(width: SpacingConstants.size5),
                Text(
                  editBatch,
                  style: Styles.smatCrowSubParagraphRegular(color: AppColors.SmatCrowNeuBlue900),
                )
              ],
            ),
          ),
        ),
        PopupMenuItem(
          onTap: () {
            _deleteBatchMethod(ref);
          },
          child: PointerInterceptor(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.delete_outline_outlined,
                  color: AppColors.SmatCrowRed500,
                ),
                const SizedBox(width: SpacingConstants.size5),
                Text(
                  deleteBatch,
                  style: Styles.smatCrowSubParagraphRegular(color: AppColors.SmatCrowRed500),
                )
              ],
            ),
          ),
        ),
      ],
      icon: const Icon(
        Icons.more_horiz,
        color: AppColors.SmatCrowPrimary300,
      ),
    );
  }

  void _deleteBatchMethod(WidgetRef ref) {
    if (ref.read(batchProvider).batch != null) {
      ref.read(batchProvider).deleteBatch(ref.read(batchProvider).batch!.id!);
      if (kIsWeb) {
        if (kIsWeb) {
          ref.read(orgNavigationProvider).mapPageController.jumpToPage(0);
          Future.delayed(
            const Duration(seconds: 1),
            () {
              ref.read(mapProvider).getSectorBounds();
            },
          );
        }
      } else {
        ref.read(siteProvider).subType = SubType.sector;
        pageController.jumpToPage(0);
      }
    }
  }
}
