// To parse this JSON data, do
//
//     final getBatchById = getBatchByIdFromJson(jsonString);

import 'dart:convert';

GetBatchById getBatchByIdFromJson(String str) => GetBatchById.fromJson(json.decode(str));

String getBatchByIdToJson(GetBatchById data) => json.encode(data.toJson());

class GetBatchById {
  GetBatchById({
    this.taskStatus,
    this.images,
    this.id,
    this.name,
    this.v,
    this.updatedAt,
    this.projectId,
    this.orthophotoUrl,
    this.taskId,
  });

  int? taskStatus;
  List<String>? images;
  String? id;
  String? name;
  int? v;
  DateTime? updatedAt;
  int? projectId;
  String? orthophotoUrl;
  String? taskId;

  factory GetBatchById.fromJson(Map<String, dynamic> json) => GetBatchById(
        taskStatus: json["taskStatus"],
        images: List<String>.from(json["images"].map((x) => x)),
        id: json["_id"],
        name: json["name"],
        v: json["__v"],
        updatedAt: DateTime.parse(json["updatedAt"]),
        projectId: json["projectId"],
        orthophotoUrl: json["orthophotoUrl"],
        taskId: json["taskId"],
      );

  Map<String, dynamic> toJson() => {
        "taskStatus": taskStatus,
        "images": List<dynamic>.from(images!.map((x) => x)),
        "_id": id,
        "name": name,
        "__v": v,
        "updatedAt": updatedAt!.toIso8601String(),
        "projectId": projectId,
        "orthophotoUrl": orthophotoUrl,
        "taskId": taskId,
      };
}
