class DashSummary {
  List<Upcoming> upcoming;
  List<Upcoming> paid;

  DashSummary({
    required this.upcoming,
    required this.paid,
  });

  factory DashSummary.fromJson(Map<String, dynamic> json) => DashSummary(
        upcoming: List<Upcoming>.from(json["upcoming"].map((x) => Upcoming.fromJson(x))),
        paid: List<Upcoming>.from(json["paid"].map((x) => Upcoming.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "upcoming": List<dynamic>.from(upcoming.map((x) => x.toJson())),
        "paid": List<dynamic>.from(paid.map((x) => x)),
      };
}

class Upcoming {
  String month;
  List<DashType> types;

  Upcoming({
    required this.month,
    required this.types,
  });

  factory Upcoming.fromJson(Map<String, dynamic> json) => Upcoming(
        month: json["month"],
        types: List<DashType>.from(json["types"].map((x) => DashType.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "month": month,
        "types": List<dynamic>.from(types.map((x) => x.toJson())),
      };
}

class DashType {
  double sum;
  String type;

  DashType({
    required this.sum,
    required this.type,
  });

  factory DashType.fromJson(Map<String, dynamic> json) => DashType(
        sum: json["sum"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "sum": sum,
        "type": type,
      };
}
