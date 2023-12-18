class GroupPremission {
  String groupName;
  List<String> permissions;

  GroupPremission({
    required this.groupName,
    required this.permissions,
  });

  factory GroupPremission.fromJson(Map<String, dynamic> json) => GroupPremission(
        groupName: json["groupName"],
        permissions: List<String>.from(json["permissions"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "groupName": groupName,
        "permissions": List<dynamic>.from(permissions.map((x) => x)),
      };
}
