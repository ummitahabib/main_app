import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/network/crow/models/site_by_id_response.dart';
import 'package:smat_crow/network/crow/models/soil_history_response.dart' as history;
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/farmmanager/widgets/bottom_sheet_header.dart';
import 'package:smat_crow/screens/farmmanager/widgets/loader_tile.dart';
import 'package:smat_crow/utils/colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../utils/styles.dart';

class SoilInfoPage extends StatefulWidget {
  const SoilInfoPage({Key? key, required this.siteId}) : super(key: key);
  final String siteId;

  @override
  _SoilInfoPageState createState() => _SoilInfoPageState();
}

class _SoilInfoPageState extends State<SoilInfoPage> {
  GetSiteById? siteData;
  history.SoilHistoryResponse? soilData;
  final List<history.Datum> _soilInfo = [];
  Pandora pandora = Pandora();

  @override
  void initState() {
    super.initState();
    // Provider.of<FarmManagerProvider>(context, listen: false).getSiteDetails(widget.siteId);
  }

  @override
  Widget build(BuildContext context) {
    return EnhancedFutureBuilder(
      future: Future.delayed(const Duration(seconds: 5)),
      rememberFutureResult: true,
      whenDone: (obj) => _showResponse(),
      whenError: (error) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text("Unable to load soil information"),
      ),
      whenNotDone: _showLoader(),
    );
  }

  Widget _showResponse() {
    return Column(
      children: [
        const SizedBox(height: 16),
        BottomSheetHeaderText(text: siteData!.name),
        const SizedBox(height: 24),
        EnhancedFutureBuilder(
          future: Future.delayed(const Duration(seconds: 5)),
          rememberFutureResult: true,
          whenDone: (obj) => _showSoilCharts(),
          whenError: (error) => const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text("Unable to load soil information"),
          ),
          whenNotDone: _showLoader(),
        )
      ],
    );
  }

  Widget _showSoilCharts() {
    return Column(
      children: [
        const SizedBox(height: 20),
        SizedBox(
          height: 222,
          child: AspectRatio(
            aspectRatio: 3,
            child: SfCartesianChart(
              title: ChartTitle(
                text: 'Soil Moisture (m³/m³)',
                alignment: ChartAlignment.near,
                textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
              tooltipBehavior: TooltipBehavior(enable: true, header: 'm³/m³'),
              series: <ChartSeries>[
                AreaSeries<history.Datum, dynamic>(
                  dataSource: _soilInfo,
                  color: AppColors.landingOrangeButton.withOpacity(.3),
                  borderWidth: 2,
                  borderColor: AppColors.landingOrangeButton,
                  xValueMapper: (history.Datum history, _) =>
                      history.date.toString().substring(0, history.date.toString().length - 12),
                  yValueMapper: (history.Datum history, _) => history.moisture,
                  enableTooltip: true,
                )
              ],
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(labelFormat: '{value}m³/m³'),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Divider(),
        const SizedBox(height: 8),
        SizedBox(
          height: 222,
          child: AspectRatio(
            aspectRatio: 3,
            child: SfCartesianChart(
              title: ChartTitle(
                text: 'SurfaceTemperature (°C)',
                alignment: ChartAlignment.near,
                textStyle: Styles.bold10(),
              ),
              tooltipBehavior: TooltipBehavior(enable: true, header: '°C'),
              series: <ChartSeries>[
                AreaSeries<history.Datum, dynamic>(
                  dataSource: _soilInfo,
                  color: AppColors.landingOrangeButton.withOpacity(.3),
                  borderWidth: 2,
                  borderColor: AppColors.landingOrangeButton,
                  xValueMapper: (history.Datum history, _) =>
                      history.date.toString().substring(0, history.date.toString().length - 12),
                  yValueMapper: (history.Datum history, _) => history.surfaceTemperature,
                  enableTooltip: true,
                )
              ],
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(
                labelFormat: '{value}°C',
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Divider(),
        const SizedBox(height: 8),
        SizedBox(
          height: 222,
          child: AspectRatio(
            aspectRatio: 3,
            child: SfCartesianChart(
              title: ChartTitle(
                text: '10cm Temperature ( °C)',
                alignment: ChartAlignment.near,
                textStyle: Styles.bold10(),
              ),
              tooltipBehavior: TooltipBehavior(enable: true, header: '°C'),
              series: <ChartSeries>[
                AreaSeries<history.Datum, dynamic>(
                  dataSource: _soilInfo,
                  color: AppColors.landingOrangeButton.withOpacity(.3),
                  borderWidth: 2,
                  borderColor: AppColors.landingOrangeButton,
                  xValueMapper: (history.Datum history, _) =>
                      history.date.toString().substring(0, history.date.toString().length - 12),
                  yValueMapper: (history.Datum history, _) => history.temperature,
                  enableTooltip: true,
                )
              ],
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(
                labelFormat: '{value}°C',
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _showLoader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            LoaderTileLarge(),
            SizedBox(
              height: 16,
            ),
            LoaderTileLarge(),
            SizedBox(
              height: 16,
            ),
            LoaderTileLarge(),
            SizedBox(
              height: 16,
            ),
            LoaderTileLarge(),
            SizedBox(
              height: 16,
            ),
            LoaderTileLarge(),
            SizedBox(
              height: 16,
            ),
            LoaderTileLarge(),
            SizedBox(
              height: 16,
            ),
            LoaderTileLarge(),
          ],
        ),
      ),
    );
  }
}
