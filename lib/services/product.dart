/// productId : "9"
/// productCode : "PROD-009"
/// productName : "HW Serial"

class Product {
  String _productId = "";
  String _productCode = "";
  String _productName = "";
  String _qty = "";
  String _unit = "";
  String? _isSerial = "";
  String? _isLotControl = "";

  String get productId => _productId;

  String get productCode => _productCode;

  String get productName => _productName;

  String get qty => _qty;

  String get unit => _unit;

  String get isSerial => _isSerial ?? '';

  String get isLotControl => _isLotControl ?? '';

  Product(
      {required String productId,
      required String productCode,
      required String productName,
      required String qty,
      required String unit,
      required String isSerial,
      required String isLotControl}) {
    _productId = productId;
    _productCode = productCode;
    _productName = productName;
    _qty = qty;
    _unit = unit;
    _isSerial = isSerial;
    _isLotControl = isLotControl;
  }

  Product.fromJson(dynamic json) {
    _productId = json['productId'];
    _productCode = json['productCode'];
    _productName = json['productName'];
    _qty = json['qty'];
    _unit = json['unit'];
    _isSerial = json['isSerial'];
    _isLotControl = json['isLotControl'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['productId'] = _productId;
    map['productCode'] = _productCode;
    map['productName'] = _productName;
    map['qty'] = _qty;
    map['unit'] = _unit;
    map['isSerial'] = _isSerial;
    map['isLotControl'] = _isLotControl;
    return map;
  }
}
