import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/institution/views/widgets/menu_body.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/shared/views/custom_app_bar.dart';
import 'package:smat_crow/utils2/constants.dart';

class InstitutionMenuMobile extends HookConsumerWidget {
  const InstitutionMenuMobile({
    super.key,
    this.isMobile = true,
  });
  final bool isMobile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMenu = useState(0);
    return Scaffold(
      appBar: customAppBar(
        context,
        title: ref.watch(organizationProvider).organization != null
            ? ref.watch(organizationProvider).organization!.name ?? ""
            : emptyString,
      ),
      body: MenuBody(isMobile: isMobile, selectedMenu: selectedMenu),
    );
  }
}
