// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'OrganizationsEntity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrganizationsEntityAdapter extends TypeAdapter<OrganizationsEntity> {
  @override
  final int typeId = 1;

  @override
  OrganizationsEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrganizationsEntity(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      fields[5] as String,
      fields[6] as String,
      fields[7] as String,
      fields[8] as int,
    );
  }

  @override
  void write(BinaryWriter writer, OrganizationsEntity obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.longDescription)
      ..writeByte(3)
      ..write(obj.shortDescription)
      ..writeByte(4)
      ..write(obj.image)
      ..writeByte(5)
      ..write(obj.address)
      ..writeByte(6)
      ..write(obj.industry)
      ..writeByte(7)
      ..write(obj.user)
      ..writeByte(8)
      ..write(obj.v);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrganizationsEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
