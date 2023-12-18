class FarmAgentModel {
  UserDetails? userDetails;
  List<UserType>? userTypes;

  FarmAgentModel({
    this.userDetails,
    this.userTypes,
  });

  factory FarmAgentModel.fromJson(Map<String, dynamic> json) => FarmAgentModel(
        userDetails: json["userDetails"] == null ? null : UserDetails.fromJson(json["userDetails"]),
        userTypes:
            json["userTypes"] == null ? [] : List<UserType>.from(json["userTypes"]!.map((x) => UserType.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "userDetails": userDetails?.toJson(),
        "userTypes": userTypes == null ? [] : List<dynamic>.from(userTypes!.map((x) => x.toJson())),
      };
}

class UserDetails {
  String? id;
  String? fullName;
  String? phone;
  String? email;

  UserDetails({
    this.id,
    this.fullName,
    this.phone,
    this.email,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
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

class UserType {
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

  UserType({
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

  factory UserType.fromJson(Map<String, dynamic> json) => UserType(
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
