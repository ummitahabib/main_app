import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_manager/views/mobile/farm_agents_mobile.dart';
import 'package:smat_crow/utils2/responsive.dart';

class FarmAgents extends HookConsumerWidget {
  const FarmAgents({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Responsive(
      mobile: FarmAgentMobile(),
    );
  }
}
