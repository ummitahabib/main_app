import 'step.dart';

class Solution {
  Solution({
    this.name,
    this.solution,
    this.steps,
  });

  String? name;
  String? solution;
  List<Steps>? steps;

  factory Solution.fromJson(Map<String, dynamic> json) => Solution(
        name: json["name"],
        solution: json["solution"],
        steps: List<Steps>.from(json["steps"].map((x) => Steps.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "solution": solution,
        "steps": List<dynamic>.from(steps!.map((x) => x.toJson())),
      };
}
