class GenericStatusResponse {
  String? status;
  String? message;
  List<Data>? data;

  GenericStatusResponse({this.status, this.message, this.data});

  GenericStatusResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['data'] = this.data!.map((v) => v.toJson()).toList();
    return data;
  }
}

class Data {
  String? createdBy;
  dynamic modifiedBy;
  String? deleted;
  dynamic deletedBy;
  String? createdDate;
  String? modifiedDate;
  int? id;
  String? quantity;
  String? description;
  String? status;

  Data({
    this.createdBy,
    this.modifiedBy,
    this.deleted,
    this.deletedBy,
    this.createdDate,
    this.modifiedDate,
    this.id,
    this.status,
    this.description,
  });

  Data.fromJson(Map<String, dynamic> json) {
    createdBy = json['created_by'];
    modifiedBy = json['modified_by'];
    deleted = json['deleted'];
    deletedBy = json['deleted_by'];
    createdDate = json['created_date'];
    modifiedDate = json['modified_date'];
    id = json['id'];
    status = json['status'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['created_by'] = createdBy;
    data['modified_by'] = modifiedBy;
    data['deleted'] = deleted;
    data['deleted_by'] = deletedBy;
    data['created_date'] = createdDate;
    data['modified_date'] = modifiedDate;
    data['id'] = id;
    data['status'] = status;
    data['description'] = description;
    return data;
  }
}
