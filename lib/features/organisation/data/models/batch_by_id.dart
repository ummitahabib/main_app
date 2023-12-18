// To parse this JSON data, do
//
//     final BatchById = BatchByIdFromJson(jsonString);

class BatchById {
  BatchById({
    this.taskStatus,
    this.images,
    this.id,
    this.name,
    this.v,
    this.updatedAt,
    this.projectId,
    this.imagePath,
    this.taskId,
    this.createdAt,
  });

  int? taskStatus;
  List<String>? images;
  String? id;
  String? name;
  int? v;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? projectId;
  String? imagePath;
  String? taskId;

  factory BatchById.fromJson(Map<String, dynamic> json) => BatchById(
        taskStatus: json["taskStatus"],
        images: List<String>.from(json["images"].map((x) => x)),
        id: json["_id"],
        name: json["name"],
        v: json["__v"],
        updatedAt: json["updatedAt"] == null ? DateTime.now() : DateTime.parse(json["updatedAt"]),
        createdAt: json["createdAt"] == null ? DateTime.now() : DateTime.parse(json["createdAt"]),
        projectId: json["projectId"],
        imagePath: json["imagePath"],
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
        "orthophotoUrl": imagePath,
        "taskId": taskId,
      };
}
