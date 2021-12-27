/// customerId : "1"
/// customerName : "ลูกค้า1"

class Customer {
  String _customerId = "";
  String _customerName = "";

  String get customerId => _customerId;
  String get customerName => _customerName;

  Customer({
      required String customerId,
      required String customerName}){
    _customerId = customerId;
    _customerName = customerName;
}

  Customer.fromJson(dynamic json) {
    _customerId = json['customerId'];
    _customerName = json['customerName'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['customerId'] = _customerId;
    map['customerName'] = _customerName;
    return map;
  }

}