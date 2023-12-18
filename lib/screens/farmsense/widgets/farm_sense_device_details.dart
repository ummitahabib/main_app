import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smat_crow/pandora/pandora.dart';

import '../../../network/crow/models/get_farmsense_devices.dart';
import '../../../utils/assets/images.dart';
import '../../../utils/colors.dart';
import '../../farmmanager/widgets/circle_painter.dart';

class FarmSenseDeviceDetails extends StatefulWidget {
  final UserDevicesResponse deviceDetails;

  const FarmSenseDeviceDetails({Key? key, required this.deviceDetails}) : super(key: key);

  @override
  _FarmSenseDeviceDetailsState createState() => _FarmSenseDeviceDetailsState();
}

class _FarmSenseDeviceDetailsState extends State<FarmSenseDeviceDetails> {
  final Pandora _pandora = Pandora();
  final AsyncMemoizer devicesAsync = AsyncMemoizer();
  late UserDevicesResponse userDevicesResponse;
  late Detail deviceDetails;

  @override
  void initState() {
    setState(() {
      userDevicesResponse = widget.deviceDetails;
      if (userDevicesResponse.details!.isNotEmpty) {
        deviceDetails = userDevicesResponse.details![userDevicesResponse.details!.length - 1];
      }
    });
    // getDeviceInformation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const String bgImg = ImagesAssets.kHot;
    return Stack(
      children: [
        /*Image.asset(
          bgImg,
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),*/
        Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(
                Icons.keyboard_backspace_rounded,
                color: Colors.black,
              ),
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
                            userDevicesResponse.deviceName!,
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
                            userDevicesResponse.longDescription!,
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
                            userDevicesResponse.shortDescription!,
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
                            '${deviceDetails.la} , ${deviceDetails.lo}',
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
                                          painter: OpenPainter((deviceDetails.p!) ? Colors.green : Colors.red),
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
                                          painter: OpenPainter((deviceDetails.bs!) ? Colors.green : Colors.red),
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
                                          painter: OpenPainter((deviceDetails.ms!) ? Colors.green : Colors.red),
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
                            deviceDetails.t!,
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
                                deviceDetails.bp!,
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
                                deviceDetails.h!,
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
                                _pandora.showTimeAgo(deviceDetails.ti!),
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
    );
  }
}
