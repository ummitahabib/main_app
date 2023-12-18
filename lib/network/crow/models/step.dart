class Steps {
  Steps({
   required this.name,
  required  this.step,
  });

  String name;
  String step;

  factory Steps.fromJson(Map<String, dynamic> json) => Steps(
        name: json["name"],
        step: json["step"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "step": step,
      };
}
