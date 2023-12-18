import '../daos/SitesEntity.dart';

abstract class SitesDao {
  void initializeSiteHive();

  Future<List<SitesEntity>> findAllSitesByOrganization(String organizationId);

  SitesEntity findSiteById(int id);

  Future<void> insertSite(SitesEntity site);

  Future<void> deleteSites();

  Future<void> deleteSitesById(int key);
}
