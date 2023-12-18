// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:one_context/one_context.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smat_crow/features/data/data_sources/api_data_sources.dart';
import 'package:smat_crow/features/farm_manager/data/controller/farm_manager_controller.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/institution/data/controller/institution_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/site_controller.dart';
import 'package:smat_crow/features/organisation/views/widgets/custom_action_widget.dart';
import 'package:smat_crow/features/organisation/views/widgets/dialog_header.dart';
import 'package:smat_crow/features/organisation/views/widgets/empty_list_widget.dart';
import 'package:smat_crow/features/presentation/pages/home_page/widgets/activity_demo.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/features/shared/views/loading_shimmer.dart';
import 'package:smat_crow/features/shared/views/modal_stick.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/features/widgets/custom_button.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/subscription/components/subscription_model.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils/session.dart';
import 'package:smat_crow/utils2/AppHelper.dart';
import 'package:smat_crow/utils2/activity_list.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/decoration.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

//dashboard activity grid item

class DashboardGridItem extends StatefulWidget {
  final String? name;
  final Color? background;
  final String? image;
  final String? route;

  const DashboardGridItem({
    Key? key,
    this.name,
    this.background,
    this.image,
    this.route,
  }) : super(key: key);

  @override
  State<DashboardGridItem> createState() => _DashboardGridItemState();
}

class _DashboardGridItemState extends State<DashboardGridItem> {
  int selectedActivityIndex = SpacingConstants.minus1;
  bool showDemoWidget = false;

  @override
  void initState() {
    super.initState();
    checkFirstTimeUser();
  }

