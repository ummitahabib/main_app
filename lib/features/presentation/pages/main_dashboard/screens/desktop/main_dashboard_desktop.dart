import 'package:flutter/material.dart';
import 'package:smat_crow/features/domain/entities/app_entity.dart';
import 'package:smat_crow/features/domain/entities/user/user_entity.dart';
import 'package:smat_crow/features/presentation/pages/main_dashboard/screens/main_screen.dart';

//main dashboard mobile view

class MainDashboardDesktop extends StatelessWidget {
  final UserEntity? currentUser;
  final String uid;
  final AppEntity? appEntity;

  const MainDashboardDesktop({
    super.key,
    this.currentUser,
    required this.uid,
    this.appEntity,
  });

  @override
  Widget build(BuildContext context) {
    return const MainDashboard();
  }
}
