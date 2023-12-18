import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/site_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/weather_soil_controller.dart';
import 'package:smat_crow/features/organisation/views/widgets/chart_widget.dart';
import 'package:smat_crow/features/organisation/views/widgets/dialog_container.dart';
import 'package:smat_crow/features/organisation/views/widgets/empty_list_widget.dart';
import 'package:smat_crow/features/organisation/views/widgets/soil_info_header.dart';
import 'package:smat_crow/screens/farmmanager/widgets/grid_loader.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class SoilInfo extends HookConsumerWidget {
  const SoilInfo({super.key, this.showCancelIcon = true});
  final bool showCancelIcon;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startDate =
        useState(DateTime.now().subtract(const Duration(days: 6)));
    final endDate = useState(DateTime.now());
    final themeData = Theme.of(context);
    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (ref.read(siteProvider).site!.polygonId != '0') {
            ref
                .read(weatherSoilProvider)
                .getSoilHistory(startDate.value, endDate.value);
          } else {
            snackBarMsg(polygonSizeWarning);
          }
        });
        return null;
      },
      [],
    );
    return DialogContainer(
      height: Responsive.yHeight(context, percent: 0.9),
      child: RefreshIndicator(
        onRefresh: () async {
          if (ref.read(siteProvider).site!.polygonId != '0') {
            await ref
                .read(weatherSoilProvider)
                .getSoilHistory(startDate.value, endDate.value);
          } else {
            snackBarMsg(polygonSizeWarning);
          }
        },
        child: ListView(
          children: [
            SoilInfoHeader(title: soilInfo, showIcon: showCancelIcon),
            customSizedBoxHeight(SpacingConstants.size20),
            SizedBox(
              height: Responsive.yHeight(context, percent: 0.7),
              child: HookConsumer(
                builder: (context, ref, child) {
                  final soil = ref.watch(weatherSoilProvider);
                  if (soil.loader) {
                    return SizedBox(
                      height: Responsive.yHeight(
                        context,
                        percent: Responsive.isDesktop(context) ? 0.60 : 0.75,
                      ),
                      child: const GridLoader(arrangement: 1),
                    );
                  }
                  if (soil.soilHistoryList.isEmpty) {
                    return const EmptyListWidget(
                      text: noSoilInfo,
                      asset: AppAssets.emptyImage,
                    );
                  }
                  return ListView(
                    children: [
                      if (ref.read(siteProvider).site!.polygonId != '0')
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              icon: SvgPicture.asset(AppAssets.calendar),
                              onPressed: () async {
                                final result = await showDateRangePicker(
                                  context: context,
                                  firstDate: DateTime(2019),
                                  lastDate: DateTime.now(),
                                  currentDate: DateTime.now(),
                                  saveText: 'Done',
                                  builder: (context, child) {
                                    return Theme(
                                      data: themeData.copyWith(
                                        appBarTheme:
                                            themeData.appBarTheme.copyWith(
                                          backgroundColor: Colors.blue,
                                          iconTheme: const IconThemeData(
                                            color: Colors.white,
                                          ),
                                        ),
                                        colorScheme: const ColorScheme.light(),
                                      ),
                                      child: SafeArea(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 450,
                                              width: 700,
                                              padding: const EdgeInsets.only(
                                                top: 50.0,
                                              ),
                                              child: child,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  initialDateRange: DateTimeRange(
                                    start: startDate.value,
                                    end: endDate.value,
                                  ),
                                );
                                if (result != null) {
                                  startDate.value = result.start;
                                  endDate.value = result.end;
                                  await ref
                                      .read(weatherSoilProvider)
                                      .getSoilHistory(
                                        startDate.value,
                                        endDate.value,
                                      );
                                }
                              },
                              label: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    DateFormat.yMMMd().format(endDate.value),
                                  ),
                                  const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: AppColors.SmatCrowNeuBlue900,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      customSizedBoxHeight(SpacingConstants.size20),
                      ChartWidget(
                        name: '$soilMoisture(m3/m3)',
                        dataSource: soil.soilHistoryList
                            .map(
                              (e) => ChartModel(
                                epochToDateString(e.dt),
                                e.moisture.toInt(),
                              ),
                            )
                            .toList(),
                        xValue: (p0, p1) => p0.xAxis,
                        yValue: (p0, p1) => p0.yAxis,
                      ),
                      ChartWidget(
                        name: '$surfaceTemp(°C)',
                        dataSource: soil.soilHistoryList
                            .map(
                              (e) => ChartModel(
                                epochToDateString(e.dt),
                                (e.t0 - 273).toInt(),
                              ),
                            )
                            .toList(),
                        xValue: (p0, p1) => p0.xAxis,
                        yValue: (p0, p1) => p0.yAxis,
                      ),
                      ChartWidget(
                        name: '$cmTemp(°C)',
                        dataSource: soil.soilHistoryList
                            .map(
                              (e) => ChartModel(
                                epochToDateString(e.dt),
                                (e.t10 - 273).toInt(),
                              ),
                            )
                            .toList(),
                        xValue: (p0, p1) => p0.xAxis,
                        yValue: (p0, p1) => p0.yAxis,
                      ),
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
