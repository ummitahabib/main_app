class SubscriptionRequest {
  bool? autoRenew;
  bool? isLocal;
  String? paymentRef;
  String? planIntervals;
  String? user;

  SubscriptionRequest({
    this.autoRenew,
    this.isLocal,
    this.paymentRef,
    this.planIntervals,
    this.user,
  });

  SubscriptionRequest.fromJson(Map<String, dynamic> json) {
    autoRenew = json['autoRenew'];
    isLocal = json['isLocal'];
    paymentRef = json['paymentRef'];
    planIntervals = json['planIntervals'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['autoRenew'] = autoRenew;
    data['isLocal'] = isLocal;
    data['paymentRef'] = paymentRef;
    data['planIntervals'] = planIntervals;
    data['user'] = user;
    return data;
  }
}
