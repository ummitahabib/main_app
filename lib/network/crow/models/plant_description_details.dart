import 'package:smat_crow/network/crow/models/external_link.dart';
import 'package:smat_crow/network/crow/models/external_video.dart';
import 'package:smat_crow/network/crow/models/image.dart';
import 'package:smat_crow/network/crow/models/solution.dart';

class PlantDescriptionDetail {
  PlantDescriptionDetail({
    this.name,
    this.leafName,
    this.healthyLeaf,
    this.diseaseLeaf,
    this.typeOfDisease,
    this.description,
    this.solutions,
    this.externalLinks,
    this.externalVideo,
    this.image,
  });

  String? name;
  String? leafName;
  bool? healthyLeaf;
  bool? diseaseLeaf;
  String? typeOfDisease;
  String? description;
  List<Solution>? solutions;
  List<ExternalLink>? externalLinks;
  List<ExternalVideo>? externalVideo;
  List<Image>? image;

  factory PlantDescriptionDetail.fromJson(Map<String, dynamic> json) => PlantDescriptionDetail(
        name: json["name"],
        leafName: json["leaf_name"],
        healthyLeaf: json["healthy_leaf"],
        diseaseLeaf: json["disease_leaf"],
        typeOfDisease: json["type_of_disease"],
        description: json["description"],
        solutions: json["solutions"] == null
            ? []
            : List<Solution>.from(
                json["solutions"].map((x) => Solution.fromJson(x)),
              ),
        externalLinks: json["external_links"] == null
            ? []
            : List<ExternalLink>.from(
                json["external_links"].map((x) => ExternalLink.fromJson(x)),
              ),
        externalVideo: json["external_video"] == null
            ? []
            : List<ExternalVideo>.from(
                json["external_video"].map((x) => ExternalVideo.fromJson(x)),
              ),
        image: json["image"] == null ? [] : List<Image>.from(json["image"].map((x) => Image.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "leaf_name": leafName,
        "healthy_leaf": healthyLeaf,
        "disease_leaf": diseaseLeaf,
        "type_of_disease": typeOfDisease,
        "description": description,
        "solutions": List<dynamic>.from(solutions!.map((x) => x.toJson())),
        "external_links": List<dynamic>.from(externalLinks!.map((x) => x.toJson())),
        "external_video": List<dynamic>.from(externalVideo!.map((x) => x.toJson())),
        "image": List<dynamic>.from(image!.map((x) => x.toJson())),
      };
}
