// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SitesEntity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SitesEntityAdapter extends TypeAdapter<SitesEntity> {
  @override
  final int typeId = 2;

  @override
  SitesEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SitesEntity(
      fields[0] as int,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      (fields[4] as List)
          .map((dynamic e) => (e as List)
              .map((dynamic e) => (e as List).cast<double>())
              .toList(),)
          .toList(),
    );
  }

  @override
  void write(BinaryWriter writer, SitesEntity obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.organizationId)
      ..writeByte(3)
      ..write(obj.siteId)
      ..writeByte(4)
      ..write(obj.geojson);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SitesEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
