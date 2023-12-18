import 'package:flutter/material.dart';
import 'package:smat_crow/features/domain/entities/user/user_entity.dart';
import 'package:smat_crow/features/presentation/pages/main_dashboard/screens/main_screen.dart';

//main dashboard tablet view

class MainDashboardTablet extends StatelessWidget {
  final UserEntity? currentUser;
  final String uid;

  const MainDashboardTablet({
    super.key,
    this.currentUser,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return const MainDashboard();
  }
}
