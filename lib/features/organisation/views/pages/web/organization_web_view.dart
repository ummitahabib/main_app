import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/organisation/views/pages/web/home_web_view.dart';

class OrganizationWebView extends HookConsumerWidget {
  const OrganizationWebView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const HomeWebView();
  }
}
