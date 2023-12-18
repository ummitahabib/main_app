// To parse this JSON data, do
//
//     final agentOrganization = agentOrganizationFromJson(jsonString);

import 'dart:convert';

AgentOrganization agentOrganizationFromJson(String str) => AgentOrganization.fromJson(json.decode(str));

String agentOrganizationToJson(AgentOrganization data) => json.encode(data.toJson());

class AgentOrganization {
  User? user;
  List<Organization>? organizations;

  AgentOrganization({
    this.user,
    this.organizations,
  });

  factory AgentOrganization.fromJson(Map<String, dynamic> json) => AgentOrganization(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        organizations: json["organizations"] == null
            ? []
            : List<Organization>.from(json["organizations"].map((x) => Organization.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "user": user!.toJson(),
        "organizations": List<dynamic>.from(organizations!.map((x) => x.toJson())),
      };
}

class Organization {
  Organizations? organizations;
  List<dynamic>? permissions;

  Organization({
    this.organizations,
    this.permissions,
  });

  factory Organization.fromJson(Map<String, dynamic> json) => Organization(
        organizations: json["organizations"] == null ? null : Organizations.fromJson(json["organizations"]),
        permissions: json["permissions"] == null ? [] : List<dynamic>.from(json["permissions"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "organizations": organizations!.toJson(),
        "permissions": List<dynamic>.from(permissions!.map((x) => x)),
      };
}

class Organizations {
  String? createdBy;
  dynamic modifiedBy;
  String? deleted;
  dynamic deletedBy;
  DateTime? createdDate;
  DateTime? modifiedDate;
  String? uuid;
  String? organizationId;
  String? fieldAgentId;
  String? organizationName;
  String? organizationOwnerId;

  Organizations({
    this.createdBy,
    this.modifiedBy,
    this.deleted,
    this.deletedBy,
    this.createdDate,
    this.modifiedDate,
    this.uuid,
    this.organizationId,
    this.fieldAgentId,
    this.organizationName,
    this.organizationOwnerId,
  });

  factory Organizations.fromJson(Map<String, dynamic> json) => Organizations(
        createdBy: json["createdBy"],
        modifiedBy: json["modifiedBy"],
        deleted: json["deleted"],
        deletedBy: json["deletedBy"],
        createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
        modifiedDate: json["modifiedDate"] == null ? null : DateTime.parse(json["modifiedDate"]),
        uuid: json["uuid"],
        organizationId: json["organizationId"],
        fieldAgentId: json["fieldAgentId"],
        organizationName: json["organizationName"],
        organizationOwnerId: json["organizationOwnerId"],
      );

  Map<String, dynamic> toJson() => {
        "createdBy": createdBy,
        "modifiedBy": modifiedBy,
        "deleted": deleted,
        "deletedBy": deletedBy,
        "createdDate": createdDate!.toIso8601String(),
        "modifiedDate": modifiedDate!.toIso8601String(),
        "uuid": uuid,
        "organizationId": organizationId,
        "fieldAgentId": fieldAgentId,
        "organizationName": organizationName,
        "organizationOwnerId": organizationOwnerId,
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
