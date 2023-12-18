import 'package:smat_crow/network/crow/models/subcription/permission.dart';

class SubscriptionPlan {
  String id;
  String deleted;
  int createdDate;
  int modifiedDate;
  String name;
  String description;
  dynamic interval;
  double amount;
  dynamic currency;
  String planCode;
  dynamic paystackPlanCode;
  dynamic stripePlanId;
  String status;
  List<Permission> permissions;

  SubscriptionPlan({
    required this.id,
    required this.deleted,
    required this.createdDate,
    required this.modifiedDate,
    required this.name,
    required this.description,
    this.interval,
    required this.amount,
    this.currency,
    required this.planCode,
    this.paystackPlanCode,
    this.stripePlanId,
    required this.status,
    required this.permissions,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) => SubscriptionPlan(
        id: json["id"],
        deleted: json["deleted"],
        createdDate: json["createdDate"],
        modifiedDate: json["modifiedDate"],
        name: json["name"],
        description: json["description"],
        interval: json["interval"],
        amount: json["amount"].toDouble(),
        currency: json["currency"],
        planCode: json["planCode"],
        paystackPlanCode: json["paystackPlanCode"],
        stripePlanId: json["stripePlanId"],
        status: json["status"],
        permissions: List<Permission>.from(json["permissions"].map((x) => Permission.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "deleted": deleted,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "name": name,
        "description": description,
        "interval": interval,
        "amount": amount,
        "currency": currency,
        "planCode": planCode,
        "paystackPlanCode": paystackPlanCode,
        "stripePlanId": stripePlanId,
        "status": status,
        "permissions": List<dynamic>.from(permissions.map((x) => x.toJson())),
      };
}
