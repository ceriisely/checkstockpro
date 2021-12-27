/// productId : null
/// productName : null
/// uomId : null
/// uomName : null
/// stockId : "1"
/// stockName : "โกดัง1"

class ProductByBarCode {
  String? _productId;
  String? _productName;
  String? _uomId;
  String? _uomName;
  String? _stockId;
  String? _stockName;
  int? _lotNo;
  String? _isSerial = "";
  String? _isLotControl = "";

  String? get productId => _productId;

  String? get productName => _productName;

  String? get uomId => _uomId;

  String? get uomName => _uomName;

  String? get stockId => _stockId;

  String? get stockName => _stockName;

  int? get lotNo => _lotNo;

  String get isSerial => _isSerial ?? '';

  String get isLotControl => _isLotControl ?? '';

  ProductByBarCode(
      {String? productId,
      String? productName,
      String? uomId,
      String? uomName,
      String? stockId,
      String? stockName,
      int? lotNo,
        String? isSerial,
        String? isLotControl}) {
    _productId = productId;
    _productName = productName;
    _uomId = uomId;
    _uomName = uomName;
    _stockId = stockId;
    _stockName = stockName;
    _lotNo = lotNo;
    _isSerial = isSerial;
    _isLotControl = isLotControl;
  }

  ProductByBarCode.fromJson(dynamic json) {
    _productId = json['productId'];
    _productName = json['productName'];
    _uomId = json['uomId'];
    _uomName = json['uomName'];
    _stockId = json['stockId'];
    _stockName = json['stockName'];
    _lotNo = json['lotNo'];
    _isSerial = json['isSerial'];
    _isLotControl = json['isLotControl'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['productId'] = _productId;
    map['productName'] = _productName;
    map['uomId'] = _uomId;
    map['uomName'] = _uomName;
    map['stockId'] = _stockId;
    map['stockName'] = _stockName;
    map['lotNo'] = _lotNo;
    map['isSerial'] = _isSerial;
    map['isLotControl'] = _isLotControl;
    return map;
  }
}
