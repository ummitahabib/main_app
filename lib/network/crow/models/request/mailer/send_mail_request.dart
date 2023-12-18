// To parse this JSON data, do
//
//     final sendMailRequest = sendMailRequestFromJson(jsonString);

import 'dart:convert';

SendMailRequest sendMailRequestFromJson(String str) => SendMailRequest.fromJson(json.decode(str));

String sendMailRequestToJson(SendMailRequest data) => json.encode(data.toJson());

class SendMailRequest {
  SendMailRequest({
    required this.body,
    required this.cc,
    required this.from,
    required this.subject,
    required this.to,
  });

  String body;
  List<String> cc;
  String from;
  String subject;
  String to;

  factory SendMailRequest.fromJson(Map<String, dynamic> json) => SendMailRequest(
        body: json["body"],
        cc: List<String>.from(json["cc"].map((x) => x)),
        from: json["from"],
        subject: json["subject"],
        to: json["to"],
      );

  Map<String, dynamic> toJson() => {
        "body": body,
        "cc": List<dynamic>.from(cc.map((x) => x)),
        "from": from,
        "subject": subject,
        "to": to,
      };
}
