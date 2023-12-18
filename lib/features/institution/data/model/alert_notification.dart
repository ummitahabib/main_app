class AlertNotification {
  dynamic createdBy;
  dynamic modifiedBy;
  String? deleted;
  dynamic deletedBy;
  DateTime? createdDate;
  DateTime? modifiedDate;
  String? uuid;
  String? userId;
  String? email;
  String? phone;
  bool? emailNotifications;
  bool? smsNotifications;
  bool? whatsAppNotifications;
  bool? alertPublishedAsset;
  bool? alertDraftAsset;
  bool? alertSeasonChange;
  bool? alertUpdatedAsset;
  bool? alertPublishedLog;
  bool? alertDraftLog;
  bool? alertUpdatedLog;
  bool? alertLogThreadMessage;
  bool? alertAssetThreadMessage;

  AlertNotification({
    this.createdBy,
    this.modifiedBy,
    this.deleted,
    this.deletedBy,
    this.createdDate,
    this.modifiedDate,
    this.uuid,
    this.userId,
    this.email,
    this.phone,
    this.emailNotifications,
    this.smsNotifications,
    this.whatsAppNotifications,
    this.alertPublishedAsset,
    this.alertDraftAsset,
    this.alertSeasonChange,
    this.alertUpdatedAsset,
    this.alertPublishedLog,
    this.alertDraftLog,
    this.alertUpdatedLog,
    this.alertLogThreadMessage,
    this.alertAssetThreadMessage,
  });

  factory AlertNotification.fromJson(Map<String?, dynamic> json) => AlertNotification(
        createdBy: json["createdBy"],
        modifiedBy: json["modifiedBy"],
        deleted: json["deleted"],
        deletedBy: json["deletedBy"],
        createdDate: DateTime.parse(json["createdDate"]),
        modifiedDate: DateTime.parse(json["modifiedDate"]),
        uuid: json["uuid"],
        userId: json["userId"],
        email: json["email"],
        phone: json["phone"],
        emailNotifications: json["emailNotifications"],
        smsNotifications: json["smsNotifications"],
        whatsAppNotifications: json["whatsAppNotifications"],
        alertPublishedAsset: json["alertPublishedAsset"],
        alertDraftAsset: json["alertDraftAsset"],
        alertSeasonChange: json["alertSeasonChange"],
        alertUpdatedAsset: json["alertUpdatedAsset"],
        alertPublishedLog: json["alertPublishedLog"],
        alertDraftLog: json["alertDraftLog"],
        alertUpdatedLog: json["alertUpdatedLog"],
        alertLogThreadMessage: json["alertLogThreadMessage"],
        alertAssetThreadMessage: json["alertAssetThreadMessage"],
      );

  Map<String, dynamic> toJson() => {
        "emailNotifications": emailNotifications,
        "smsNotifications": smsNotifications,
        "whatsAppNotifications": whatsAppNotifications,
        "alertPublishedAsset": alertPublishedAsset,
        "alertDraftAsset": alertDraftAsset,
        "alertSeasonChange": alertSeasonChange,
        "alertUpdatedAsset": alertUpdatedAsset,
        "alertPublishedLog": alertPublishedLog,
        "alertDraftLog": alertDraftLog,
        "alertUpdatedLog": alertUpdatedLog,
        "alertLogThreadMessage": alertLogThreadMessage,
        "alertAssetThreadMessage": alertAssetThreadMessage,
      };
}
