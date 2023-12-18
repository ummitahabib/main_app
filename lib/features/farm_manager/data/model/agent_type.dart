class AgentType {
  String? createdBy;
  dynamic modifiedBy;
  String? deleted;
  dynamic deletedBy;
  DateTime? createdDate;
  DateTime? modifiedDate;
  String? uuid;
  String? userType;
  String? description;
  String? organizationsHaveAccess;
  String? institutionsHaveAccess;
  List<String>? permissions;

  AgentType({
    this.createdBy,
    this.modifiedBy,
    this.deleted,
    this.deletedBy,
    this.createdDate,
    this.modifiedDate,
    this.uuid,
    this.userType,
    this.description,
    this.organizationsHaveAccess,
    this.institutionsHaveAccess,
    this.permissions,
  });

  factory AgentType.fromJson(Map<String, dynamic> json) => AgentType(
        createdBy: json["createdBy"],
        modifiedBy: json["modifiedBy"],
        deleted: json["deleted"],
        deletedBy: json["deletedBy"],
        createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
        modifiedDate: json["modifiedDate"] == null ? null : DateTime.parse(json["modifiedDate"]),
        uuid: json["uuid"],
        userType: json["userType"],
        description: json["description"],
        organizationsHaveAccess: json["organizationsHaveAccess"],
        institutionsHaveAccess: json["institutionsHaveAccess"],
        permissions: json["permissions"] == null ? [] : List<String>.from(json["permissions"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "createdBy": createdBy,
        "modifiedBy": modifiedBy,
        "deleted": deleted,
        "deletedBy": deletedBy,
        "createdDate": createdDate?.toIso8601String(),
        "modifiedDate": modifiedDate?.toIso8601String(),
        "uuid": uuid,
        "userType": userType,
        "description": description,
        "organizationsHaveAccess": organizationsHaveAccess,
        "institutionsHaveAccess": institutionsHaveAccess,
        "permissions": permissions == null ? [] : List<dynamic>.from(permissions!.map((x) => x)),
      };
}
