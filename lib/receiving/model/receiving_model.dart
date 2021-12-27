import 'package:checkstockpro/item/item_model.dart';

class ReceivingModel {
  String? grId;
  String? documentNumber;
  String? documentDate;
  String? status;
  String? cnt;
  String? supplierName;
  Supplier? supplier;
  String? referencePONo;
  String? referenceDONo;
  String? referenceInvoiceNo;
  String remark = "";
  String? rejectCommect;
  String? approve;
  List<ItemModel> itemModel = <ItemModel>[];

  static ReceivingModel clone(ReceivingModel receivingModel) {
    return ReceivingModel()
      ..grId = receivingModel.grId
      ..documentNumber = receivingModel.documentNumber
      ..documentDate = receivingModel.documentDate
      ..status = receivingModel.status
      ..cnt = receivingModel.cnt
      ..itemModel = receivingModel.itemModel
      ..supplierName = receivingModel.supplierName
      ..referenceInvoiceNo = receivingModel.referenceInvoiceNo
      ..referencePONo = receivingModel.referencePONo
      ..referenceDONo = receivingModel.referenceDONo
      ..remark = receivingModel.remark
      ..rejectCommect = receivingModel.rejectCommect
      ..approve = receivingModel.approve;
  }
}

class Supplier {
  late String supplierId;
  late String supplierName;

  Supplier.fromJson(dynamic json) {
    supplierId = json['supplierId'];
    supplierName = json['supplierName'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['supplierId'] = supplierId;
    map['supplierName'] = supplierName;
    return map;
  }

  static findSupplierByName(List<Supplier> list, String? name) {
    if (name == null) return null;
    Supplier? supplier;
    list.forEach((element) {
      if (element.supplierName == name) {
        supplier = element;
      }
    });
    return supplier;
  }

  @override
  String toString() {
    return this.supplierId;
  }
}
