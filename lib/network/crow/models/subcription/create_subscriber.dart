class CreateSubscriberRequest {
  String userId;
  String firstName;
  String lastName;
  String email;

  CreateSubscriberRequest({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory CreateSubscriberRequest.fromJson(Map<String, dynamic> json) => CreateSubscriberRequest(
        userId: json["userId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
      };
}
