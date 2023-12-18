import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/screens/splash/splash_page.dart';
import 'package:smat_crow/screens/widgets/square_button.dart';
import 'package:smat_crow/utils/colors.dart';

import '../../utils/assets/svgs_assets.dart';
import '../../utils/styles.dart';
import 'new_account_data.dart';

class VerifyAccountPage extends StatefulWidget {
  const VerifyAccountPage({
    Key? key,
  }) : super(key: key);

  @override
  _VerifyAccountPageState createState() => _VerifyAccountPageState();
}

class _VerifyAccountPageState extends State<VerifyAccountPage> {
  //final Pandora pandora = new Pandora();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.userProfileBackground,
      appBar: AppBar(
        elevation: 0,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Text(
              'Verify your Email',
              style: Styles.verifyStyle(),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                'Check your email & click the link to activate\n your account',
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
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const SplashPage(),
                  ),
                  (route) => false,
                );
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
                        // showNoMailAppsDialog(context);
                        Provider.of<NewAccountProvider>(context, listen: false).showNoMailAppsDialog(context);
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
                      'Open Mail App',
                      textAlign: TextAlign.center,
                      style: Styles.openMailStyle(),
                    ),),)
          ],
        ),
      ),
    );
  }
}
