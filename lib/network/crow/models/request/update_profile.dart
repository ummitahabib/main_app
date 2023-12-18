class UpdateProfileRequest {
  String? firstName;
  String? lastName;
  String? email;
  String? phone;

  UpdateProfileRequest({this.firstName, this.lastName, this.email, this.phone});

  UpdateProfileRequest.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['phone'] = phone;
    return data;
  }
}
