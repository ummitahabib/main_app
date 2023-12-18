class DeviceDetailsResponse {
  String? sId;
  Details? details;
  String? settingsId;
  String? notifyName;
  bool? notifyDestroy;
  bool? notifyStop;
  bool? notifyStart;
  String? shortDescription;
  String? longDescription;
  String? deviceId;
  String? userId;
  String? deviceName;
  String? name;
  int? iV;

  DeviceDetailsResponse({
    this.sId,
    this.details,
    this.settingsId,
    this.notifyName,
    this.notifyDestroy,
    this.notifyStop,
    this.notifyStart,
    this.shortDescription,
    this.longDescription,
    this.deviceId,
    this.userId,
    this.deviceName,
    this.name,
    this.iV,
  });

  DeviceDetailsResponse.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    details = json['details'] != null ? Details.fromJson(json['details']) : null;
    settingsId = json['settingsId'];
    notifyName = json['notifyName'];
    notifyDestroy = json['notifyDestroy'];
    notifyStop = json['notifyStop'];
    notifyStart = json['notifyStart'];
    shortDescription = json['shortDescription'];
    longDescription = json['longDescription'];
    deviceId = json['deviceId'];
    userId = json['userId'];
    deviceName = json['deviceName'];
    name = json['name'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['details'] = details!.toJson();
    data['settingsId'] = settingsId;
    data['notifyName'] = notifyName;
    data['notifyDestroy'] = notifyDestroy;
    data['notifyStop'] = notifyStop;
    data['notifyStart'] = notifyStart;
    data['shortDescription'] = shortDescription;
    data['longDescription'] = longDescription;
    data['deviceId'] = deviceId;
    data['userId'] = userId;
    data['deviceName'] = deviceName;
    data['name'] = name;
    data['__v'] = iV;
    return data;
  }
}

class Details {
  String? sId;
  String? ti;
  dynamic la;
  dynamic lo;
  bool? bs;
  bool? ms;
  bool? p;
  String? bp;
  String? h;
  String? t;
  dynamic m;
  int? iV;

  Details({
    this.sId,
    this.ti,
    this.la,
    this.lo,
    this.bs,
    this.ms,
    this.p,
    this.bp,
    this.h,
    this.t,
    this.m,
    this.iV,
  });

  Details.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    ti = json['ti'];
    la = json['la'];
    lo = json['lo'];
    bs = json['bs'];
    ms = json['ms'];
    p = json['p'];
    bp = json['bp'];
    h = json['h'];
    t = json['t'];
    m = json['m'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['ti'] = ti;
    data['la'] = la;
    data['lo'] = lo;
    data['bs'] = bs;
    data['ms'] = ms;
    data['p'] = p;
    data['bp'] = bp;
    data['h'] = h;
    data['t'] = t;
    data['m'] = m;
    data['__v'] = iV;
    return data;
  }
}
