class UserProfileInfo {
  bool success;
  User user;
  List<String> perks;
  String token;

  UserProfileInfo({
    required this.success,
    required this.user,
    required this.perks,
    required this.token,
  });

  factory UserProfileInfo.fromJson(Map<String, dynamic> json) => UserProfileInfo(
        success: json["success"],
        user: User.fromJson(json["user"]),
        perks: List<String>.from(json["perks"].map((x) => x)),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "user": user.toJson(),
        "perks": List<dynamic>.from(perks.map((x) => x)),
        "token": token,
      };
}

class User {
  String id;
  DateTime createdAt;
  DateTime updatedAt;
  String firstName;
  String lastName;
  String? phone;
  String email;
  bool isVerified;
  Role role;

  User({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.isVerified,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        firstName: json["firstName"],
        lastName: json["lastName"],
        phone: json["phone"],
        email: json["email"],
        isVerified: json["isVerified"],
        role: Role.fromJson(json["role"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "firstName": firstName,
        "lastName": lastName,
        "phone": phone,
        "email": email,
        "isVerified": isVerified,
        "role": role.toJson(),
      };
}

class Role {
  String id;
  DateTime createdAt;
  DateTime updatedAt;
  String role;
  Subscription subscription;

  Role({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.role,
    required this.subscription,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        role: json["role"],
        subscription: Subscription.fromJson(json["subscription"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "role": role,
        "subscription": subscription.toJson(),
      };
}

class Subscription {
  String id;
  DateTime createdAt;
  DateTime updatedAt;
  ExpirationDate expirationDate;
  List<Permission> permissions;

  Subscription({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.expirationDate,
    required this.permissions,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        expirationDate: ExpirationDate.fromJson(json["expirationDate"]),
        permissions: List<Permission>.from(json["permissions"].map((x) => Permission.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "expirationDate": expirationDate.toJson(),
        "permissions": List<dynamic>.from(permissions.map((x) => x.toJson())),
      };
}

class ExpirationDate {
  dynamic smatStar;
  dynamic smatMapper;
  dynamic smatAi;
  dynamic smatSat;

  ExpirationDate({
    required this.smatStar,
    required this.smatMapper,
    required this.smatAi,
    required this.smatSat,
  });

  factory ExpirationDate.fromJson(Map<String, dynamic> json) => ExpirationDate(
        smatStar: json["smatStar"],
        smatMapper: json["smatMapper"],
        smatAi: json["smatAi"],
        smatSat: json["smatSat"],
      );

  Map<String, dynamic> toJson() => {
        "smatStar": smatStar,
        "smatMapper": smatMapper,
        "smatAi": smatAi,
        "smatSat": smatSat,
      };
}

class Permission {
  String? id;
  String name;
  DateTime? createAt;
  DateTime? updatedAt;

  Permission({
    this.id,
    required this.name,
    this.createAt,
    this.updatedAt,
  });

  factory Permission.fromJson(Map<String, dynamic> json) => Permission(
        id: json["id"],
        name: json["name"],
        createAt: json["createAt"] == null ? null : DateTime.parse(json["createAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "createAt": createAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
      };
}
