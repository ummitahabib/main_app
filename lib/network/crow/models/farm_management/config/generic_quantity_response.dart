class GenericQuantityResponse {
  String status;
  String message;
  List<Data> data;

  GenericQuantityResponse({required this.status, required this.message, required this.data});

  factory GenericQuantityResponse.fromJson(Map<String, dynamic> json) => GenericQuantityResponse(
        status: json['status'],
        message: json['message'],
        data: List<Data>.from(json["data"].map((x) => Data.fromJson(x)) ?? []),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['data'] = this.data.map((v) => v.toJson()).toList();
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

  Data({
    this.createdBy,
    this.modifiedBy,
    this.deleted,
    this.deletedBy,
    this.createdDate,
    this.modifiedDate,
    this.id,
    this.quantity,
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
    quantity = json['quantity'];
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
    data['quantity'] = quantity;
    data['description'] = description;
    return data;
  }
}
