/// rqId : "9"
/// documentNo : "RQ2021-1629947568"
/// documentDate : "2021-08-26"
/// customerName : "ลูกค้า2"
/// projectName : null
/// employeeName : "StoreEmp2"
/// status : "W"
/// rejectCommect : null

class RequisitionFromService {
  String? _rqId;
  String? _documentNo;
  String? _documentDate;
  String? _customerName;
  String? _projectName;
  String? _employeeName;
  String? _remark;
  String? _status;
  String? _rejectCommect;
  String? _cnt;
  String? _approve;

  String? get rqId => _rqId;

  String? get documentNo => _documentNo;

  String? get documentDate => _documentDate;

  String? get customerName => _customerName;

  String? get projectName => _projectName;

  String? get employeeName => _employeeName;

  String? get remark => _remark;

  String? get status => _status;

  String? get rejectCommect => _rejectCommect;

  String? get cnt => _cnt;

  String? get approve => _approve;

  RequisitionFromService(
      {String? rqId,
      String? documentNo,
      String? documentDate,
      String? customerName,
      String? projectName,
      String? employeeName,
      String? remarkId,
      String? status,
      String? rejectCommect,
      String? cnt,
      String? approve}) {
    _rqId = rqId;
    _documentNo = documentNo;
    _documentDate = documentDate;
    _customerName = customerName;
    _projectName = projectName;
    _employeeName = employeeName;
    _remark = remarkId;
    _status = status;
    _rejectCommect = rejectCommect;
    _cnt = cnt;
    _approve = approve;
  }

  RequisitionFromService.fromJson(dynamic json) {
    _rqId = json['rqId'];
    _documentNo = json['documentNo'];
    _documentDate = json['documentDate'];
    _customerName = json['customerName'];
    _projectName = json['projectName'];
    _employeeName = json['employeeName'];
    _remark = json['remark'];
    _status = json['status'];
    _rejectCommect = json['rejectCommect'];
    _cnt = json['cnt'];
    _approve = json['approve'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['rqId'] = _rqId;
    map['documentNo'] = _documentNo;
    map['documentDate'] = _documentDate;
    map['customerName'] = _customerName;
    map['projectName'] = _projectName;
    map['employeeName'] = _employeeName;
    map['remark'] = _remark;
    map['status'] = _status;
    map['rejectCommect'] = _rejectCommect;
    map['cnt'] = _cnt;
    map['approve'] = _approve;
    return map;
  }
}
