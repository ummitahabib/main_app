// To parse this JSON data, do
//
//     final organizationAssetDetailsResponse = organizationAssetDetailsResponseFromJson(jsonString);

import 'dart:convert';

OrganizationAssetDetailsResponse organizationAssetDetailsResponseFromJson(
  String str,
) =>
    OrganizationAssetDetailsResponse.fromJson(json.decode(str));

String organizationAssetDetailsResponseToJson(
  OrganizationAssetDetailsResponse data,
) =>
    json.encode(data.toJson());

class OrganizationAssetDetailsResponse {
  OrganizationAssetDetailsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  String status;
  String message;
  Data data;

  factory OrganizationAssetDetailsResponse.fromJson(
    Map<String, dynamic> json,
  ) =>
      OrganizationAssetDetailsResponse(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.createdBy,
    this.modifiedBy,
    this.deleted,
    this.deletedBy,
    this.createdDate,
    this.modifiedDate,
    this.id,
    this.organizationId,
    this.name,
    this.status,
    this.flags,
    this.type,
    this.canExpire,
    this.notes,
    this.serialnumber,
    this.manufacturer,
    this.model,
    this.cropFamily,
    this.daysToTransplant,
    this.daysToMaturity,
    this.structureType,
    this.manufactureDate,
    this.expiryDate,
    this.cost,
    this.quantity,
    this.acquisitionDate,
    this.location,
  });

  String? createdBy;
  dynamic modifiedBy;
  String? deleted;
  dynamic deletedBy;
  DateTime? createdDate;
  DateTime? modifiedDate;
  int? id;
  String? organizationId;
  String? name;
  String? status;
  String? flags;
  String? type;
  bool? canExpire;
  String? notes;
  String? serialnumber;
  String? manufacturer;
  String? model;
  String? cropFamily;
  int? daysToTransplant;
  int? daysToMaturity;
  String? structureType;
  DateTime? manufactureDate;
  DateTime? expiryDate;
  double? cost;
  int? quantity;
  DateTime? acquisitionDate;
  bool? location;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        createdBy: json["created_by"],
        modifiedBy: json["modified_by"],
        deleted: json["deleted"],
        deletedBy: json["deleted_by"],
        createdDate: DateTime.parse(json["created_date"]),
        modifiedDate: DateTime.parse(json["modified_date"]),
        id: json["id"],
        organizationId: json["organizationId"],
        name: json["name"],
        status: json["status"],
        flags: json["flags"],
        type: json["type"],
        canExpire: json["canExpire"],
        notes: json["notes"],
        serialnumber: json["serialnumber"],
        manufacturer: json["manufacturer"],
        model: json["model"],
        cropFamily: json["cropFamily"],
        daysToTransplant: json["daysToTransplant"],
        daysToMaturity: json["daysToMaturity"],
        structureType: json["structureType"],
        manufactureDate: DateTime.parse(json["manufactureDate"]),
        expiryDate: DateTime.parse(json["expiryDate"]),
        cost: json["cost"].toDouble(),
        quantity: json["quantity"],
        acquisitionDate: DateTime.parse(json["acquisitionDate"]),
        location: json["location"],
      );

  Map<String, dynamic> toJson() => {
        "created_by": createdBy,
        "modified_by": modifiedBy,
        "deleted": deleted,
        "deleted_by": deletedBy,
        "created_date": createdDate!.toIso8601String(),
        "modified_date": modifiedDate!.toIso8601String(),
        "id": id,
        "organizationId": organizationId,
        "name": name,
        "status": status,
        "flags": flags,
        "type": type,
        "canExpire": canExpire,
        "notes": notes,
        "serialnumber": serialnumber,
        "manufacturer": manufacturer,
        "model": model,
        "cropFamily": cropFamily,
        "daysToTransplant": daysToTransplant,
        "daysToMaturity": daysToMaturity,
        "structureType": structureType,
        "manufactureDate": manufactureDate!.toIso8601String(),
        "expiryDate": expiryDate!.toIso8601String(),
        "cost": cost,
        "quantity": quantity,
        "acquisitionDate": acquisitionDate!.toIso8601String(),
        "location": location,
      };
}
