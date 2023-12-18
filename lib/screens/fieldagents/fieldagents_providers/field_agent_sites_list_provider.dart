import 'package:flutter/material.dart';

import '../../../network/crow/sites_operations.dart';
import '../widgets/field_agent_sites_item.dart';

class FieldAgentSitesProvider extends ChangeNotifier {
  bool loading = true;
  List<Widget> sites = [];
  String siteId = '', siteName = '';
  int sectorCount = 0;
  bool clickedSite = false;

  bool get mounted => false;

  updateSiteId(String id, String name, int count, bool isTapped) {
    siteId = id;
    siteName = name;
    sectorCount = count;
    clickedSite = isTapped;
    notifyListeners();
  }

  Future getSitesInOrganizations(organizationId) async {
    final sitesData = await getSitesInOrganization(organizationId);
    List<Widget> sitesItem = [];
    if (sitesData.isNotEmpty) {
      for (final site in sitesData) {
        sitesItem.add(
          FieldAgentSitesItem(
            siteName: site.name!,
            sectorCount: site.sectors!.length,
            organizationId: organizationId,
            siteId: site.id!,
            isDummy: false,
            getSelectedId: updateSiteId,
          ),
        );
      }
      for (int i = 0; i < 3; i++) {
        sitesItem.add(
          FieldAgentSitesItem(
            siteName: '',
            sectorCount: 0,
            organizationId: organizationId,
            siteId: '',
            isDummy: true,
            getSelectedId: updateSiteId,
          ),
        );
      }
      if (mounted) {
        sites = sitesItem;
        notifyListeners();
      }
    } else {
      for (int i = 0; i < 4; i++) {
        sitesItem.add(
          FieldAgentSitesItem(
            siteName: '',
            sectorCount: 0,
            organizationId: organizationId,
            siteId: '',
            isDummy: true,
            getSelectedId: updateSiteId,
          ),
        );
      }
      if (mounted) {
        sites = sitesItem;
        notifyListeners();
      }
    }
    return sitesData;
  }
}
