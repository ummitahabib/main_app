import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:one_context/one_context.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/widgets/square_button.dart';
import 'package:smat_crow/utils/colors.dart';

import '../../utils/assets/svgs_assets.dart';
import '../../utils/styles.dart';

class FatalErrorPage extends StatefulWidget {
  final String errorMessage;
  final String? image, redirectRoute;

  const FatalErrorPage({
    Key? key,
    required this.errorMessage,
    this.image,
    this.redirectRoute,
  }) : super(key: key);

  @override
  _FatalErrorPageState createState() => _FatalErrorPageState();
}

class _FatalErrorPageState extends State<FatalErrorPage> {
  final Pandora pandora = Pandora();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.userProfileBackground,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Text(
              'An Error Occurred',
              style: Styles.verifyStyle(),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                widget.errorMessage,
                textAlign: TextAlign.center,
                style: Styles.defaultStyle(),
              ),
            ),
            Expanded(
              child: Center(
                child: SvgPicture.asset(
                  SvgsAssets.kSend,
                  height: 200,
                  width: 200,
                ),
              ),
            ),
            SquareButton(
              backgroundColor: AppColors.whiteColor,
              press: () {
                if (kIsWeb) {
                  OneContext().popDialog();
                } else {
                  Navigator.pop(context);
                }
                // Pandora().reRouteUserPop(context, ConfigRoute.mainPage, "args");
                // Navigator.pushAndRemoveUntil(
                //   context,
                //   MaterialPageRoute(
                //     builder: (BuildContext context) => const MainDashboard(),
                //   ),
                //   (route) => false,
                // );
              },
              textColor: AppColors.userProfileBackground,
              text: 'Continue',
            ),
            Padding(
              padding: const EdgeInsets.all(6),
              child: TextButton(
                onPressed: () async {
                  final result = await OpenMailApp.openMailApp();
                  if (!result.didOpen && !result.canOpen) {
                  } else if (!result.didOpen && result.canOpen) {
                    await showDialog(
                      context: context,
                      builder: (_) {
                        return MailAppPickerDialog(
                          mailApps: result.options,
                        );
                      },
                    );
                  }
                },
                child: Text(
                  'Report This Error',
                  textAlign: TextAlign.center,
                  style: Styles.openMailStyle(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
