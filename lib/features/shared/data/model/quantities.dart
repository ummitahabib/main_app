// To parse this JSON data, do
//
//     final quantity = quantityFromJson(jsonString);

import 'dart:convert';

Quantity quantityFromJson(String str) => Quantity.fromJson(json.decode(str));

String quantityToJson(Quantity data) => json.encode(data.toJson());

class Quantity {
  String? createdBy;
  dynamic modifiedBy;
  String? deleted;
  dynamic deletedBy;
  DateTime? createdDate;
  DateTime? modifiedDate;
  String? uuid;
  String? quantity;
  String? description;

  Quantity({
    this.createdBy,
    this.modifiedBy,
    this.deleted,
    this.deletedBy,
    this.createdDate,
    this.modifiedDate,
    this.uuid,
    this.quantity,
    this.description,
  });

  factory Quantity.fromJson(Map<String, dynamic> json) => Quantity(
        createdBy: json["createdBy"],
        modifiedBy: json["modifiedBy"],
        deleted: json["deleted"],
        deletedBy: json["deletedBy"],
        createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
        modifiedDate: json["modifiedDate"] == null ? null : DateTime.parse(json["modifiedDate"]),
        uuid: json["uuid"],
        quantity: json["quantity"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "createdBy": createdBy,
        "modifiedBy": modifiedBy,
        "deleted": deleted,
        "deletedBy": deletedBy,
        "createdDate": createdDate?.toIso8601String(),
        "modifiedDate": modifiedDate?.toIso8601String(),
        "uuid": uuid,
        "quantity": quantity,
        "description": description,
      };
}
