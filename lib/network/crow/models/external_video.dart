class ExternalVideo {
  ExternalVideo({
  required  this.name,
  required  this.video,
  });

  String name;
  String video;

  factory ExternalVideo.fromJson(Map<String, dynamic> json) => ExternalVideo(
        name: json["name"],
        video: json["video"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "video": video,
      };
}
