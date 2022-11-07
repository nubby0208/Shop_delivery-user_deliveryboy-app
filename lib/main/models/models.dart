import 'package:flutter/material.dart';

class WalkThroughItemModel {
  String? image;
  String? title;
  String? subTitle;

  WalkThroughItemModel({this.image, this.title, this.subTitle});
}

class BottomNavigationBarItemModel {
  IconData? icon;
  String? title;
  Widget? widget;

  BottomNavigationBarItemModel({this.icon, this.title, this.widget});
}

class SettingItemModel {
  IconData? icon;
  String? title;
  Widget? widget;

  SettingItemModel({this.icon, this.title, this.widget});
}

class AppModel {
  String? name;
  String? subTitle;
  bool isCheck;

  AppModel({this.name, this.subTitle, this.isCheck = false});
}

class FilterAttributeModel {
  String? orderStatus;
  String? fromDate;
  String? toDate;

  FilterAttributeModel({this.orderStatus, this.fromDate, this.toDate});

  FilterAttributeModel.fromJson(Map<String, dynamic> json) {
    orderStatus = json['order_status'];
    fromDate = json['from_date'];
    toDate = json['to_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_status'] = this.orderStatus;
    data['from_date'] = this.fromDate;
    data['to_date'] = this.toDate;
    return data;
  }
}


