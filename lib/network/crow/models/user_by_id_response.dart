class GetUserByIdResponse {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? firstName;
  String? lastName;
  String? phone;
  String? email;
  bool? isVerified;
  Role? role;

  GetUserByIdResponse({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.isVerified,
    this.role,
  });

  GetUserByIdResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    phone = json['phone'];
    email = json['email'];
    isVerified = json['isVerified'];
    role = json['role'] != null ? Role.fromJson(json['role']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['phone'] = phone;
    data['email'] = email;
    data['isVerified'] = isVerified;
    data['role'] = role!.toJson();
    return data;
  }
}

class Role {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? role;

  Subscription? subscription;

  Role({this.id, this.createdAt, this.updatedAt, this.role, this.subscription});

  Role.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    role = json['role'];
    subscription = json['subscription'] != null ? Subscription.fromJson(json['subscription']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['role'] = role;
    data['subscription'] = subscription!.toJson();
    return data;
  }
}

class Subscription {
  String? id;
  String? createdAt;
  String? updatedAt;
  ExpirationDate? expirationDate;
  List<Permissions>? permissions;

  Subscription({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.expirationDate,
    this.permissions,
  });

  Subscription.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    expirationDate = json['expirationDate'] != null ? ExpirationDate.fromJson(json['expirationDate']) : null;
    if (json['permissions'] != null) {
      List<Permissions> permissions = List<Permissions>.from([]);
      //permissions = new List<Permissions>();
      json['permissions'].forEach((v) {
        permissions.add(Permissions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['expirationDate'] = expirationDate!.toJson();
    if (permissions != null) {
      data['permissions'] = permissions!.map((v) => v.toJson()).toList();
    } else {
      data['permissions'] = [];
    }
    return data;
  }
}

class ExpirationDate {
  dynamic smatStar;
  dynamic smatMapper;
  dynamic smatAi;
  dynamic smatSat;

  ExpirationDate({this.smatStar, this.smatMapper, this.smatAi, this.smatSat});

  ExpirationDate.fromJson(Map<String, dynamic> json) {
    smatStar = json['smatStar'];
    smatMapper = json['smatMapper'];
    smatAi = json['smatAi'];
    smatSat = json['smatSat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['smatStar'] = smatStar;
    data['smatMapper'] = smatMapper;
    data['smatAi'] = smatAi;
    data['smatSat'] = smatSat;
    return data;
  }
}

class Permissions {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? name;

  Permissions({this.id, this.createdAt, this.updatedAt, this.name});

  Permissions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['name'] = name;
    return data;
  }
}
