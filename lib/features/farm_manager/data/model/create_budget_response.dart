class CreateBudgetResponse {
  String? createdBy;
  dynamic modifiedBy;
  String? deleted;
  dynamic deletedBy;
  DateTime? createdDate;
  DateTime? modifiedDate;
  String? uuid;
  String? organizationId;
  String? farmingSeasonId;
  double? seasonBudget;

  CreateBudgetResponse({
    this.createdBy,
    this.modifiedBy,
    this.deleted,
    this.deletedBy,
    this.createdDate,
    this.modifiedDate,
    this.uuid,
    this.organizationId,
    this.farmingSeasonId,
    this.seasonBudget,
  });

  factory CreateBudgetResponse.fromJson(Map<String, dynamic> json) => CreateBudgetResponse(
        createdBy: json["createdBy"],
        modifiedBy: json["modifiedBy"],
        deleted: json["deleted"],
        deletedBy: json["deletedBy"],
        createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
        modifiedDate: json["modifiedDate"] == null ? null : DateTime.parse(json["modifiedDate"]),
        uuid: json["uuid"],
        organizationId: json["organizationId"],
        farmingSeasonId: json["farmingSeasonId"],
        seasonBudget: json["seasonBudget"],
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
        "farmingSeasonId": farmingSeasonId,
        "seasonBudget": seasonBudget,
      };
}
