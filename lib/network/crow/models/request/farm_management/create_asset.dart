// To parse this JSON data, do
//
//     final createAssetRequest = createAssetRequestFromJson(jsonString);

import 'dart:convert';

CreateAssetRequest createAssetRequestFromJson(String str) => CreateAssetRequest.fromJson(json.decode(str));

String createAssetRequestToJson(CreateAssetRequest data) => json.encode(data.toJson());

class CreateAssetRequest {
  CreateAssetRequest({
    this.acquisitionDate,
    this.cost,
    this.createdBy,
    this.createdDate,
    this.cropFamily,
    this.daysToMaturity,
    this.daysToTransplant,
    this.deleted,
    this.deletedBy,
    this.expiryDate,
    this.flags,
    this.manufactureDate,
    this.manufacturer,
    this.model,
    this.modifiedBy,
    this.modifiedDate,
    this.name,
    this.notes,
    this.organizationId,
    this.quantity,
    this.serialnumber,
    this.status,
    this.structureType,
    this.type,
  });

  DateTime? acquisitionDate;
  double? cost;
  String? createdBy;
  DateTime? createdDate;
  String? cropFamily;
  int? daysToMaturity;
  int? daysToTransplant;
  String? deleted;
  String? deletedBy;
  DateTime? expiryDate;
  String? flags;
  DateTime? manufactureDate;
  String? manufacturer;
  String? model;
  String? modifiedBy;
  DateTime? modifiedDate;
  String? name;
  String? notes;
  String? organizationId;
  int? quantity;
  String? serialnumber;
  String? status;
  String? structureType;
  String? type;

  factory CreateAssetRequest.fromJson(Map<String, dynamic> json) => CreateAssetRequest(
        acquisitionDate: json["acquisitionDate"],
        cost: json["cost"],
        createdBy: json["created_by"],
        createdDate: DateTime.parse(json["created_date"]),
        cropFamily: json["cropFamily"],
        daysToMaturity: json["daysToMaturity"],
        daysToTransplant: json["daysToTransplant"],
        deleted: json["deleted"],
        deletedBy: json["deleted_by"],
        expiryDate: json["expiryDate"],
        flags: json["flags"],
        manufactureDate: json["manufactureDate"],
        manufacturer: json["manufacturer"],
        model: json["model"],
        modifiedBy: json["modified_by"],
        modifiedDate: DateTime.parse(json["modified_date"]),
        name: json["name"],
        notes: json["notes"],
        organizationId: json["organizationId"],
        quantity: json["quantity"],
        serialnumber: json["serialnumber"],
        status: json["status"],
        structureType: json["structureType"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "acquisitionDate": acquisitionDate!.toIso8601String(),
        "cost": cost,
        "created_by": createdBy,
        "created_date": createdDate!.toIso8601String(),
        "cropFamily": cropFamily,
        "daysToMaturity": daysToMaturity,
        "daysToTransplant": daysToTransplant,
        "deleted": deleted,
        "deleted_by": deletedBy,
        "expiryDate": expiryDate!.toIso8601String(),
        "flags": flags,
        "manufactureDate": manufactureDate!.toIso8601String(),
        "manufacturer": manufacturer,
        "model": model,
        "modified_by": modifiedBy,
        "modified_date": modifiedDate!.toIso8601String(),
        "name": name,
        "notes": notes,
        "organizationId": organizationId,
        "quantity": quantity,
        "serialnumber": serialnumber,
        "status": status,
        "structureType": structureType,
        "type": type,
      };
}
