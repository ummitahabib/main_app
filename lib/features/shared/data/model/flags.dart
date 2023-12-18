class Flags {
  String? createdBy;
  dynamic modifiedBy;
  String? deleted;
  dynamic deletedBy;
  DateTime? createdDate;
  DateTime? modifiedDate;
  String? uuid;
  String? flag;
  String? description;
  dynamic financeAgent;
  dynamic warehouseAgent;
  dynamic fieldAgent;

  Flags({
    this.createdBy,
    this.modifiedBy,
    this.deleted,
    this.deletedBy,
    this.createdDate,
    this.modifiedDate,
    this.uuid,
    this.flag,
    this.description,
    this.financeAgent,
    this.warehouseAgent,
    this.fieldAgent,
  });

  factory Flags.fromJson(Map<String, dynamic> json) => Flags(
        createdBy: json["createdBy"],
        modifiedBy: json["modifiedBy"],
        deleted: json["deleted"],
        deletedBy: json["deletedBy"],
        createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
        modifiedDate: json["modifiedDate"] == null ? null : DateTime.parse(json["modifiedDate"]),
        uuid: json["uuid"],
        flag: json["flag"],
        description: json["description"],
        financeAgent: json["financeAgent"],
        warehouseAgent: json["warehouseAgent"],
        fieldAgent: json["fieldAgent"],
      );

  Map<String, dynamic> toJson() => {
        "createdBy": createdBy,
        "modifiedBy": modifiedBy,
        "deleted": deleted,
        "deletedBy": deletedBy,
        "createdDate": createdDate?.toIso8601String(),
        "modifiedDate": modifiedDate?.toIso8601String(),
        "uuid": uuid,
        "flag": flag,
        "description": description,
        "financeAgent": financeAgent,
        "warehouseAgent": warehouseAgent,
        "fieldAgent": fieldAgent,
      };
}
