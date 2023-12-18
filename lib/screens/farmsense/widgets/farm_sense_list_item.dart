import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/colors.dart';

import '../../../network/crow/models/get_farmsense_devices.dart';
import '../../../utils/styles.dart';

class FarmSenseListItem extends StatelessWidget {
  final image;
  final UserDevicesResponse userDevicesResponse;

  const FarmSenseListItem({Key? key, required this.userDevicesResponse, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Pandora pandora = Pandora();
    return Container(
      child: InkWell(
        onTap: () {
          pandora.reRouteUser(context, '/farmSenseDeviceDetails', userDevicesResponse);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13),
          child: Row(
            children: [
              SvgPicture.asset(
                image,
                color: AppColors.landingOrangeButton,
                width: 25.0,
                height: 25.0,
              ),
              const SizedBox(
                width: 15,
              ),
              Text(userDevicesResponse.deviceName!, overflow: TextOverflow.fade, style: Styles.textStyleGridColor()),
            ],
          ),
        ),
      ),
    );
  }
}
