// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/colors.dart';

import '../../../utils/styles.dart';

class WeeklyForecastItem extends StatelessWidget {
  const WeeklyForecastItem({
    Key? key,
    this.WeatherStatus,
    this.Description,
    this.Icon,
    this.MaxTemperature,
    this.MinTemperature,
    this.PressureSea,
    this.RelativeHumidity,
    this.WindSpeed,
    this.WindDirection,
    this.CloudCover,
    this.ForecastDate,
    this.DataCalculationDate,
    this.UVI,
  }) : super(key: key);

  final String? WeatherStatus, Description, Icon;
  final int? MaxTemperature,
      MinTemperature,
      PressureSea,
      RelativeHumidity,
      WindSpeed,
      WindDirection,
      CloudCover,
      ForecastDate,
      DataCalculationDate,
      UVI;

  @override
  Widget build(BuildContext context) {
    final Pandora pandora = Pandora();
    return Container(
      height: 280,
      width: 100,
      decoration: BoxDecoration(
        color: AppColors.landingOrangeButton,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                colors: [
                  AppColors.transperant,
                  AppColors.darkColor.withOpacity(0.8),
                ],
                stops: const [0.7, 2.0],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  pandora.epochToDate(ForecastDate!),
                  maxLines: 1,
                  style: GoogleFonts.poppins(textStyle: Styles.smallStyle()),
                ),
                const SizedBox(
                  height: 5,
                ),
                SvgPicture.network(
                  Icon!,
                  width: 25,
                  height: 25,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(Description ?? "", maxLines: 1, style: GoogleFonts.poppins(textStyle: Styles.smallStyle())),
                const SizedBox(
                  height: 5,
                ),
                const Divider(
                  height: 3,
                  color: Colors.black,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text('Cloud Cover', maxLines: 1, style: GoogleFonts.poppins(textStyle: Styles.TextStyleblackSm())),
                Text(CloudCover.toString(), maxLines: 1, style: GoogleFonts.poppins(textStyle: Styles.smallStyle())),
                const SizedBox(
                  height: 5,
                ),
                const Divider(
                  height: 3,
                  color: Colors.black,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text('Max Temperature', maxLines: 1, style: GoogleFonts.poppins(textStyle: Styles.TextStyleblackSm())),
                Text(
                  MaxTemperature.toString(),
                  maxLines: 1,
                  style: GoogleFonts.poppins(textStyle: Styles.smallStyle()),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Divider(
                  height: 3,
                  color: Colors.black,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text('Min Temperature', maxLines: 1, style: GoogleFonts.poppins(textStyle: Styles.TextStyleblackSm())),
                Text(
                  MinTemperature.toString(),
                  maxLines: 1,
                  style: GoogleFonts.poppins(textStyle: Styles.smallStyle()),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Divider(
                  height: 3,
                  color: Colors.black,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'Relative Humidity',
                  maxLines: 1,
                  style: GoogleFonts.poppins(textStyle: Styles.TextStyleblackSm()),
                ),
                Text(
                  RelativeHumidity.toString(),
                  maxLines: 1,
                  style: GoogleFonts.poppins(textStyle: Styles.smallStyle()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
