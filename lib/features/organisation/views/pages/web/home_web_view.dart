import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/organisation/data/controller/navigation_controller.dart';
import 'package:smat_crow/features/organisation/views/pages/organisation.dart';
import 'package:smat_crow/features/organisation/views/pages/organization_list_view.dart';
import 'package:smat_crow/features/organisation/views/pages/site_details.dart';
import 'package:smat_crow/features/organisation/views/pages/site_map_options/soil_info.dart';
import 'package:smat_crow/features/organisation/views/pages/site_map_options/weather_info.dart';
import 'package:smat_crow/features/organisation/views/widgets/batch_edit_name.dart';
import 'package:smat_crow/features/organisation/views/widgets/batch_images_screen.dart';
import 'package:smat_crow/features/organisation/views/widgets/custom_google_map.dart';
import 'package:smat_crow/features/organisation/views/widgets/home_web_container.dart';
import 'package:smat_crow/features/organisation/views/widgets/set_current_location.dart';
import 'package:smat_crow/features/organisation/views/widgets/top_search_card.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';

class HomeWebView extends StatefulHookConsumerWidget {
  const HomeWebView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeWebViewState();
}

class _HomeWebViewState extends ConsumerState<HomeWebView> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: Theme.of(context).dividerColor),
                right: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            child: PageView(
              controller: ref.read(orgNavigationProvider).pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                HomeWebContainer(
                  title: organizationText,
                  leadingCallback: () {
                    context.beamToNamed(ConfigRoute.homeDashborad);
                  },
                  trailingCallback: () {
                    addNewOrganization(context);
                  },
                  width: Responsive.xWidth(context),
                  addSpacing: true,
                  child: const OrganizationListView(),
                ),
                const SiteDetails(),
                EditBatchName(
                  controller: ref.read(orgNavigationProvider).pageController,
                )
              ],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: ref.read(orgNavigationProvider).mapPageController,
            children: [
              const Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: [
                  Stack(
                    alignment: AlignmentDirectional.topCenter,
                    children: [
                      CustomGoogleMap(),
                      TopSearchCard(),
                    ],
                  ),
                  SetCurrentLocation()
                ],
              ),
              const SoilInfo(),
              const WeatherInfo(),
              BatchImagesScreen(
                controller: ref.read(orgNavigationProvider).pageController,
              )
            ],
          ),
        )
      ],
    );
  }
}
