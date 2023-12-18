import 'package:flutter/material.dart';
import 'package:smat_crow/features/presentation/pages/profile/widgets/profile_main_widget.dart';
import 'package:smat_crow/utils2/colors.dart';

class ProfileDesktop extends StatelessWidget {
  final double? width;
  final double? height;
  const ProfileDesktop({
    super.key,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.SmatCrowNeuBlue50,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 53,
          ),
          child: SizedBox(
            width: 710,
            height: MediaQuery.of(context).size.height,
            child: const ProfileMainWidget(
              width: 706,
              height: 299,
            ),
          ),
        ),
      ),
    );
  }
}
