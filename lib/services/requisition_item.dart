/// barcode : ""
/// productName : "ไวไว"
/// qty : "30.000"
/// uomName : "ห่อ"

class RequisitionItem {
  String? _barcode = "";
  String? _productId = "";
  String? _productName = "";
  String? _qty = "";
  String? _uomName = "";
  String? _isSerial = "";

  String? get barcode => _barcode;

  String? get productId => _productId;

  String? get productName => _productName;

  String? get qty => _qty;

  String? get uomName => _uomName;

  String? get isSerial => _isSerial;

  RequisitionItem(
      {required String barcode,
      required String productId,
      required String productName,
      required String qty,
      required String uomName,
      required String isSerial}) {
    _barcode = barcode;
    _productId = productId;
    _productName = productName;
    _qty = qty;
    _uomName = uomName;
    _isSerial = isSerial;
  }

  RequisitionItem.fromJson(dynamic json) {
    _barcode = json['barcode'];
    _productId = json['productId'];
    _productName = json['productName'];
    _qty = json['qty'];
    _uomName = json['uomName'];
    _isSerial = json['isSerial'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['barcode'] = _barcode;
    map['productId'] = _productId;
    map['productName'] = _productName;
    map['qty'] = _qty;
    map['uomName'] = _uomName;
    map['isSerial'] = isSerial;
    return map;
  }
}
