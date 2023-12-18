import 'package:smat_crow/network/crow/models/plant_description_details.dart';

class FarmProbeResponse {
  bool lowAccuracy;
  bool lowContrast;
  String filename;
  String accuracy;
  List<PlantDescriptionDetail> plantDescriptionDetails;
  String uploaded;

  FarmProbeResponse({
    required this.lowAccuracy,
    required this.lowContrast,
    required this.filename,
    required this.accuracy,
    required this.plantDescriptionDetails,
    required this.uploaded,
  });

  factory FarmProbeResponse.fromJson(Map<String, dynamic> json) => FarmProbeResponse(
        lowAccuracy: json["low_accuracy"],
        lowContrast: json["low_contrast"],
        filename: json["filename"],
        accuracy: json["accuracy"],
        plantDescriptionDetails: List<PlantDescriptionDetail>.from(
          json["plant_description_details"].map((x) => PlantDescriptionDetail.fromJson(x)),
        ),
        uploaded: json["uploaded"],
      );

  Map<String, dynamic> toJson() => {
        "low_accuracy": lowAccuracy,
        "low_contrast": lowContrast,
        "filename": filename,
        "accuracy": accuracy,
        "plant_description_details": List<dynamic>.from(plantDescriptionDetails.map((x) => x.toJson())),
        "uploaded": uploaded,
      };
}
