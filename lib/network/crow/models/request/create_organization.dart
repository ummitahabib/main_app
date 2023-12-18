class CreateOrganizationRequest {
  String name;
  String longDescription;
  String shortDescription;
  String image;
  String address;
  String industry;
  String user;

  CreateOrganizationRequest({
    required this.name,
    required this.longDescription,
    required this.shortDescription,
    required this.image,
    required this.address,
    required this.industry,
    required this.user,
  });

  factory CreateOrganizationRequest.fromJson(Map<String, dynamic> json) => CreateOrganizationRequest(
        name: json['name'],
        longDescription: json['longDescription'],
        shortDescription: json['shortDescription'],
        image: json['image'],
        address: json['address'],
        industry: json['industry'],
        user: json['user'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['longDescription'] = longDescription;
    data['shortDescription'] = shortDescription;
    data['image'] = image;
    data['address'] = address;
    data['industry'] = industry;
    data['user'] = user;
    return data;
  }
}
