// To parse this JSON data, do
//
//     final getUserOrganizations = getUserOrganizationsFromJson(jsonString);

import 'dart:convert';

GetUserOrganizations getUserOrganizationsFromJson(String str) => GetUserOrganizations.fromJson(json.decode(str));

String getUserOrganizationsToJson(GetUserOrganizations data) => json.encode(data.toJson());

class GetUserOrganizations {
  List<String>? sites;
  List<dynamic>? organizationUsers;
  String? id;
  int? noOfSectors;
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

  GetUserOrganizations({
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
    this.noOfSectors,
  });

  factory GetUserOrganizations.fromJson(Map<String, dynamic> json) => GetUserOrganizations(
        sites: json["sites"] == null ? [] : List<String>.from(json["sites"].map((x) => x)),
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
        noOfSectors: json["noOfSectors"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "sites": List<dynamic>.from(sites!.map((x) => x)),
        "organizationUsers": List<dynamic>.from(organizationUsers!.map((x) => x)),
        "_id": id,
        "name": name,
        "longDescription": longDescription,
        "shortDescription": shortDescription,
        "image": image,
        "address": address,
        "industry": industry,
        "user": user,
        "__v": v,
      };
}
