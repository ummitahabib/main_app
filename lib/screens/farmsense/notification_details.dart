import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smat_crow/pandora/pandora.dart';

import '../../loaders/loader.dart';
import '../../network/crow/device_detail_response.dart';
import '../../network/crow/farm_sense_operations.dart';
import '../../utils/assets/images.dart';
import '../../utils/colors.dart';
import '../../utils/styles.dart';
import '../farmmanager/widgets/circle_painter.dart';

class NotificationDetails extends StatefulWidget {
  final String data;

  const NotificationDetails({Key? key, required this.data}) : super(key: key);

  @override
  _NotificationDetailsState createState() => _NotificationDetailsState();
}

class _NotificationDetailsState extends State<NotificationDetails> {
  final Pandora _pandora = Pandora();
  final AsyncMemoizer _devicesAsync = AsyncMemoizer();
  DeviceDetailsResponse? deviceDetailsResponse;
  late Details deviceDetails;

  @override
  void initState() {
    super.initState();
    getDeviceInformation();
  }

  @override
  Widget build(BuildContext context) {
    const String bgImg = ImagesAssets.kHot;
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: AppColors.headerTopHalf,
            child: const Center(
              child: LoaderAnim(),
            ),
          );
        }
        return SafeArea(
          child: Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  leading: IconButton(
                    icon: Styles.keyBoardDefault(),
                    onPressed: () {
                      _pandora.logAPPButtonClicksEvent('NAVIGATOR_ITEM_BACK_CLICKED');
                      Navigator.pop(context);
                    },
                  ),
                ),
                backgroundColor: AppColors.whiteColor,
                body: Container(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (deviceDetailsResponse != null) ? deviceDetailsResponse!.deviceName! : "",
                                  style: GoogleFonts.lato(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  (deviceDetailsResponse != null) ? deviceDetailsResponse!.longDescription! : "",
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  (deviceDetailsResponse != null) ? deviceDetailsResponse!.shortDescription! : "",
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  (deviceDetailsResponse != null) ? '${deviceDetails.la} , ${deviceDetails.lo}' : "",
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(vertical: 10),
                                      decoration: BoxDecoration(
                                        border: Border.all(),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Online',
                                                style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              CustomPaint(
                                                painter: (deviceDetailsResponse != null)
                                                    ? OpenPainter((deviceDetails.p!) ? Colors.green : Colors.red)
                                                    : OpenPainter(Colors.red),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Backup Power',
                                                style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              CustomPaint(
                                                painter: (deviceDetailsResponse != null)
                                                    ? OpenPainter((deviceDetails.bs!) ? Colors.green : Colors.red)
                                                    : OpenPainter(Colors.red),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Main Power',
                                                style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              CustomPaint(
                                                painter: (deviceDetailsResponse != null)
                                                    ? OpenPainter((deviceDetails.ms!) ? Colors.green : Colors.red)
                                                    : OpenPainter(Colors.red),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Center(
                              child: SizedBox(
                                height: 200,
                                child: Image.asset(
                                  bgImg,
                                  fit: BoxFit.contain,
                                  height: 150,
                                  width: 150,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (deviceDetailsResponse != null) ? deviceDetails.t! : "",
                                  style: GoogleFonts.lato(
                                    fontSize: 85,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              border: Border.all(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Moisture: ',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      (deviceDetailsResponse != null) ? deviceDetails.bp! : "",
                                      style: GoogleFonts.lato(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Humidity: ',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      (deviceDetailsResponse != null) ? deviceDetails.h! : "",
                                      style: GoogleFonts.lato(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Time: ',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      (deviceDetailsResponse != null)
                                          ? _pandora.showTimeAgo(DateTime.parse(deviceDetails.ti!))
                                          : "",
                                      style: GoogleFonts.lato(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
      future: getDeviceInformation(),
    );
  }

  Future getDeviceInformation() async {
    return _devicesAsync.runOnce(() async {
      List<DeviceDetailsResponse> userDevices = await getDeviceDetails(widget.data);

      if (userDevices.isNotEmpty) {
        if (mounted) {
          setState(() {
            deviceDetailsResponse = userDevices[0];
            deviceDetails = deviceDetailsResponse!.details!;
          });
        }
      } else {}
      return userDevices;
    });
  }
}
