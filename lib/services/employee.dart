/// employeeId : "3"
/// employeeName : "SaleEmp1"

class Employee {
  String? _employeeId;
  String? _employeeName;

  String? get employeeId => _employeeId;
  String? get employeeName => _employeeName;

  Employee({
      String? employeeId,
      String? employeeName}){
    _employeeId = employeeId;
    _employeeName = employeeName;
}

  Employee.fromJson(dynamic json) {
    _employeeId = json['employeeId'];
    _employeeName = json['employeeName'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['employeeId'] = _employeeId;
    map['employeeName'] = _employeeName;
    return map;
  }

}