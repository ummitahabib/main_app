import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smat_crow/hive/daos/SitesEntity.dart';
import 'package:smat_crow/hive/enitities/sites_dao.dart';

class SitesImpl extends SitesDao {
  var sitesDB;

  @override
  Future<List<SitesEntity>> findAllSitesByOrganization(
    String organizationId,
  ) async {
    sitesDB = await Hive.openBox('sites');

    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(SitesEntityAdapter());
    }
    return sitesDB.values
        .where((SitesEntity) => SitesEntity.organizationId == organizationId)
        .toList()
        .cast<SitesEntity>();
  }

  @override
  SitesEntity findSiteById(int id) {
    return sitesDB.getAt(id);
  }

  @override
  Future<void> insertSite(SitesEntity site) async {
    sitesDB = await Hive.openBox('sites');
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(SitesEntityAdapter());
    }
    return sitesDB.add(site);
  }

  @override
  Future<void> initializeSiteHive() async {
    final Directory root = await getTemporaryDirectory();
    Hive.init(root.path);
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(SitesEntityAdapter());
    }
    sitesDB = await Hive.openBox('sites');
  }

  @override
  Future<void> deleteSites() async {
    return sitesDB.delete();
  }

  @override
  Future<void> deleteSitesById(int key) async {
    sitesDB = await Hive.openBox('sites');

    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(SitesEntityAdapter());
    }

    await sitesDB.delete(key);
  }
}
