/// serialNo : "serial1"

class Serial {
  String? _serialNo;

  String? get serialNo => _serialNo;

  Serial({
      String? serialNo}){
    _serialNo = serialNo;
}

  Serial.fromJson(dynamic json) {
    _serialNo = json['serialNo'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['serialNo'] = _serialNo;
    return map;
  }

}