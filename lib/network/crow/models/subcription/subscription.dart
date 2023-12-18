// To parse this JSON data, do
//
//     final createSubscriberRequest = createSubscriberRequestFromJson(jsonString);

import 'package:smat_crow/network/crow/models/subcription/permission.dart';

class Subscription {
  String? id;
  dynamic deleted;
  dynamic createdDate;
  dynamic modifiedDate;
  Plan? plan;
  Subscriber? subscriber;
  int? payments;
  DateTime? started;
  DateTime? nextCharge;
  dynamic amount;
  String? status;
  dynamic paystackSubscriptionCode;
  dynamic channel;
  dynamic cardType;
  dynamic bank;
  dynamic countryCode;
  dynamic brand;

  Subscription({
    this.id,
    this.deleted,
    this.createdDate,
    this.modifiedDate,
    this.plan,
    this.subscriber,
    this.payments,
    this.started,
    this.nextCharge,
    this.amount,
    this.status,
    this.paystackSubscriptionCode,
    this.channel,
    this.cardType,
    this.bank,
    this.countryCode,
    this.brand,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        id: json["id"],
        deleted: json["deleted"],
        createdDate: json["createdDate"],
        modifiedDate: json["modifiedDate"],
        plan: json["plan"] == null ? null : Plan.fromJson(json["plan"]),
        subscriber: json["subscriber"] == null ? null : Subscriber.fromJson(json["subscriber"]),
        payments: json["payments"],
        started: json["started"] == null ? null : DateTime.parse(json["started"]),
        nextCharge: json["nextCharge"] == null ? null : DateTime.parse(json["nextCharge"]),
        amount: json["amount"],
        status: json["status"],
        paystackSubscriptionCode: json["paystackSubscriptionCode"],
        channel: json["channel"],
        cardType: json["cardType"],
        bank: json["bank"],
        countryCode: json["countryCode"],
        brand: json["brand"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "deleted": deleted,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "plan": plan?.toJson(),
        "subscriber": subscriber?.toJson(),
        "payments": payments,
        "started":
            "${started!.year.toString().padLeft(4, '0')}-${started!.month.toString().padLeft(2, '0')}-${started!.day.toString().padLeft(2, '0')}",
        "nextCharge":
            "${nextCharge!.year.toString().padLeft(4, '0')}-${nextCharge!.month.toString().padLeft(2, '0')}-${nextCharge!.day.toString().padLeft(2, '0')}",
        "amount": amount,
        "status": status,
        "paystackSubscriptionCode": paystackSubscriptionCode,
        "channel": channel,
        "cardType": cardType,
        "bank": bank,
        "countryCode": countryCode,
        "brand": brand,
      };
}

class Plan {
  String? id;
  String? deleted;
  int? createdDate;
  int? modifiedDate;
  String? name;
  String? description;
  dynamic interval;
  int? amount;
  dynamic currency;
  String? planCode;
  dynamic paystackPlanCode;
  dynamic stripePlanId;
  String? status;
  List<Permission>? permissions;

  Plan({
    this.id,
    this.deleted,
    this.createdDate,
    this.modifiedDate,
    this.name,
    this.description,
    this.interval,
    this.amount,
    this.currency,
    this.planCode,
    this.paystackPlanCode,
    this.stripePlanId,
    this.status,
    this.permissions,
  });

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
        id: json["id"],
        deleted: json["deleted"],
        createdDate: json["createdDate"],
        modifiedDate: json["modifiedDate"],
        name: json["name"],
        description: json["description"],
        interval: json["interval"],
        amount: json["amount"].toInt(),
        currency: json["currency"],
        planCode: json["planCode"],
        paystackPlanCode: json["paystackPlanCode"],
        stripePlanId: json["stripePlanId"],
        status: json["status"],
        permissions: json["permissions"] == null
            ? []
            : List<Permission>.from(json["permissions"]!.map((x) => Permission.fromJson(x))),
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
        "permissions": permissions == null ? [] : List<dynamic>.from(permissions!.map((x) => x.toJson())),
      };
}

class Subscriber {
  String? id;
  String? deleted;
  int? createdDate;
  int? modifiedDate;
  String? userId;
  dynamic firstName;
  dynamic lastName;
  dynamic email;

  Subscriber({
    this.id,
    this.deleted,
    this.createdDate,
    this.modifiedDate,
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
  });

  factory Subscriber.fromJson(Map<String, dynamic> json) => Subscriber(
        id: json["id"],
        deleted: json["deleted"],
        createdDate: json["createdDate"],
        modifiedDate: json["modifiedDate"],
        userId: json["userId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "deleted": deleted,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
