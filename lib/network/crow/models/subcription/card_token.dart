class CardToken {
  String? id;
  String? deleted;
  int? createdDate;
  int? modifiedDate;
  String? authorizationCode;
  String? last4;
  String? expMonth;
  String? expYear;
  String? cardType;
  String? countryCode;

  CardToken({
    this.id,
    this.deleted,
    this.createdDate,
    this.modifiedDate,
    this.authorizationCode,
    this.last4,
    this.expMonth,
    this.expYear,
    this.cardType,
    this.countryCode,
  });

  CardToken.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    deleted = json['deleted'];
    createdDate = json['created_date'];
    modifiedDate = json['modified_date'];
    authorizationCode = json['authorizationCode'];
    last4 = json['last4'];
    expMonth = json['expMonth'];
    expYear = json['expYear'];
    cardType = json['cardType'];
    countryCode = json['countryCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['deleted'] = deleted;
    data['created_date'] = createdDate;
    data['modified_date'] = modifiedDate;
    data['authorizationCode'] = authorizationCode;
    data['last4'] = last4;
    data['expMonth'] = expMonth;
    data['expYear'] = expYear;
    data['cardType'] = cardType;
    data['countryCode'] = countryCode;
    return data;
  }
}
