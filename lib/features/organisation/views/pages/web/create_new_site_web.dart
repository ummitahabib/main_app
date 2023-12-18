import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/organisation/data/controller/map_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/sector_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/site_controller.dart';
import 'package:smat_crow/features/organisation/views/widgets/home_web_container.dart';
import 'package:smat_crow/features/organisation/views/widgets/set_marker_action.dart';
import 'package:smat_crow/features/widgets/custom_text_field.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

final _pandora = Pandora();

class CreateNewSiteWeb extends HookConsumerWidget {
  const CreateNewSiteWeb({super.key, required this.pageController});
  final PageController pageController;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = useState<String?>(null);
    final siteNotifier = ref.watch(siteProvider);
    final mapNotifier = ref.watch(mapProvider);
    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (siteNotifier.subType == SubType.site) {
            mapNotifier.markers.clear();
            mapNotifier.sectorLatLng.clear();
            mapNotifier.markPoint = 0;
            mapNotifier.polygon.clear();
            mapNotifier.siteLatLng.clear();
            mapNotifier.getCurrentPosition();
          }
          if (siteNotifier.subType == SubType.sector) {
            mapNotifier.sectorLatLng.clear();
            mapNotifier.markPoint = 0;
            mapNotifier.polygon.clear();
          }
        });
        return null;
      },
      [],
    );
    return HomeWebContainer(
      title: siteNotifier.subType == SubType.sector ? newSector : newSite,
      leadingCallback: () {
        pageController.previousPage(
          duration: const Duration(milliseconds: SpacingConstants.int400),
          curve: Curves.easeIn,
        );
        ref.read(mapProvider).allowMapTap = false;
      },
      width: Responsive.xWidth(context),
      trailingIcon: Padding(
        padding: const EdgeInsets.symmetric(vertical: SpacingConstants.size10),
        child: TextButton(
          onPressed: () {
            //implement endpoint and got back to site/sector page
            if (ref.read(siteProvider).subType == SubType.sector) {
              ref.read(sectorProvider).createSectorForSite(
                    context,
                    pageController,
                    name.value ?? "",
                  );
              return;
            }
            ref.read(siteProvider).createSiteForOrg(context, pageController, name.value ?? "");
          },
          child: Text(
            done,
            style: Styles.smatCrowMediumSubParagraph(
              color: AppColors.SmatCrowPrimary500,
            ),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(SpacingConstants.size20),
        child: Column(
          children: [
            CustomTextField(
              hintText: siteNotifier.subType == SubType.sector ? "$sectorText $nameText" : siteNameText,
              onChanged: (p0) => name.value = p0,
              initialValue: name.value,
              textCapitalization: TextCapitalization.words,
              isRequired: true,
              text: siteNotifier.subType == SubType.sector ? "$sectorText $nameText" : siteNameText,
              labelStyle: Styles.smatCrowMediumParagraph(
                color: AppColors.SmatCrowNeuBlue900,
              ).copyWith(
                fontSize: SpacingConstants.font14,
                fontWeight: FontWeight.bold,
              ),
            ),
            customSizedBoxHeight(SpacingConstants.size20),
            const SetMarkerAction()
          ],
        ),
      ),
    );
  }
}
