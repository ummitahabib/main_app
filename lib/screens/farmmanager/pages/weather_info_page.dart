import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/network/crow/models/site_by_id_response.dart';
import 'package:smat_crow/network/crow/models/weather_forecast_response.dart' as forecast;
import 'package:smat_crow/network/crow/models/weather_history_response.dart' as history;
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/farmmanager/widgets/bottom_sheet_header.dart';
import 'package:smat_crow/screens/farmmanager/widgets/loader_tile.dart';
import 'package:smat_crow/utils/colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../utils/styles.dart';

class WeatherInfoPage extends StatefulWidget {
  const WeatherInfoPage({Key? key, required this.siteId}) : super(key: key);
  final String siteId;

  @override
  _WeatherInfoPageState createState() => _WeatherInfoPageState();
}

class _WeatherInfoPageState extends State<WeatherInfoPage> {
  GetSiteById? siteData;
  history.WeatherHistoryResponse? weatherData;
  forecast.WeatherForecastResponse? wkForecastData;
  Pandora pandora = Pandora();
  final List<history.Datum> _weatherInfo = [];
  List<Widget> wkForecast = [];

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
        child: Text("Unable to load weather information"),
      ),
      whenNotDone: _showLoader(),
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

  Widget _showResponse() {
    return Column(
      children: [
        const SizedBox(height: 16),
        BottomSheetHeaderText(text: siteData!.name),
        const SizedBox(height: 24),
        EnhancedFutureBuilder(
          future: Future.delayed(const Duration(seconds: 5)),
          rememberFutureResult: true,
          whenDone: (obj) => _showWeatherCharts(),
          whenError: (error) => const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text("Unable to load weather information"),
          ),
          whenNotDone: _showLoader(),
        )
      ],
    );
  }

  Widget _showWeatherCharts() {
    return Column(
      children: [
        EnhancedFutureBuilder(
          future: Future.delayed(const Duration(seconds: 5)),
          rememberFutureResult: true,
          whenDone: (obj) => _showWeeklyForecastResponse(),
          whenError: (error) => const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text("Unable to load weather information"),
          ),
          whenNotDone: _showWeeklyForecastLoader(),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 222,
          child: AspectRatio(
            aspectRatio: 3,
            child: SfCartesianChart(
              title: ChartTitle(text: 'Cloud Cover (%)', alignment: ChartAlignment.near, textStyle: Styles.bold10()),
              tooltipBehavior: TooltipBehavior(enable: true, header: '%'),
              series: <ChartSeries>[
                AreaSeries<history.Datum, dynamic>(
                  dataSource: _weatherInfo,
                  color: AppColors.landingOrangeButton.withOpacity(.3),
                  borderWidth: 2,
                  borderColor: AppColors.landingOrangeButton,
                  xValueMapper: (history.Datum history, _) => pandora.epochToDate(history.forecastDate!),
                  yValueMapper: (history.Datum history, _) => history.cloudCover,
                  enableTooltip: true,
                )
              ],
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(labelFormat: '{value}%'),
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
                text: 'Max Temperature (°C)',
                alignment: ChartAlignment.near,
                textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
              tooltipBehavior: TooltipBehavior(enable: true, header: '°C'),
              series: <ChartSeries>[
                AreaSeries<history.Datum, dynamic>(
                  dataSource: _weatherInfo,
                  color: AppColors.landingOrangeButton.withOpacity(.3),
                  borderWidth: 2,
                  borderColor: AppColors.landingOrangeButton,
                  xValueMapper: (history.Datum history, _) => pandora.epochToDate(history.forecastDate!),
                  yValueMapper: (history.Datum history, _) => history.maxTemperature,
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
              title:
                  ChartTitle(text: 'Min Temperature ( °C)', alignment: ChartAlignment.near, textStyle: Styles.bold10()),
              tooltipBehavior: TooltipBehavior(enable: true, header: '°C'),
              series: <ChartSeries>[
                AreaSeries<history.Datum, String>(
                  dataSource: _weatherInfo,
                  color: AppColors.landingOrangeButton.withOpacity(.3),
                  borderWidth: 2,
                  borderColor: AppColors.landingOrangeButton,
                  xValueMapper: (history.Datum history, _) => pandora.epochToDate(history.forecastDate!),
                  yValueMapper: (history.Datum history, _) => history.minTemperature,
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
              title:
                  ChartTitle(text: 'Precipitation (mm/h)', alignment: ChartAlignment.near, textStyle: Styles.bold10()),
              tooltipBehavior: TooltipBehavior(enable: true, header: '(mm/h'),
              series: <ChartSeries>[
                AreaSeries<history.Datum, dynamic>(
                  dataSource: _weatherInfo,
                  color: AppColors.landingOrangeButton.withOpacity(.3),
                  borderWidth: 2,
                  borderColor: AppColors.landingOrangeButton,
                  xValueMapper: (history.Datum history, _) => pandora.epochToDate(history.forecastDate!),
                  yValueMapper: (history.Datum history, _) => history.precipitation,
                  enableTooltip: true,
                )
              ],
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(
                labelFormat: '{value}',
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
              title: ChartTitle(text: 'Sea Pressure (hPa)', alignment: ChartAlignment.near, textStyle: Styles.bold10()),
              tooltipBehavior: TooltipBehavior(enable: true, header: 'hPa'),
              series: <ChartSeries>[
                AreaSeries<history.Datum, dynamic>(
                  dataSource: _weatherInfo,
                  color: AppColors.landingOrangeButton.withOpacity(.3),
                  borderWidth: 2,
                  borderColor: AppColors.landingOrangeButton,
                  xValueMapper: (history.Datum history, _) => pandora.epochToDate(history.forecastDate!),
                  yValueMapper: (history.Datum history, _) => history.pressureSea,
                  enableTooltip: true,
                )
              ],
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(
                labelFormat: '{value}',
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
              title:
                  ChartTitle(text: 'Relative Humidity (%)', alignment: ChartAlignment.near, textStyle: Styles.bold10()),
              tooltipBehavior: TooltipBehavior(enable: true, header: '%'),
              series: <ChartSeries>[
                AreaSeries<history.Datum, dynamic>(
                  dataSource: _weatherInfo,
                  color: AppColors.landingOrangeButton.withOpacity(.3),
                  borderWidth: 2,
                  borderColor: AppColors.landingOrangeButton,
                  xValueMapper: (history.Datum history, _) => pandora.epochToDate(history.forecastDate!),
                  yValueMapper: (history.Datum history, _) => history.relativeHumidity,
                  enableTooltip: true,
                )
              ],
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(
                labelFormat: '{value}%',
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
              title: ChartTitle(text: 'Wind Direction', alignment: ChartAlignment.near, textStyle: Styles.bold10()),
              tooltipBehavior: TooltipBehavior(enable: true, header: 'Wind'),
              series: <ChartSeries>[
                AreaSeries<history.Datum, dynamic>(
                  dataSource: _weatherInfo,
                  color: AppColors.landingOrangeButton.withOpacity(.3),
                  borderWidth: 2,
                  borderColor: AppColors.landingOrangeButton,
                  xValueMapper: (history.Datum history, _) => pandora.epochToDate(history.forecastDate!),
                  yValueMapper: (history.Datum history, _) => history.windDirection,
                  enableTooltip: true,
                )
              ],
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(
                labelFormat: '{value}',
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
              title: ChartTitle(text: 'Wind Speed (km/h)', alignment: ChartAlignment.near, textStyle: Styles.bold10()),
              tooltipBehavior: TooltipBehavior(enable: true, header: '(km/h)'),
              series: <ChartSeries>[
                AreaSeries<history.Datum, dynamic>(
                  dataSource: _weatherInfo,
                  color: AppColors.landingOrangeButton.withOpacity(.3),
                  borderWidth: 2,
                  borderColor: AppColors.landingOrangeButton,
                  xValueMapper: (history.Datum history, _) => pandora.epochToDate(history.forecastDate!),
                  yValueMapper: (history.Datum history, _) => history.windSpeed,
                  enableTooltip: true,
                )
              ],
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(
                labelFormat: '{value}',
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
              title: ChartTitle(text: 'UVI', alignment: ChartAlignment.near, textStyle: Styles.bold10()),
              tooltipBehavior: TooltipBehavior(enable: true, header: 'UVI'),
              series: <ChartSeries>[
                AreaSeries<history.Datum, dynamic>(
                  dataSource: _weatherInfo,
                  color: AppColors.landingOrangeButton.withOpacity(.3),
                  borderWidth: 2,
                  borderColor: AppColors.landingOrangeButton,
                  xValueMapper: (history.Datum history, _) => pandora.epochToDate(history.forecastDate!),
                  yValueMapper: (history.Datum history, _) => history.uvi,
                  enableTooltip: true,
                )
              ],
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(
                labelFormat: '{value}',
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _showWeeklyForecastLoader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Container(
              height: 150,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              height: 150,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              height: 150,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              height: 150,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.circular(8),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _showWeeklyForecastResponse() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(
            height: 280,
            child: ListView.separated(
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(width: 12);
              },
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: wkForecast.length,
              itemBuilder: (context, index) {
                return wkForecast[index];
              },
            ),
          )
        ],
      ),
    );
  }
}
