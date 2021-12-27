/// barcode : ""
/// productName : "คอมพิวเตอร์"
/// qty : "5.000"
/// uomName : "เครื่อง"

class GoodsreceiveItem {
  String? _barcode;
  String? _productId;
  String? _productName;
  String? _qty;
  String? _uomName;
  String? _isSerial;

  String? get barcode => _barcode;

  String? get productId => _productId;

  String? get productName => _productName;

  String? get qty => _qty;

  String? get uomName => _uomName;

  String? get isSerial => _isSerial;

  GoodsreceiveItem(
      {String? barcode,
      String? productId,
      String? productName,
      String? qty,
      String? uomName,
      String? isSerial}) {
    _barcode = barcode;
    _productId = productId;
    _productName = productName;
    _qty = qty;
    _uomName = uomName;
    _isSerial = isSerial;
  }

  GoodsreceiveItem.fromJson(dynamic json) {
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
    map['isSerial'] = _isSerial;
    return map;
  }
}
