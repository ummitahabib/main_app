import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smat_crow/hive/daos/OrganizationsEntity.dart';
import 'package:smat_crow/hive/enitities/organizations_dao.dart';

class OrganizationsImpl implements OrganizationsDao {
  var organizationsDb;

  @override
  Future<List<OrganizationsEntity>> findAllOrganizations() async {
    organizationsDb = await Hive.openBox('organizations');

    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(OrganizationsEntityAdapter());
    }

    return organizationsDb.values.toList().cast<OrganizationsEntity>();
  }

  @override
  OrganizationsEntity findOrganizationsById(int id) {
    return organizationsDb.getAt(id);
  }

  @override
  Future<void> insertOrganization(OrganizationsEntity organization) {
    return organizationsDb.add(organization);
  }

  @override
  Future<void> initializeOrganizationHive() async {
    final Directory root = await getTemporaryDirectory();
    Hive.init(root.path);
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(OrganizationsEntityAdapter());
    }
    organizationsDb = await Hive.openBox('organizations');
  }

  @override
  Future<void> deleteOrganizations() async {
    organizationsDb = await Hive.openBox('organizations');
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(OrganizationsEntityAdapter());
    }
    return organizationsDb.clear();
  }
}
