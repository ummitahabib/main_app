class LoginResponse {
  bool? success;
  String? token;

  LoginResponse({this.success, this.token});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['token'] = token;
    return data;
  }
}
