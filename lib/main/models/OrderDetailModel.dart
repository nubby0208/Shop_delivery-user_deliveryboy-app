import 'OrderListModel.dart';

class OrderDetailModel {
  OrderData? data;
  List<OrderHistory>? orderHistory;

  OrderDetailModel({this.data, this.orderHistory});

  OrderDetailModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new OrderData.fromJson(json['data']) : null;
    if (json['order_history'] != null) {
      orderHistory = <OrderHistory>[];
      json['order_history'].forEach((v) {
        orderHistory!.add(new OrderHistory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.orderHistory != null) {
      data['order_history'] = this.orderHistory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderHistory {
  int? id;
  int? orderId;
  String? datetime;
  String? historyType;
  String? historyMessage;
  HistoryData? historyData;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  OrderHistory({this.id, this.orderId, this.datetime, this.historyType, this.historyMessage, this.historyData, this.createdAt, this.updatedAt, this.deletedAt});

  OrderHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    datetime = json['datetime'];
    historyType = json['history_type'];
    historyMessage = json['history_message'];
    historyData = json['history_data'] != null ? new HistoryData.fromJson(json['history_data']) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['datetime'] = this.datetime;
    data['history_type'] = this.historyType;
    data['history_message'] = this.historyMessage;
    if (this.historyData != null) {
      data['history_data'] = this.historyData!.toJson();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

class HistoryData {
  var clientId;
  String? clientName;
  var deliveryManId;
  String? deliveryManName;
  var orderId;
  String? paymentStatus;

  HistoryData({this.clientId, this.clientName, this.deliveryManName});

  HistoryData.fromJson(Map<String, dynamic> json) {
    clientId = json['client_id'];
    clientName = json['client_name'];
    deliveryManId = json['delivery_man_id'];
    deliveryManName = json['delivery_man_name'];
    orderId = json['order_id'];
    paymentStatus = json['payment_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['client_id'] = this.clientId;
    data['client_name'] = this.clientName;
    data['delivery_man_id'] = this.deliveryManId;
    data['delivery_man_name'] = this.deliveryManName;
    data['order_id'] = this.orderId;
    data['payment_status'] = this.paymentStatus;
    return data;
  }
}
