class UpdateInfoRequest {
  String firstName;
  String lastName;
  String phone;

  UpdateInfoRequest({
    required this.firstName,
    required this.lastName,
    required this.phone,
  });

  factory UpdateInfoRequest.fromJson(Map<String, dynamic> json) => UpdateInfoRequest(
        firstName: json["firstName"],
        lastName: json["lastName"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "phone": phone,
      };
}