  Future<void> checkFirstTimeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isFirstTimeUser = prefs.getBool(firstTimeUser) ?? true;
    if (isFirstTimeUser) {
      await prefs.setBool(
        firstTimeUser,
        false,
      );
      setState(() {
        showDemoWidget = true;
      });
    }
  }

  void handleSkip() {
    setState(() {
      showDemoWidget = false;
    });
  }

  void handleNext() {
    setState(() {
      selectedActivityIndex = (selectedActivityIndex + SpacingConstants.int1) % dashboardMenuList.length;
    });
  }

  void _showActivityDemoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width - SpacingConstants.int40,
            padding: const EdgeInsets.all(SpacingConstants.size20),
            decoration: DecorationBox.activityGridDecoration,
            child: ActivityDemoWidget(
              activities: List<String>.from(
                farmMenu.map((a) => a[name]),
              ),
              activityDescriptions: activityDescriptions,
              onSkip: () {
                handleSkip();
                Navigator.of(context).pop();
              },
              onNext: handleNext,
            ),
          ),
        );
      },
    );
  }

  final farmMenu = dashboardMenuList;
  List<Widget> dashboardGridItem = [];

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Column(
          children: [
            InkWell(
              onTap: () {
                if (!showDemoWidget) {
                  if (widget.route != null) {
                    if (widget.route == ConfigRoute.farmProbe) {
                      if (ref.read(sharedProvider).userInfo != null &&
                          !ref.read(sharedProvider).userInfo!.perks.contains(AppPermissions.farmProbe)) {
                        SubscriptionModal.showSubscriptionModal(context);
                        return;
                      }
                      customDialogAndModal(
                        context,
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const ModalStick(),
                            DialogHeader(
                              headText: "Farm Probe",
                              showIcon: true,
                              callback: () {
                                if (kIsWeb) {
                                  OneContext().popDialog();
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                            if (!Responsive.isDesktop(context))
                              ListTile(
                                onTap: () {
                                  ApplicationHelpers().reRouteUser(context, widget.route!, 'args');
                                },
                                title: Row(
                                  children: [
                                    Image.asset("assets2/images/image 5.png"),
                                    const Xmargin(10),
                                    Text(
                                      "Capture Plant Diseases",
                                      style: Styles.smatCrowParagraphRegular(color: AppColors.SmatCrowNeuBlue900),
                                    )
                                  ],
                                ),
                              ),
                            if (!Responsive.isDesktop(context))
                              ListTile(
                                onTap: () async {
                                  final picker = await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: ['jpg', 'png', 'jpeg'],
                                  );
                                  if (picker != null && picker.files.isNotEmpty) {
                                    Pandora().reRouteUser(context, ConfigRoute.plantAnalysis, picker.files.first.path);
                                  }
                                  // ApplicationHelpers().reRouteUser(context, widget.route!, 'args');
                                },
                                title: Row(
                                  children: [
                                    Image.asset("assets2/images/image 6.png"),
                                    const Xmargin(10),
                                    Text(
                                      "Upload Plant Diseases",
                                      style: Styles.smatCrowParagraphRegular(color: AppColors.SmatCrowNeuBlue900),
                                    )
                                  ],
                                ),
                              ),
                            if (Responsive.isDesktop(context))
                              SizedBox(
                                height: SpacingConstants.size299,
                                child: InkWell(
                                  onTap: () async {
                                    final picker = await FilePicker.platform.pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: ['jpg', 'png', 'jpeg'],
                                    );
                                    if (picker != null && picker.files.isNotEmpty) {
                                      if (kIsWeb) {
                                        Pandora()
                                            .reRouteUser(context, ConfigRoute.plantAnalysis, picker.files.first.bytes);
                                      } else {
                                        Pandora()
                                            .reRouteUser(context, ConfigRoute.plantAnalysis, picker.files.first.path);
                                      }
                                    }
                                    // ApplicationHelpers().reRouteUser(context, widget.route!, 'args');
                                  },
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SvgPicture.asset(AppAssets.frame),
                                        const Ymargin(SpacingConstants.double20),
                                        const Text("Select your photo here of the plant here"),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                          ],
                        ),
                        Responsive.isDesktop(context),
                      );
                      return;
                    }
                    if (widget.route == ConfigRoute.soilSampling) {
                      customDialogAndModal(
                        context,
                        HookConsumer(
                          builder: (context, ref, child) {
                            final shared = ref.watch(sharedProvider);
                            if (shared.userInfo!.user.role.role != UserRole.agent.name) {
                              return Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            if (Responsive.isDesktop(context)) {
                                              OneContext().popDialog();
                                            } else {
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: const Icon(Icons.clear),
                                        )
                                      ],
                                    ),
                                    const Ymargin(20),
                                    Image.asset(AppAssets.connection, width: 140, height: 140, fit: BoxFit.scaleDown),
                                    const Ymargin(20),
                                    const Text(
                                      'Switch account',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF111927),
                                        fontSize: 18,
                                        fontFamily: 'Basier Circle',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Ymargin(10),
                                    const Text(
                                      'This feature is only availabe for user to switch account to Field Agent',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF374151),
                                        fontSize: 14,
                                        fontFamily: 'Basier Circle',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const Ymargin(40),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: ShapeDecoration(
                                        color: const Color(0xFFF3F4F6),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(AppAssets.warning),
                                          const Xmargin(10),
                                          const Text(
                                            'Note: This feature is irreversibile',
                                            style: TextStyle(
                                              color: Color(0xFF6E7191),
                                              fontSize: 12,
                                              fontFamily: 'Basier Circle',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const Ymargin(20),
                                    CustomButton(
                                      text: "Request Access",
                                      loading: ref.watch(authenticationProvider).loading,
                                      onPressed: () {
                                        customDialog(
                                          context,
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Ymargin(40),
                                              const SizedBox(
                                                width: 211,
                                                child: Text(
                                                  'Do you want to proceed with the action',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Color(0xFF111927),
                                                    fontSize: 18,
                                                    fontFamily: 'Basier Circle',
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              const Ymargin(20),
                                              const Text(
                                                'Note: This feature is irreversibile',
                                                style: TextStyle(
                                                  color: Color(0xFF6E7191),
                                                  fontSize: 12,
                                                  fontFamily: 'Basier Circle',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              const Ymargin(20),
                                              const Divider(),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: CustomButton(
                                                      text: "No, Cancel",
                                                      onPressed: () {
                                                        OneContext().popDialog();
                                                      },
                                                      textColor: AppColors.SmatCrowNeuBlue500,
                                                      color: Colors.transparent,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: SpacingConstants.size50,
                                                    child: VerticalDivider(),
                                                  ),
                                                  Expanded(
                                                    child: CustomButton(
                                                      text: "Yes, Continue",
                                                      textColor: AppColors.SmatCrowRed500,
                                                      onPressed: () async {
                                                        await ref.read(authenticationProvider).switchToAgent();
                                                        OneContext().popDialog();
                                                      },
                                                      color: Colors.transparent,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    )
                                  ],
                                ),
                              );
                            }
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const ModalStick(),
                                const BoldHeaderText(text: selectOrgText),
                                HookConsumer(
                                  builder: (cext, ref, child) {
                                    final manager = ref.watch(farmManagerProvider);

                                    useEffect(
                                      () {
                                        Future(() => manager.getAgentOrg());
                                        return null;
                                      },
                                      [],
                                    );
                                    if (manager.loading) {
                                      return const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: SpacingConstants.size20),
                                        child: LoadingShimmer(),
                                      );
                                    }
                                    if (manager.agentOrgList.isEmpty) {
                                      return SizedBox(
                                        height: Responsive.yHeight(context, percent: 0.7),
                                        child: const EmptyListWidget(
                                          text: noOrgFound,
                                          asset: AppAssets.emptyImage,
                                        ),
                                      );
                                    }
                                    final selectedIndex = useState<int>(-1);
                                    final list = manager.agentOrgList;
                                    return SizedBox(
                                      height: Responsive.yHeight(context, percent: 0.7),
                                      child: RefreshIndicator(
                                        onRefresh: () => manager.getAgentOrg(),
                                        child: ListView.separated(
                                          itemBuilder: (cxt, index) => Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                leading: CircleAvatar(
                                                  radius: SpacingConstants.size20,
                                                  foregroundImage: NetworkImage(DEFAULT_IMAGE),
                                                ),
                                                title: Text(
                                                  list[index].user!.fullName ?? "",
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                trailing: const Icon(Icons.keyboard_arrow_down),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(horizontal: SpacingConstants.size20),
                                                onTap: () {
                                                  selectedIndex.value = index;
                                                },
                                              ),
                                              if (selectedIndex.value == index)
                                                ...list[index].organizations!.map(
                                                      (e) => Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          ListTile(
                                                            leading: CircleAvatar(
                                                              radius: SpacingConstants.size15,
                                                              foregroundImage: NetworkImage(DEFAULT_IMAGE),
                                                            ),
                                                            contentPadding: const EdgeInsets.symmetric(
                                                              horizontal: SpacingConstants.size70,
                                                            ),
                                                            title: Text(
                                                              e.organizations!.organizationName ?? "",
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                            onTap: () async {
                                                              ref.read(farmManagerProvider).agentOrg = e;
                                                              if (kIsWeb) {
                                                                Pandora().reRouteUser(
                                                                  context,
                                                                  "${ConfigRoute.dashSite}?orgId=${e.organizations!.organizationId}",
                                                                  {"orgId": e.organizations!.organizationId},
                                                                );
                                                              } else {
                                                                unawaited(
                                                                  ref.read(siteProvider).getOrganizationSites(
                                                                        e.organizations!.organizationId ?? "",
                                                                      ),
                                                                );
                                                                unawaited(
                                                                  ref.read(organizationProvider).getOrganizationById(
                                                                        e.organizations!.organizationId ?? "",
                                                                      ),
                                                                );
                                                                Pandora().reRouteUser(
                                                                  context,
                                                                  ConfigRoute.dashSite,
                                                                  {"orgId": e.organizations!.organizationId},
                                                                );
                                                              }
                                                            },
                                                          ),
                                                          if (e != list[index].organizations!.last) const Divider()
                                                        ],
                                                      ),
                                                    )
                                            ],
                                          ),
                                          separatorBuilder: (context, index) => const Divider(),
                                          itemCount: list.length,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                        Responsive.isDesktop(context),
                      );

                      return;
                    }
                    if (widget.route == ConfigRoute.farmManager) {
                      if (ref.read(sharedProvider).userInfo != null &&
                          ref.read(sharedProvider).userInfo!.perks.contains(AppPermissions.user_field_manager)) {
                        ApplicationHelpers().reRouteUser(context, widget.route!, 'args');
                      } else {
                        SubscriptionModal.showSubscriptionModal(context);
                      }
                      return;
                    }

                    ApplicationHelpers().reRouteUser(context, widget.route!, 'args');
                  }
                } else {
                  _showActivityDemoDialog(context);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(SpacingConstants.size8),
                  border: Border.all(
                    color: selectedActivityIndex == selectedActivityIndex
                        ? AppColors.transperant
                        : AppColors.SmatCrowPrimary500,
                    width: SpacingConstants.size2,
                  ),
                  color: widget.background,
                ),
                width: SpacingConstants.double104,
                height: SpacingConstants.size72,
                child: Center(
                  child: Image.asset(
                    '${widget.image}',
                    width: SpacingConstants.size48,
                    height: SpacingConstants.size48,
                  ),
                ),
              ),
            ),
            customSizedBoxHeight(SpacingConstants.size10),
            Text(
              '${widget.name}',
              style: const TextStyle(fontSize: SpacingConstants.size10),
            ),
          ],
        );
      },
    );
  }
}

class DashSite extends HookConsumerWidget {
  const DashSite({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: HookConsumer(
          builder: (context, ref, child) {
            final site = ref.watch(siteProvider);

            useEffect(
              () {
                if (kIsWeb) {
                  final path = (context.currentBeamLocation.state as BeamState).uri.queryParameters;
                  Future(() {
                    unawaited(
                      ref.read(siteProvider).getOrganizationSites(path["orgId"] ?? ""),
                    );
                    unawaited(
                      ref.read(organizationProvider).getOrganizationById(path["orgId"] ?? ""),
                    );
                  });
                }

                return null;
              },
              [],
            );
            if (site.loading) {
              return const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SpacingConstants.size20,
                ),
                child: LoadingShimmer(),
              );
            }
            if (site.siteList.isEmpty) {
              return SizedBox(
                height: Responsive.yHeight(context, percent: 0.7),
                child: const EmptyListWidget(
                  text: noSiteFound,
                  asset: AppAssets.emptyImage,
                ),
              );
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DialogHeader(
                  headText: ref.watch(organizationProvider).organization == null
                      ? ""
                      : ref.watch(organizationProvider).organization!.name ?? "",
                  callback: () {
                    if (kIsWeb) {
                      context.beamToReplacementNamed(ConfigRoute.mainPage);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  showIcon: true,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                ...site.siteList.map(
                  (e) => ListTile(
                    leading: CircleAvatar(
                      radius: SpacingConstants.size15,
                      foregroundImage: NetworkImage(DEFAULT_IMAGE),
                    ),
                    title: Text(
                      e.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      site.site = e;
                      if (kIsWeb) {
                        ApplicationHelpers().reRouteUser(
                          context,
                          "${ConfigRoute.soilSampling}&fromMission=false,siteId=${e.id},agentId=${ref.read(farmManagerProvider).agentOrg!.organizations!.fieldAgentId}, missionId:",
                          CreateSoilSamplesArgs(
                            false,
                            e.id,
                            "missionId",
                            ref.read(farmManagerProvider).agentOrg!.organizations!.fieldAgentId ?? "",
                          ),
                        );
                      } else {
                        ApplicationHelpers().reRouteUser(
                          context,
                          ConfigRoute.soilSampling,
                          CreateSoilSamplesArgs(
                            false,
                            e.id,
                            "missionId",
                            ref.read(farmManagerProvider).agentOrg!.organizations!.fieldAgentId ?? "",
                          ),
                        );
                      }
                    },
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
