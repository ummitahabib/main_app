class UserDetailsResponse {
  bool? success;
  User? user;
  String? token;

  UserDetailsResponse({this.success, this.user, this.token});

  UserDetailsResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['user'] = user!.toJson();
    data['token'] = token;
    return data;
  }
}

class User {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? firstName;
  String? lastName;
  String? phone;
  String? email;
  bool? isVerified;
  Role? role;

  User({
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

  User.fromJson(Map<String, dynamic> json) {
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

  Role({this.id, this.createdAt, this.updatedAt, this.role});

  Role.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['role'] = role;
    return data;
  }
}
