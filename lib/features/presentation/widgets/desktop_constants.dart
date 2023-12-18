import 'package:flutter/material.dart';
import 'package:smat_crow/features/presentation/pages/home_page/widgets/user_info_desktop.dart';

class DesktopDashboardConstant extends StatelessWidget {
  const DesktopDashboardConstant({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        UserInfoDesk(),
      ],
    );
  }
}
