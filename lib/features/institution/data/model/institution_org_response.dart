class InstitutionOrgResponse {
  User? user;
  List<InstOrganization>? organizations;
  List<dynamic>? permissions;

  InstitutionOrgResponse({
    this.user,
    this.organizations,
    this.permissions,
  });

  factory InstitutionOrgResponse.fromJson(Map<String, dynamic> json) => InstitutionOrgResponse(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        organizations: json["organizations"] == null
            ? []
            : List<InstOrganization>.from(json["organizations"].map((x) => InstOrganization.fromJson(x))),
        permissions: json["permissions"] == null ? [] : List<dynamic>.from(json["permissions"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "user": user!.toJson(),
        "organizations": List<dynamic>.from(organizations!.map((x) => x.toJson())),
        "permissions": List<dynamic>.from(permissions!.map((x) => x)),
      };
}

class InstOrganization {
  String? createdBy;
  dynamic modifiedBy;
  String? deleted;
  dynamic deletedBy;
  DateTime? createdDate;
  DateTime? modifiedDate;
  String? uuid;
  String? organizationName;
  String? organizationId;
  String? organizationUserId;
  String? institutionId;
  String? institution;

  InstOrganization({
    this.createdBy,
    this.modifiedBy,
    this.deleted,
    this.deletedBy,
    this.createdDate,
    this.modifiedDate,
    this.uuid,
    this.organizationName,
    this.organizationId,
    this.organizationUserId,
    this.institutionId,
    this.institution,
  });

  factory InstOrganization.fromJson(Map<String, dynamic> json) => InstOrganization(
        createdBy: json["createdBy"],
        modifiedBy: json["modifiedBy"],
        deleted: json["deleted"],
        deletedBy: json["deletedBy"],
        createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
        modifiedDate: json["modifiedDate"] == null ? null : DateTime.parse(json["modifiedDate"]),
        uuid: json["uuid"],
        organizationName: json["organizationName"],
        organizationId: json["organizationId"],
        organizationUserId: json["organizationUserId"],
        institutionId: json["institutionId"],
        institution: json["institution"],
      );

  Map<String, dynamic> toJson() => {
        "createdBy": createdBy,
        "modifiedBy": modifiedBy,
        "deleted": deleted,
        "deletedBy": deletedBy,
        "createdDate": createdDate!.toIso8601String(),
        "modifiedDate": modifiedDate!.toIso8601String(),
        "uuid": uuid,
        "organizationName": organizationName,
        "organizationId": organizationId,
        "organizationUserId": organizationUserId,
        "institutionId": institutionId,
        "institution": institution,
      };
}

class User {
  String? id;
  String? fullName;
  String? phone;
  String? email;

  User({
    this.id,
    this.fullName,
    this.phone,
    this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        fullName: json["fullName"],
        phone: json["phone"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullName": fullName,
        "phone": phone,
        "email": email,
      };
}
