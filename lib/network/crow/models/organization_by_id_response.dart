// To parse this JSON data, do
//
//     final getOrganizationById = getOrganizationByIdFromJson(jsonString);

import 'dart:convert';

GetOrganizationById getOrganizationByIdFromJson(String str) => GetOrganizationById.fromJson(json.decode(str));

String getOrganizationByIdToJson(GetOrganizationById data) => json.encode(data.toJson());

class GetOrganizationById {
  List<Site>? sites;
  List<dynamic>? organizationUsers;
  String? id;
  String? name;
  String? longDescription;
  String? shortDescription;
  String? image;
  String? address;
  String? industry;
  String? user;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  GetOrganizationById({
    this.sites,
    this.organizationUsers,
    this.id,
    this.name,
    this.longDescription,
    this.shortDescription,
    this.image,
    this.address,
    this.industry,
    this.user,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory GetOrganizationById.fromJson(Map<String, dynamic> json) => GetOrganizationById(
        sites: json["sites"] == null ? [] : List<Site>.from(json["sites"].map((x) => Site.fromJson(x))),
        organizationUsers:
            json["organizationUsers"] == null ? [] : List<dynamic>.from(json["organizationUsers"].map((x) => x)),
        id: json["_id"],
        name: json["name"],
        longDescription: json["longDescription"],
        shortDescription: json["shortDescription"],
        image: json["image"],
        address: json["address"],
        industry: json["industry"],
        user: json["user"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "sites": List<dynamic>.from(sites!.map((x) => x.toJson())),
        "organizationUsers": List<dynamic>.from(organizationUsers!.map((x) => x)),
        "_id": id,
        "name": name,
        "longDescription": longDescription,
        "shortDescription": shortDescription,
        "image": image,
        "address": address,
        "industry": industry,
        "user": user,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "__v": v,
      };
}

class Site {
  String id;
  String name;

  Site({
    required this.id,
    required this.name,
  });

  factory Site.fromJson(Map<String, dynamic> json) => Site(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}
