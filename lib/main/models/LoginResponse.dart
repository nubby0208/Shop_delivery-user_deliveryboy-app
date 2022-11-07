class LoginResponse {
  UserData? data;
  String? message;

  LoginResponse({this.data, this.message});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class UserData {
  String? apiToken;
  String? contactNumber;
  String? createdAt;
  String? email;
  int? id;
  String? name;
  String? profileImage;
  String? updatedAt;
  String? userType;
  String? username;
  String? address;
  int? status;
  int? countryId;
  int? cityId;
  String? cityName;
  String? countryName;
  String? latitude;
  String? longitude;
  String? emailVerifiedAt;
  String? playerId;
  String? lastNotificationSeen;
  String? uid;
  String? currentTeamId;
  String? profilePhotoPath;
  String? deletedAt;
  String? profilePhotoUrl;
  int? isVerifiedDeliveryMan;

  UserData({
    this.apiToken,
    this.contactNumber,
    this.createdAt,
    this.email,
    this.id,
    this.name,
    this.profileImage,
    this.updatedAt,
    this.userType,
    this.username,
    this.address,
    this.status,
    this.cityId,
    this.countryId,
    this.cityName,
    this.countryName,
    this.latitude,
    this.longitude,
    this.emailVerifiedAt,
    this.playerId,
    this.uid,
    this.currentTeamId,
    this.profilePhotoPath,
    this.deletedAt,
    this.isVerifiedDeliveryMan,
    this.lastNotificationSeen,
    this.profilePhotoUrl
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
        apiToken: json['api_token'],
        contactNumber: json['contact_number'],
        createdAt: json['created_at'],
        email: json['email'],
        id: json['id'],
        name: json['name'],
        profileImage: json['profile_image'],
        updatedAt: json['updated_at'],
        userType: json['user_type'],
        username: json['username'],
        address: json['address'],
        status: json['status'],
        cityId: json['city_id'],
        countryId: json['country_id'],
        cityName: json['city_name'],
        countryName: json['country_name'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        emailVerifiedAt: json['email_verified_at'],
        playerId: json['player_id'],
        uid: json['uid'],
        currentTeamId: json['current_team_id'],
        profilePhotoPath: json['profile_photo_path'],
        deletedAt: json['deleted_at'],
        isVerifiedDeliveryMan: json['is_verified_delivery_man'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['api_token'] = this.apiToken;
    data['contact_number'] = this.contactNumber;
    data['created_at'] = this.createdAt;
    data['email'] = this.email;
    data['id'] = this.id;
    data['name'] = this.name;
    data['profile_image'] = this.profileImage;
    data['updated_at'] = this.updatedAt;
    data['user_type'] = this.userType;
    data['username'] = this.username;
    data['address'] = this.address;
    data['status'] = this.status;
    data['city_id'] = this.cityId;
    data['country_id'] = this.countryId;
    data['city_name'] = this.cityName;
    data['country_name'] = this.countryName;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['player_id'] = this.playerId;
    data['uid'] = this.uid;
    data['current_team_id'] = this.currentTeamId;
    data['profile_photo_path'] = this.profilePhotoPath;
    data['deleted_at'] = this.deletedAt;
    data['is_verified_delivery_man'] = this.isVerifiedDeliveryMan;
    return data;
  }
}
