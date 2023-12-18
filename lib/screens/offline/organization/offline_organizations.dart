import 'package:flutter/material.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/hive/daos/OrganizationsEntity.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/offline/organization/offline_organizations_menu.dart';

import '../../../hive/implementation/organizations_impl.dart';
import 'offline_organization_provider.dart';

class OfflineOrganizations extends StatefulWidget {
  const OfflineOrganizations({Key? key}) : super(key: key);

  @override
  _OfflineOrganizationsState createState() => _OfflineOrganizationsState();
}

class _OfflineOrganizationsState extends State<OfflineOrganizations> {
  OrganizationsImpl store = OrganizationsImpl();
  List<OrganizationsEntity> organizationsEntity = [];
  final Pandora _pandora = Pandora();

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  void initState() {
    super.initState();
    /*store
        .initializeOrganizationHive()
        .whenComplete(() => store.deleteOrganizations());*/
    store.initializeOrganizationHive().whenComplete(() => renderOfflineOrganizations());
  }

  Future<void> renderOfflineOrganizations() async {
    final data = await store.findAllOrganizations();
    organizationsEntity = data;
    if (organizationsEntity.isNotEmpty) {
      displayModalWithChild(
        OfflineOrganizationsMenu(organizationsEntity: organizationsEntity),
        'Your Organizations',
        context,
      );
    } else {
      _pandora.reRouteUserPop(context, '/signIn', null);
      await OneContext().showSnackBar(
        builder: (_) => const SnackBar(
          content: Text('You must to login to Sync your Organizations'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  dynamic displayModalWithChild(Widget child, String header, BuildContext context) async {
    Provider.of<OfflineOrganizationProvider>(context, listen: false).showModalBottomSheet(context: context);
  }
}
