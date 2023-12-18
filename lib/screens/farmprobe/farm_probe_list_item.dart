import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/pandora/pandora.dart';

import '../../utils/styles.dart';
import '../home/widgets/smatml/upload_leaf_picture.dart';

class FarmProbeListItem extends StatelessWidget {
  final String text, image, route;
  final Color background;

  const FarmProbeListItem({
    Key? key,
    required this.text,
    required this.background,
    required this.image,
    required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Pandora pandora = Pandora();
    return InkWell(
      onTap: () {
        if (route == "/gallery") {
          Provider.of<UploadLeafPicture>(context, listen: false)
              .pickUploadPostImage(context, ImageSource.gallery);
        } else if (route == "/url") {
          OneContext().showSnackBar(
            builder: (_) => const SnackBar(
              content: Text('Coming Soon'),
              backgroundColor: Colors.black,
            ),
          );
        } else if (route == "/search") {
          OneContext().showSnackBar(
            builder: (_) => const SnackBar(
              content: Text('Coming Soon'),
              backgroundColor: Colors.black,
            ),
          );
        } else {
          pandora.logAPPButtonClicksEvent(
              'FARM_PROBE_ITEM_${route.replaceAll('/', emptyString).toUpperCase()}_CLICKED');
          pandora.reRouteUser(context, route, 'null');
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: Row(
          children: [
            Image.asset(image, width: 25.0, height: 25.0, fit: BoxFit.contain),
            const SizedBox(
              width: 15,
            ),
            Text(text,
                overflow: TextOverflow.fade,
                style: Styles.textStyleGridColor()),
          ],
        ),
      ),
    );
  }
}
