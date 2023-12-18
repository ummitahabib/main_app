import 'dart:core';

import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/organisation/views/pages/organization_list_view.dart';
import 'package:smat_crow/features/organisation/views/pages/web/organization_web_view.dart';
import 'package:smat_crow/features/organisation/views/widgets/custom_action_widget.dart';
import 'package:smat_crow/features/organisation/views/widgets/organization_details.dart';
import 'package:smat_crow/features/shared/views/custom_app_bar.dart';
import 'package:smat_crow/network/crow/models/organization_by_id_response.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';

class Organization extends StatefulHookConsumerWidget {
  const Organization({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OrganizationState();
}

class _OrganizationState extends ConsumerState<Organization> {
  late OrganizationNotifier orgNotifier;

  @override
  void didChangeDependencies() {
    orgNotifier = ref.watch(organizationProvider);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    useEffect(
      () {
        Future(() async {
          await orgNotifier.getUserOrganizations();
          await orgNotifier.getIndustries();
        });
        return null;
      },
      [],
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: !Responsive.isDesktop(context)
          ? customAppBar(
              context,
              title: organizationText,
              onTap: () {
                if (kIsWeb) {
                  context.beamToReplacementNamed(ConfigRoute.mainPage);
                } else {
                  Navigator.pop(context);
                }
              },
              actions: [
                IconButton(
                  onPressed: () {
                    addNewOrganization(context);
                  },
                  icon: const Icon(
                    Icons.add_circle_outline,
                    color: AppColors.SmatCrowPrimary500,
                    size: 24,
                  ),
                )
              ],
            )
          : null,
      body: const Responsive(
        mobile: OrganizationListView(),
        tablet: OrganizationListView(),
        desktop: OrganizationWebView(),
        desktopTablet: OrganizationWebView(),
      ),
    );
  }
}

Future<dynamic> addNewOrganization(BuildContext context, {GetOrganizationById? org}) async {
  return customDialogAndModal(context, OrganizationDetails(org: org));
}
