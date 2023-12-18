class Image {
  Image({
    required this.name,
    required this.image,
  });

  String name;
  String image;

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
      };
}
