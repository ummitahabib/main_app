class DashStat {
  String statisticName;
  int statisticCount;

  DashStat({
    required this.statisticName,
    required this.statisticCount,
  });

  factory DashStat.fromJson(Map<String, dynamic> json) => DashStat(
        statisticName: json["statisticName"].toString(),
        statisticCount: json["statisticCount"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "statisticName": statisticName,
        "statisticCount": statisticCount,
      };
}
