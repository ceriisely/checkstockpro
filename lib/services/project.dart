/// customerId : "1"
/// projectCode : "CUSTP-001"
/// projectName : "โปรเจค1"

class Project {
  String _customerId = "";
  String _projectCode = "";
  String _projectName = "";

  String get customerId => _customerId;
  String get projectCode => _projectCode;
  String get projectName => _projectName;

  Project({
      required String customerId,
      required String projectCode,
      required String projectName}){
    _customerId = customerId;
    _projectCode = projectCode;
    _projectName = projectName;
}

  Project.fromJson(dynamic json) {
    _customerId = json['customerId'];
    _projectCode = json['projectCode'];
    _projectName = json['projectName'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['customerId'] = _customerId;
    map['projectCode'] = _projectCode;
    map['projectName'] = _projectName;
    return map;
  }

}