// To parse this JSON data, do
//
//     final acceptInviteRequest = acceptInviteRequestFromJson(jsonString);

import 'dart:convert';

AcceptInviteRequest acceptInviteRequestFromJson(String str) => AcceptInviteRequest.fromJson(json.decode(str));

String acceptInviteRequestToJson(AcceptInviteRequest data) => json.encode(data.toJson());

class AcceptInviteRequest {
  String? invitationId;
  String? secureToken;
  String? recipientId;
  String? senderId;
  List<String>? visibilityPermissions;

  AcceptInviteRequest({
    this.invitationId,
    this.secureToken,
    this.recipientId,
    this.senderId,
    this.visibilityPermissions,
  });

  factory AcceptInviteRequest.fromJson(Map<String, dynamic> json) => AcceptInviteRequest(
        invitationId: json["invitationId"],
        secureToken: json["secureToken"],
        recipientId: json["recipientId"],
        senderId: json["senderId"],
        visibilityPermissions: json["visibilityPermissions"] == null
            ? []
            : List<String>.from(json["visibilityPermissions"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "invitationId": invitationId,
        "secureToken": secureToken,
        "recipientId": recipientId,
        "senderId": senderId,
        "visibilityPermissions":
            visibilityPermissions == null ? [] : List<dynamic>.from(visibilityPermissions!.map((x) => x)),
      };
}
