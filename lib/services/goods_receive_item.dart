/// grId : "23"
/// documentNo : "GR2021-1629689372"
/// documentDate : "2021-08-23"
/// status : "D"
/// cnt : "0"

class GoodsReceiveItem {
  String? _grId = "";
  String? _documentNo = "";
  String? _documentDate = "";
  String? _status = "";
  String? _refPONo = "";
  String? _refDONo = "";
  String? _refInvoiceNo = "";
  String? _supplierName = "";
  String? _remark;
  String? _rejectCommect;
  String? _cnt;
  String? _approve;

  String? get grId => _grId;

  String? get documentNo => _documentNo;

  String? get documentDate => _documentDate;

  String? get status => _status;

  String? get refPONo => _refPONo;

  String? get refDONo => _refDONo;

  String? get refInvoiceNo => _refInvoiceNo;

  String? get supplierName => _supplierName;

  String? get remark => _remark;

  String? get rejectCommect => _rejectCommect;

  String? get cnt => _cnt;

  String? get approve => _approve;

  GoodsReceiveItem(
      {String? grId,
      String? documentNo,
      String? documentDate,
      String? status,
      String? refPONo,
      String? refDONo,
      String? refInvoiceNo,
      String? supplierName,
      String? remark,
      String? rejectCommect,
      String? cnt,
        String? approve}) {
    _grId = grId;
    _documentNo = documentNo;
    _documentDate = documentDate;
    _status = status;
    _refPONo = refPONo;
    _refDONo = refDONo;
    _refInvoiceNo = refInvoiceNo;
    _supplierName = supplierName;
    _remark = remark;
    _rejectCommect = rejectCommect;
    _cnt = cnt;
    _approve = approve;
  }

  GoodsReceiveItem.fromJson(dynamic json) {
    _grId = json['grId'];
    _documentNo = json['documentNo'];
    _documentDate = json['documentDate'];
    _status = json['status'];
    _refPONo = json['refPONo'];
    _refDONo = json['refDONo'];
    _refInvoiceNo = json['refInvoiceNo'];
    _supplierName = json['supplierName'];
    _remark = json['remark'];
    _rejectCommect = json['rejectCommect'];
    _cnt = json['cnt'];
    _approve = json['approve'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['grId'] = _grId;
    map['documentNo'] = _documentNo;
    map['documentDate'] = _documentDate;
    map['status'] = _status;
    map['refPONo'] = _refPONo;
    map['refDONo'] = _refDONo;
    map['refInvoiceNo'] = _refInvoiceNo;
    map['supplierName'] = _supplierName;
    map['remark'] = _remark;
    map['rejectCommect'] = _rejectCommect;
    map['cnt'] = _cnt;
    map['approve'] = _approve;
    return map;
  }
}
