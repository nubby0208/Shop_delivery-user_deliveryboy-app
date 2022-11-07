import 'PaginationModel.dart';

class CityListModel {
  PaginationModel? pagination;
  List<CityModel>? data;

  CityListModel({this.pagination, this.data});

  CityListModel.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null ? new PaginationModel.fromJson(json['pagination']) : null;
    if (json['data'] != null) {
      data = <CityModel>[];
      json['data'].forEach((v) {
        data!.add(new CityModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CityModel {
  int? id;
  String? name;
  String? address;
  int? countryId;
  String? countryName;
  int? status;
  num? fixedCharges;
  List<ExtraChargesData>? extraCharges;
  num? cancelCharges;
  num? minDistance;
  num? minWeight;
  num? perDistanceCharges;
  num? perWeightCharges;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  CityModel(
      {this.id,
      this.name,
      this.address,
      this.countryId,
      this.countryName,
      this.status,
      this.fixedCharges,
      this.extraCharges,
      this.cancelCharges,
      this.minDistance,
      this.minWeight,
      this.perDistanceCharges,
      this.perWeightCharges,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  CityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    countryId = json['country_id'];
    countryName = json['country_name'];
    status = json['status'];
    fixedCharges = json['fixed_charges'];
    if (json['extra_charges'] != null) {
      extraCharges = <ExtraChargesData>[];
      json['extra_charges'].forEach((v) {
        extraCharges!.add(new ExtraChargesData.fromJson(v));
      });
    }
    cancelCharges = json['cancel_charges'];
    minDistance = json['min_distance'];
    minWeight = json['min_weight'];
    perDistanceCharges = json['per_distance_charges'];
    perWeightCharges = json['per_weight_charges'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['country_id'] = this.countryId;
    data['country_name'] = this.countryName;
    data['status'] = this.status;
    data['fixed_charges'] = this.fixedCharges;
    if (this.extraCharges != null) {
      data['extra_charges'] = this.extraCharges!.map((v) => v.toJson()).toList();
    }
    data['cancel_charges'] = this.cancelCharges;
    data['min_distance'] = this.minDistance;
    data['min_weight'] = this.minWeight;
    data['per_distance_charges'] = this.perDistanceCharges;
    data['per_weight_charges'] = this.perWeightCharges;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

class ExtraChargesData {
  int? id;
  String? title;
  String? chargesType;
  int? charges;
  int? countryId;
  int? cityId;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  ExtraChargesData({this.id, this.title, this.chargesType, this.charges, this.countryId, this.cityId, this.status, this.createdAt, this.updatedAt, this.deletedAt});

  ExtraChargesData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    chargesType = json['charges_type'];
    charges = json['charges'];
    countryId = json['country_id'];
    cityId = json['city_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['charges_type'] = this.chargesType;
    data['charges'] = this.charges;
    data['country_id'] = this.countryId;
    data['city_id'] = this.cityId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
