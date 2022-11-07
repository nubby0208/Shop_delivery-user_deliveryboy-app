import 'CountryListModel.dart';

class CountryDetailModel {
  CountryModel? data;

  CountryDetailModel({this.data});

  CountryDetailModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new CountryModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
