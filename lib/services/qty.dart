/// categoryId : "7"
/// categoryName : "Printer"

class Qty {
  String? _qtyId;
  String? _qtyName;
  String? _qtyValue;

  String? get qtyId => _qtyId;

  String? get qtyName => _qtyName;

  String? get qtyValue => _qtyValue;

  Qty({required String qtyId, required String qtyName, required String qtyValue}) {
    _qtyId = qtyId;
    _qtyName = qtyName;
    _qtyValue = qtyValue;
  }

  Qty.fromJson(dynamic json) {
    _qtyId = json['qtyId'];
    _qtyName = json['qtyName'];
    _qtyValue = json['qtyValue'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['qtyId'] = _qtyId;
    map['qtyName'] = _qtyName;
    map['qtyValue'] = _qtyValue;
    return map;
  }
}
