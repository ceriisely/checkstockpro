/// remarkId : "1"
/// remarkName : "???????????????"

class Remark {
  String? _remarkId;
  String? _remarkName;

  String? get remarkId => _remarkId;
  String? get remarkName => _remarkName;

  Remark({
      required String remarkId,
      required String remarkName}){
    _remarkId = remarkId;
    _remarkName = remarkName;
}

  Remark.fromJson(dynamic json) {
    _remarkId = json['remarkId'];
    _remarkName = json['remarkName'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['remarkId'] = _remarkId;
    map['remarkName'] = _remarkName;
    return map;
  }

}