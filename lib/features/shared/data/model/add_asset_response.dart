class AddAssetResponse {
  String? createdBy;
  dynamic modifiedBy;
  String? deleted;
  dynamic deletedBy;
  DateTime? createdDate;
  DateTime? modifiedDate;
  String? uuid;
  String? organizationId;
  String? name;
  String? status;
  dynamic flags;
  List<String>? assetFlags;
  String? type;
  bool? canExpire;
  String? notes;
  dynamic serialnumber;
  dynamic manufacturer;
  dynamic model;
  dynamic cropFamily;
  dynamic daysToTransplant;
  dynamic daysToMaturity;
  dynamic structureType;
  DateTime? manufactureDate;
  DateTime? expiryDate;
  String? currency;
  double? cost;
  int? quantity;
  dynamic quantityUnit;
  DateTime? acquisitionDate;
  String? readyForApproval;
  String? farmingSeasonId;
  dynamic publishedBy;
  bool? location;

  AddAssetResponse({
    this.createdBy,
    this.modifiedBy,
    this.deleted,
    this.deletedBy,
    this.createdDate,
    this.modifiedDate,
    this.uuid,
    this.organizationId,
    this.name,
    this.status,
    this.flags,
    this.assetFlags,
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
    this.currency,
    this.cost,
    this.quantity,
    this.quantityUnit,
    this.acquisitionDate,
    this.readyForApproval,
    this.farmingSeasonId,
    this.publishedBy,
    this.location,
  });

  factory AddAssetResponse.fromJson(Map<String, dynamic> json) => AddAssetResponse(
        createdBy: json["createdBy"],
        modifiedBy: json["modifiedBy"],
        deleted: json["deleted"],
        deletedBy: json["deletedBy"],
        createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
        modifiedDate: json["modifiedDate"] == null ? null : DateTime.parse(json["modifiedDate"]),
        uuid: json["uuid"],
        organizationId: json["organizationId"],
        name: json["name"],
        status: json["status"],
        flags: json["flags"],
        assetFlags: json["assetFlags"] == null ? [] : List<String>.from(json["assetFlags"]!.map((x) => x)),
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
        manufactureDate: json["manufactureDate"] == null ? null : DateTime.parse(json["manufactureDate"].toString()),
        expiryDate: json["expiryDate"] == null ? null : DateTime.parse(json["expiryDate"].toString()),
        currency: json["currency"],
        cost: json["cost"],
        quantity: json["quantity"],
        quantityUnit: json["quantityUnit"],
        acquisitionDate: json["acquisitionDate"] == null ? null : DateTime.parse(json["acquisitionDate"].toString()),
        readyForApproval: json["readyForApproval"],
        farmingSeasonId: json["farmingSeasonId"],
        publishedBy: json["publishedBy"],
        location: json["location"],
      );

  Map<String, dynamic> toJson() => {
        "createdBy": createdBy,
        "modifiedBy": modifiedBy,
        "deleted": deleted,
        "deletedBy": deletedBy,
        "createdDate": createdDate?.toIso8601String(),
        "modifiedDate": modifiedDate?.toIso8601String(),
        "uuid": uuid,
        "organizationId": organizationId,
        "name": name,
        "status": status,
        "flags": flags,
        "assetFlags": assetFlags == null ? [] : List<dynamic>.from(assetFlags!.map((x) => x)),
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
        "manufactureDate": manufactureDate,
        "expiryDate": expiryDate,
        "currency": currency,
        "cost": cost,
        "quantity": quantity,
        "quantityUnit": quantityUnit,
        "acquisitionDate":
            "${acquisitionDate!.year.toString().padLeft(4, '0')}-${acquisitionDate!.month.toString().padLeft(2, '0')}-${acquisitionDate!.day.toString().padLeft(2, '0')}",
        "readyForApproval": readyForApproval,
        "farmingSeasonId": farmingSeasonId,
        "publishedBy": publishedBy,
        "location": location,
      };
}
