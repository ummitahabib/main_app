class DashBreakdown {
  double seasonBudget;
  List<BudgetBreakdown> budgetBreakdown;

  DashBreakdown({
    required this.seasonBudget,
    required this.budgetBreakdown,
  });

  factory DashBreakdown.fromJson(Map<String, dynamic> json) => DashBreakdown(
        seasonBudget: json["seasonBudget"],
        budgetBreakdown: List<BudgetBreakdown>.from(json["budgetBreakdown"].map((x) => BudgetBreakdown.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "seasonBudget": seasonBudget,
        "budgetBreakdown": List<dynamic>.from(budgetBreakdown.map((x) => x.toJson())),
      };
}

class BudgetBreakdown {
  String month;
  double asset;
  double log;
  double balance;

  BudgetBreakdown({
    required this.month,
    required this.asset,
    required this.log,
    required this.balance,
  });

  factory BudgetBreakdown.fromJson(Map<String, dynamic> json) => BudgetBreakdown(
        month: json["month"],
        asset: json["asset"],
        log: json["log"],
        balance: json["balance"],
      );

  Map<String, dynamic> toJson() => {
        "month": month,
        "asset": asset,
        "log": log,
        "balance": balance,
      };
}
