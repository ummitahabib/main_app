import '../daos/OrganizationsEntity.dart';

abstract class OrganizationsDao {
  void initializeOrganizationHive();

  Future<List<OrganizationsEntity>> findAllOrganizations();

  OrganizationsEntity findOrganizationsById(int id);

  Future<void> deleteOrganizations();

  Future<void> insertOrganization(OrganizationsEntity organization);
}
