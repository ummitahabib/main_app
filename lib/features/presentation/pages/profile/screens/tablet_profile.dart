import 'package:flutter/material.dart';
import 'package:smat_crow/features/presentation/pages/profile/widgets/profile_main_widget.dart';

class ProfileTablet extends StatelessWidget {
  final double? width;
  final double? height;
  const ProfileTablet({
    super.key,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return const ProfileMainWidget(
      width: 706,
    );
  }
}
