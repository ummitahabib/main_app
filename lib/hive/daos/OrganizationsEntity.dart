import 'package:hive/hive.dart';

part 'OrganizationsEntity.g.dart';

@HiveType(typeId: 1)
class OrganizationsEntity extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String longDescription;
  @HiveField(3)
  final String shortDescription;
  @HiveField(4)
  final String image;
  @HiveField(5)
  final String address;
  @HiveField(6)
  final String industry;
  @HiveField(7)
  final String user;
  @HiveField(8)
  final int v;

  OrganizationsEntity(
      this.id,
      this.name,
      this.longDescription,
      this.shortDescription,
      this.image,
      this.address,
      this.industry,
      this.user,
      this.v,);
}
