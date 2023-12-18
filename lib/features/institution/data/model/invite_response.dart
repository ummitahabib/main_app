class InviteResponse {
  EntDetails? parentDetails;
  EntDetails? recipientDetails;
  InvitationDetails? invitationDetails;

  InviteResponse({
    this.parentDetails,
    this.recipientDetails,
    this.invitationDetails,
  });

  factory InviteResponse.fromJson(Map<String, dynamic> json) => InviteResponse(
        parentDetails: json["parentDetails"] == null ? null : EntDetails.fromJson(json["parentDetails"]),
        recipientDetails: json["recipientDetails"] == null ? null : EntDetails.fromJson(json["recipientDetails"]),
        invitationDetails:
            json["invitationDetails"] == null ? null : InvitationDetails.fromJson(json["invitationDetails"]),
      );

  Map<String, dynamic> toJson() => {
        "parentDetails": parentDetails!.toJson(),
        "recipientDetails": recipientDetails!.toJson(),
        "invitationDetails": invitationDetails!.toJson(),
      };
}

class InvitationDetails {
  String? createdBy;
  dynamic modifiedBy;
  String? deleted;
  dynamic deletedBy;
  DateTime? createdDate;
  DateTime? modifiedDate;
  String? uuid;
  String? invitationToken;
  String? parentId;
  String? recipientId;

  InvitationDetails({
    this.createdBy,
    this.modifiedBy,
    this.deleted,
    this.deletedBy,
    this.createdDate,
    this.modifiedDate,
    this.uuid,
    this.invitationToken,
    this.parentId,
    this.recipientId,
  });

  factory InvitationDetails.fromJson(Map<String, dynamic> json) => InvitationDetails(
        createdBy: json["createdBy"],
        modifiedBy: json["modifiedBy"],
        deleted: json["deleted"],
        deletedBy: json["deletedBy"],
        createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
        modifiedDate: json["modifiedDate"] == null ? null : DateTime.parse(json["modifiedDate"]),
        uuid: json["uuid"],
        invitationToken: json["invitationToken"],
        parentId: json["parentId"],
        recipientId: json["recipientId"],
      );

  Map<String, dynamic> toJson() => {
        "createdBy": createdBy,
        "modifiedBy": modifiedBy,
        "deleted": deleted,
        "deletedBy": deletedBy,
        "createdDate": createdDate!.toIso8601String(),
        "modifiedDate": modifiedDate!.toIso8601String(),
        "uuid": uuid,
        "invitationToken": invitationToken,
        "parentId": parentId,
        "recipientId": recipientId,
      };
}

class EntDetails {
  String? id;
  String? fullName;
  String? phone;
  String? email;

  EntDetails({
    this.id,
    this.fullName,
    this.phone,
    this.email,
  });

  factory EntDetails.fromJson(Map<String, dynamic> json) => EntDetails(
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
