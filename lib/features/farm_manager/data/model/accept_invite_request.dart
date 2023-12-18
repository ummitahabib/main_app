class AcceptInviteRequest {
  String invitationId;
  String secureToken;
  String recipientId;
  String senderId;
  List<Org> organizations;
  List<String> visibilityPermissions;

  AcceptInviteRequest({
    required this.invitationId,
    required this.secureToken,
    required this.recipientId,
    required this.senderId,
    required this.organizations,
    required this.visibilityPermissions,
  });

  factory AcceptInviteRequest.fromJson(Map<String, dynamic> json) => AcceptInviteRequest(
        invitationId: json["invitationId"],
        secureToken: json["secureToken"],
        recipientId: json["recipientId"],
        senderId: json["senderId"],
        organizations: List<Org>.from(json["organizations"].map((x) => Org.fromJson(x))),
        visibilityPermissions: List<String>.from(json["visibilityPermissions"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "invitationId": invitationId,
        "secureToken": secureToken,
        "recipientId": recipientId,
        "senderId": senderId,
        "organizations": List<dynamic>.from(organizations.map((x) => x.toJson())),
        "visibilityPermissions": List<dynamic>.from(visibilityPermissions.map((x) => x)),
      };
}

class Org {
  String? organizationId;
  String? organizationName;

  Org({
    this.organizationId,
    this.organizationName,
  });

  factory Org.fromJson(Map<String, dynamic> json) => Org(
        organizationId: json["organizationId"],
        organizationName: json["organizationName"],
      );

  Map<String, dynamic> toJson() => {
        "organizationId": organizationId,
        "organizationName": organizationName,
      };
}
