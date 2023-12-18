import 'package:flutter/material.dart';
import 'package:smat_crow/hive/daos/OrganizationsEntity.dart';
import 'package:smat_crow/screens/offline/organization/offline_organizations_list_item.dart';

class OfflineOrganizationsMenu extends StatelessWidget {
  final List<OrganizationsEntity> organizationsEntity;

  const OfflineOrganizationsMenu({Key? key, required this.organizationsEntity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> fieldAgentListItem = [];
    final orgMenu = organizationsEntity;

    if (orgMenu.isEmpty) {
    } else {
      for (final item in orgMenu) {
        fieldAgentListItem.add(
          OfflineOrganizationsListItem(
            image: item.image,
            address: item.address,
            id: item.id,
            text: '',
            industry: item.industry,
            longDescription: item.longDescription,
            shortDescription: item.shortDescription,
            name: item.name,
            user: item.user,
            v: item.v,
            background: Colors.white,
          ),
        );
      }
    }

    return ListView.builder(
      itemCount: fieldAgentListItem.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return fieldAgentListItem[index];
      },
    );
  }
}
