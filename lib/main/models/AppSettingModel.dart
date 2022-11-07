class AppSettingModel {
  String? createdAt;
  String? facebookUrl;
  int? id;
  String? instagramUrl;
  String? linkedinUrl;
  NotificationSettings? notificationSettings;
  String? siteCopyright;
  String? siteDescription;
  String? siteEmail;
  String? siteName;
  String? supportEmail;
  String? supportNumber;
  String? twitterUrl;
  String? updatedAt;
  int? autoAssign;
  String? distanceUnit;
  num? distance;
  int? otpVerifyOnPickupDelivery;
  String? currency;
  String? currencyCode;
  String? currencyPosition;

  AppSettingModel({
    this.createdAt,
    this.facebookUrl,
    this.id,
    this.instagramUrl,
    this.linkedinUrl,
    this.notificationSettings,
    this.siteCopyright,
    this.siteDescription,
    this.siteEmail,
    this.siteName,
    this.supportEmail,
    this.supportNumber,
    this.twitterUrl,
    this.updatedAt,
    this.autoAssign,
    this.distanceUnit,
    this.distance,
    this.otpVerifyOnPickupDelivery,
    this.currency,
    this.currencyCode,
    this.currencyPosition,
  });

  factory AppSettingModel.fromJson(Map<String, dynamic> json) {
    return AppSettingModel(
      createdAt: json['created_at'],
      facebookUrl: json['facebook_url'] != null ? json['facebook_url'] : "",
      id: json['id'],
      instagramUrl: json['instagram_url'] != null ? json['instagram_url'] : "",
      linkedinUrl: json['linkedin_url'] != null ? json['linkedin_url'] : "",
      notificationSettings: json['notification_settings'] != null ? NotificationSettings.fromJson(json['notification_settings']) : null,
      siteCopyright: json['site_copyright'] != null ? json['site_copyright'] : "",
      siteDescription: json['site_description'] != null ? json['site_description'] : "",
      siteEmail: json['site_email'] != null ? json['site_email'] : "",
      siteName: json['site_name'] != null ? json['site_name'] : "",
      supportEmail: json['support_email'] != null ? json['support_email'] : "",
      supportNumber: json['support_number'] != null ? json['support_number'] : "",
      twitterUrl: json['twitter_url'] != null ? json['twitter_url'] : "",
      updatedAt: json['updated_at'],
      autoAssign: json['auto_assign'],
      distanceUnit: json['distance_unit'],
      distance: json['distance'],
      otpVerifyOnPickupDelivery: json['otp_verify_on_pickup_delivery'],
      currency: json['currency'],
      currencyCode: json['currency_code'],
      currencyPosition: json['currency_position'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['updated_at'] = this.updatedAt;
    if (this.facebookUrl != null) {
      data['facebook_url'] = this.facebookUrl;
    }
    if (this.instagramUrl != null) {
      data['instagram_url'] = this.instagramUrl;
    }
    if (this.linkedinUrl != null) {
      data['linkedin_url'] = this.linkedinUrl;
    }
    if (this.notificationSettings != null) {
      data['notification_settings'] = this.notificationSettings;
    }
    if (this.siteCopyright != null) {
      data['site_copyright'] = this.siteCopyright;
    }
    if (this.siteDescription != null) {
      data['site_description'] = this.siteDescription;
    }
    if (this.siteEmail != null) {
      data['site_email'] = this.siteEmail;
    }
    if (this.siteName != null) {
      data['site_name'] = this.siteName;
    }
    if (this.supportEmail != null) {
      data['support_email'] = this.supportEmail;
    }
    if (this.supportNumber != null) {
      data['support_number'] = this.supportNumber;
    }
    if (this.twitterUrl != null) {
      data['twitter_url'] = this.twitterUrl;
    }
    data['auto_assign'] = this.autoAssign;
    data['distance_unit'] = this.distanceUnit;
    data['distance'] = this.distance;
    data['otp_verify_on_pickup_delivery'] = this.otpVerifyOnPickupDelivery;
    data['currency'] = this.currency;
    data['currency_code'] = this.currencyCode;
    data['currency_position'] = this.currencyPosition;
    return data;
  }
}

class NotificationSettings {
  Notifications? active;
  Notifications? cancelled;
  Notifications? completed;
  Notifications? courierArrived;
  Notifications? courierAssigned;
  Notifications? courierDeparted;
  Notifications? courierPickedUp;
  Notifications? courierTransfer;
  Notifications? create;
  Notifications? delayed;
  Notifications? failed;
  Notifications? paymentStatusMessage;

  NotificationSettings(
      {this.active, this.cancelled, this.completed, this.courierArrived, this.courierAssigned, this.courierDeparted, this.courierPickedUp, this.courierTransfer, this.create, this.delayed, this.failed, this.paymentStatusMessage});

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      active: json['active'] != null ? Notifications.fromJson(json['active']) : null,
      cancelled: json['cancelled'] != null ? Notifications.fromJson(json['cancelled']) : null,
      completed: json['completed'] != null ? Notifications.fromJson(json['completed']) : null,
      courierArrived: json['courier_arrived'] != null ? Notifications.fromJson(json['courier_arrived']) : null,
      courierAssigned: json['courier_assigned'] != null ? Notifications.fromJson(json['courier_assigned']) : null,
      courierDeparted: json['courier_departed'] != null ? Notifications.fromJson(json['courier_departed']) : null,
      courierPickedUp: json['courier_picked_up'] != null ? Notifications.fromJson(json['courier_picked_up']) : null,
      courierTransfer: json['courier_transfer'] != null ? Notifications.fromJson(json['courier_transfer']) : null,
      create: json['create'] != null ? Notifications.fromJson(json['create']) : null,
      delayed: json['delayed'] != null ? Notifications.fromJson(json['delayed']) : null,
      failed: json['failed'] != null ? Notifications.fromJson(json['failed']) : null,
      paymentStatusMessage: json['payment_status_message'] != null ? Notifications.fromJson(json['payment_status_message']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.active != null) {
      data['active'] = this.active!.toJson();
    }
    if (this.cancelled != null) {
      data['cancelled'] = this.cancelled!.toJson();
    }
    if (this.completed != null) {
      data['completed'] = this.completed!.toJson();
    }
    if (this.courierArrived != null) {
      data['courier_arrived'] = this.courierArrived!.toJson();
    }
    if (this.courierAssigned != null) {
      data['courier_assigned'] = this.courierAssigned!.toJson();
    }
    if (this.courierDeparted != null) {
      data['courier_departed'] = this.courierDeparted!.toJson();
    }
    if (this.courierPickedUp != null) {
      data['courier_picked_up'] = this.courierPickedUp!.toJson();
    }
    if (this.courierTransfer != null) {
      data['courier_transfer'] = this.courierTransfer!.toJson();
    }
    if (this.create != null) {
      data['create'] = this.create!.toJson();
    }
    if (this.delayed != null) {
      data['delayed'] = this.delayed!.toJson();
    }
    if (this.failed != null) {
      data['failed'] = this.failed!.toJson();
    }
    if (this.paymentStatusMessage != null) {
      data['payment_status_message'] = this.paymentStatusMessage!.toJson();
    }
    return data;
  }
}

class Notifications {
  String? isOnesignalNotification;
  String? isFirebaseNotification;

  Notifications({this.isOnesignalNotification,this.isFirebaseNotification});

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
      isOnesignalNotification: json['IS_ONESIGNAL_NOTIFICATION'],
        isFirebaseNotification : json['IS_FIREBASE_NOTIFICATION'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IS_ONESIGNAL_NOTIFICATION'] = this.isOnesignalNotification;
    data['IS_FIREBASE_NOTIFICATION'] = this.isFirebaseNotification;
    return data;
  }
}
