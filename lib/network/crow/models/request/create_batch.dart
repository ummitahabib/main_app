class CreateBatchRequest {
  CreateBatchRequest({
    required this.name,
    required this.sector,
  });

  String name;
  String sector;

  factory CreateBatchRequest.fromJson(Map<String, dynamic> json) => CreateBatchRequest(
        name: json["name"],
        sector: json["sector"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "sector": sector,
      };
}
