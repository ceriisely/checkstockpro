/// alternateUOMId : "6"
/// uomName : "กล่อง"

class Unit {
  String? _alternateUOMId;
  String? _uomName;

  String? get alternateUOMId => _alternateUOMId;
  String? get uomName => _uomName;

  Unit({
      required String alternateUOMId,
      required String uomName}){
    _alternateUOMId = alternateUOMId;
    _uomName = uomName;
}

  Unit.fromJson(dynamic json) {
    _alternateUOMId = json['alternateUOMId'];
    _uomName = json['uomName'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['alternateUOMId'] = _alternateUOMId;
    map['uomName'] = _uomName;
    return map;
  }

  bool operator ==(dynamic other) =>
      other != null;

  @override
  int get hashCode => super.hashCode;
}