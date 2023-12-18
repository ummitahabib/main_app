// To parse this JSON data, do
//
//     final getSampleReport = getSampleReportFromJson(jsonString);

import 'dart:convert';

GetSampleReport getSampleReportFromJson(String str) => GetSampleReport.fromJson(json.decode(str));

String getSampleReportToJson(GetSampleReport data) => json.encode(data.toJson());

class GetSampleReport {
  GetSampleReport({
    required this.success,
    required this.data,
  });

  bool success;
  Data data;

  factory GetSampleReport.fromJson(Map<String, dynamic> json) => GetSampleReport(
        success: json["success"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.pdfUrl,
  });

  String pdfUrl;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        pdfUrl: json["pdf_url"],
      );

  Map<String, dynamic> toJson() => {
        "pdf_url": pdfUrl,
      };
}
