
class AuthResponse {
  bool? success;
  String? token;

  AuthResponse({this.success, this.token});

  AuthResponse.fromJson(Map<String, dynamic> json) {
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
