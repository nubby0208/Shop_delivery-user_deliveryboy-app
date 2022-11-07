import 'package:mighty_delivery/main/models/PaginationModel.dart';

class CountryListModel {
  List<CountryModel>? data;
  PaginationModel? pagination;

  CountryListModel({this.data, this.pagination});

  factory CountryListModel.fromJson(Map<String, dynamic> json) {
    return CountryListModel(
      data: json['data'] != null ? (json['data'] as List).map((i) => CountryModel.fromJson(i)).toList() : null,
      pagination: json['pagination'] != null ? PaginationModel.fromJson(json['pagination']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class CountryModel {
  String? createdAt;
  String? deletedAt;
  String? distanceType;
  int? id;
  var links;
  String? name;
  int? status;
  String? updatedAt;
  String? weightType;
  String? code;

  CountryModel({
    this.createdAt,
    this.deletedAt,
    this.distanceType,
    this.id,
    this.links,
    this.name,
    this.status,
    this.updatedAt,
    this.weightType,
    this.code,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      createdAt: json['created_at'],
      deletedAt: json['deleted_at'],
      distanceType: json['distance_type'],
      id: json['id'],
      links: json['links'],
      name: json['name'],
      status: json['status'],
      updatedAt: json['updated_at'],
      weightType: json['weight_type'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.createdAt;
    data['deleted_at'] = this.deletedAt;
    data['distance_type'] = this.distanceType;
    data['id'] = this.id;
    data['links'] = this.links;
    data['name'] = this.name;
    data['status'] = this.status;
    data['updated_at'] = this.updatedAt;
    data['weight_type'] = this.weightType;
    data['code'] = this.code;
    return data;
  }
}
