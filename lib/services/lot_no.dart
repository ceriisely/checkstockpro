class LotNo {
  dynamic _lotNo;

  String? get lotNo => _lotNo.toString();

  LotNo({
    required String lotNo
  }) {
    _lotNo = lotNo;
  }

  LotNo.fromJson(dynamic json) {
    _lotNo = json['lotNo'].toString();
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['lotNo'] = _lotNo;
    return map;
  }
}