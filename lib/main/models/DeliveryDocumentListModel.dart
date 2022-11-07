import 'PaginationModel.dart';

class DeliveryDocumentListModel {
  PaginationModel? pagination;
  List<DeliveryDocumentData>? data;

  DeliveryDocumentListModel({this.pagination, this.data});

  DeliveryDocumentListModel.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new PaginationModel.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <DeliveryDocumentData>[];
      json['data'].forEach((v) {
        data!.add(new DeliveryDocumentData.fromJson(v));
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

class DeliveryDocumentData {
  int? id;
  int? deliveryManId;
  int? documentId;
  String? documentName;
  int? isVerified;
  String? deliveryManDocument;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  DeliveryDocumentData(
      {this.id,
        this.deliveryManId,
        this.documentId,
        this.documentName,
        this.isVerified,
        this.deliveryManDocument,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  DeliveryDocumentData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    deliveryManId = json['delivery_man_id'];
    documentId = json['document_id'];
    documentName = json['document_name'];
    isVerified = json['is_verified'];
    deliveryManDocument = json['delivery_man_document'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['delivery_man_id'] = this.deliveryManId;
    data['document_id'] = this.documentId;
    data['document_name'] = this.documentName;
    data['is_verified'] = this.isVerified;
    data['delivery_man_document'] = this.deliveryManDocument;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}