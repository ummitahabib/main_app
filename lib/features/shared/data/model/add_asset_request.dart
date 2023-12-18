class AddAssetRequest {
  String createdBy;
  String? modifiedBy;
  String deleted;
  String? deletedBy;
  DateTime createdDate;
  DateTime modifiedDate;
  String organizationId;
  String name;
  String status;
  List<String> assetFlags;
  String type;
  String notes;
  String flags;
  String? serialnumber;
  String? manufacturer;
  String? model;
  String? cropFamily;
  int? daysToTransplant;
  int? daysToMaturity;
  String? structureType;
  DateTime? manufactureDate;
  DateTime? expiryDate;
  int cost;
  String? currency;
  int quantity;
  String? farmingSeason;
  DateTime acquisitionDate;

  AddAssetRequest({
    required this.createdBy,
    this.modifiedBy,
    required this.deleted,
    this.deletedBy,
    required this.createdDate,
    required this.modifiedDate,
    required this.organizationId,
    required this.name,
    required this.status,
    required this.assetFlags,
    required this.type,
    required this.notes,
    required this.flags,
    this.serialnumber,
    this.manufacturer,
    this.model,
    this.cropFamily,
    this.daysToTransplant,
    this.daysToMaturity,
    this.structureType,
    this.manufactureDate,
    this.expiryDate,
    required this.cost,
    this.currency,
    this.farmingSeason,
    required this.quantity,
    required this.acquisitionDate,
  });

  factory AddAssetRequest.fromJson(Map<String, dynamic> json) => AddAssetRequest(
        createdBy: json["createdBy"],
        modifiedBy: json["modifiedBy"],
        deleted: json["deleted"],
        deletedBy: json["deletedBy"],
        createdDate: DateTime.parse(json["createdDate"]),
        modifiedDate: DateTime.parse(json["modifiedDate"]),
        organizationId: json["organizationId"],
        name: json["name"],
        status: json["status"],
        assetFlags: List<String>.from(json["assetFlags"].map((x) => x)),
        type: json["type"],
        flags: json["flags"],
        notes: json["notes"],
        serialnumber: json["serialnumber"],
        manufacturer: json["manufacturer"],
        model: json["model"],
        farmingSeason: json["farmingSeasonId"],
        cropFamily: json["cropFamily"],
        daysToTransplant: json["daysToTransplant"],
        daysToMaturity: json["daysToMaturity"],
        structureType: json["structureType"],
        manufactureDate: DateTime.parse(json["manufactureDate"]),
        expiryDate: DateTime.parse(json["expiryDate"]),
        cost: json["cost"],
        currency: json["currency"],
        quantity: json["quantity"],
        acquisitionDate: DateTime.parse(json["acquisitionDate"]),
      );

  Map<String, dynamic> toJson() => {
        "createdBy": createdBy,
        "modifiedBy": modifiedBy,
        "deleted": deleted,
        "deletedBy": deletedBy,
        "createdDate": createdDate.toIso8601String(),
        "modifiedDate": modifiedDate.toIso8601String(),
        "organizationId": organizationId,
        "name": name,
        "status": status,
        "assetFlags": List<dynamic>.from(assetFlags.map((x) => x)),
        "type": type,
        "flags": flags,
        "notes": notes,
        "serialnumber": serialnumber,
        "manufacturer": manufacturer,
        "model": model,
        "cropFamily": cropFamily,
        "daysToTransplant": daysToTransplant,
        "daysToMaturity": daysToMaturity,
        "structureType": structureType,
        "manufactureDate": manufactureDate == null ? null : manufactureDate!.toIso8601String(),
        "expiryDate": expiryDate == null ? null : expiryDate!.toIso8601String(),
        "cost": cost,
        "currency": currency,
        "farmingSeasonId": farmingSeason,
        "quantity": quantity,
        "acquisitionDate": acquisitionDate.toIso8601String(),
      };
}
