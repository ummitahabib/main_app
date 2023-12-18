// To parse this JSON data, do
//
//     final addLogRemark = addLogRemarkFromJson(jsonString);

import 'dart:convert';

AddLogRemark addLogRemarkFromJson(String str) =>
    AddLogRemark.fromJson(json.decode(str));

String addLogRemarkToJson(AddLogRemark data) => json.encode(data.toJson());

class AddLogRemark {
  AddLogRemark({
  required  this.logId,
  required  this.nextAction,
  required  this.remark,
  });

  int logId;
  String nextAction;
  String remark;

  factory AddLogRemark.fromJson(Map<String, dynamic> json) => AddLogRemark(
        logId: json["logId"],
        nextAction: json["nextAction"],
        remark: json["remark"],
      );

  Map<String, dynamic> toJson() => {
        "logId": logId,
        "nextAction": nextAction,
        "remark": remark,
      };
}
