/// stockPlaceId : "1"
/// stockPlaceName : "?????1"

class StockPlace {
  String _stockPlaceId = "";
  String _stockPlaceName = "";
  String? _productOnhand = "";
  String? _stockOnhand = "";

  String get stockPlaceId => _stockPlaceId;

  String get stockPlaceName => _stockPlaceName;

  String get productOnhand => _productOnhand.toString();

  String get stockOnhand => _stockOnhand.toString();

  StockPlace({
    required String stockPlaceId,
    required String stockPlaceName,
    String? productOnhand,
    String? stockOnhand}) {
    _stockPlaceId = stockPlaceId;
    _stockPlaceName = stockPlaceName;
    _productOnhand = productOnhand;
    _stockOnhand = stockOnhand;
  }

  StockPlace.fromJson(dynamic json) {
    _stockPlaceId = json['stockPlaceId'];
    _stockPlaceName = json['stockPlaceName'];
    _productOnhand = json['productOnhand'];
    _stockOnhand = json['stockOnhand'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['stockPlaceId'] = _stockPlaceId;
    map['stockPlaceName'] = _stockPlaceName;
    map['productOnhand'] = _productOnhand;
    map['stockOnhand'] = _stockOnhand;
    return map;
  }

}