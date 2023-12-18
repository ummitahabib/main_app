class Permission {
  String id;
  String deleted;
  int createdDate;
  int modifiedDate;
  String name;
  String title;

  Permission({
    required this.id,
    required this.deleted,
    required this.createdDate,
    required this.modifiedDate,
    required this.name,
    required this.title,
  });

  factory Permission.fromJson(Map<String, dynamic> json) => Permission(
        id: json["id"],
        deleted: json["deleted"],
        createdDate: json["createdDate"],
        modifiedDate: json["modifiedDate"],
        name: json["name"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "deleted": deleted,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "name": name,
        "title": title,
      };
}
