import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_manager/views/mobile/farm_log_mobile.dart';
import 'package:smat_crow/utils2/responsive.dart';

class FarmLog extends HookConsumerWidget {
  const FarmLog({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Responsive(
      mobile: FarmLogMobile(),
    );
  }
}
