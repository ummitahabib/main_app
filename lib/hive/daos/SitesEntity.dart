import 'package:hive/hive.dart';

part 'SitesEntity.g.dart';

@HiveType(typeId: 2)
class SitesEntity extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String organizationId;
  @HiveField(3)
  final String siteId;
  @HiveField(4)
  final List<List<List<double>>> geojson;

  SitesEntity(
      this.id, this.name, this.organizationId, this.siteId, this.geojson,);
}
