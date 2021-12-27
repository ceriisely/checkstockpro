/// groupId : "13"
/// groupName : "FG"

class ProductGroup {
  String? _groupId;
  String? _groupName;

  String? get groupId => _groupId;
  String? get groupName => _groupName;

  ProductGroup({
      String? groupId,
      String? groupName}){
    _groupId = groupId;
    _groupName = groupName;
}

  ProductGroup.fromJson(dynamic json) {
    _groupId = json['groupId'];
    _groupName = json['groupName'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['groupId'] = _groupId;
    map['groupName'] = _groupName;
    return map;
  }

}