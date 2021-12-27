/// grId : "23"
/// documentNo : "GR2021-1629689372"
/// documentDate : "2021-08-23"
/// status : "D"
/// cnt : "0"

class GoodsReceiveList {
  List<GoodsReceive> listGoodsReceive = <GoodsReceive>[];

  GoodsReceiveList({required this.listGoodsReceive});
}

class GoodsReceive {
  String _grId = "";
  String _documentNo = "";
  String _documentDate = "";
  String _status = "";
  String _cnt = "";
  String? _refPONo;
  String? _refDONo;
  String? _refInvoiceNo;
  String? _supplierName;
  String? _remark;
  String? _rejectCommect;

  String get grId => _grId;

  String get documentNo => _documentNo;

  String get documentDate => _documentDate;

  String get status => _status;

  String get cnt => _cnt;

  String? get refPONo => _refPONo;

  String? get refDONo => _refDONo;

  String? get refInvoiceNo => _refInvoiceNo;

  String? get supplierName => _supplierName;

  String? get remark => _remark;

  String? get rejectCommect => _rejectCommect;

  GoodsReceive(
      {required String grId,
      required String documentNo,
      required String documentDate,
      required String status,
      required String cnt,
        String? refPONo,
        String? refDONo,
        String? refInvoiceNo,
        String? supplierName,
        String? remark,
        String? rejectCommect}) {
    _grId = grId;
    _documentNo = documentNo;
    _documentDate = documentDate;
    _status = status;
    _cnt = cnt;
    _refPONo = refPONo;
    _refDONo = refDONo;
    _refInvoiceNo = refInvoiceNo;
    _supplierName = supplierName;
    _remark = remark;
    _rejectCommect = rejectCommect;
  }

  GoodsReceive.fromJson(dynamic json) {
    _grId = json['grId'];
    _documentNo = json['documentNo'];
    _documentDate = json['documentDate'];
    _status = json['status'];
    _cnt = json['cnt'];
    _refPONo = json['refPONo'];
    _refDONo = json['refDONo'];
    _refInvoiceNo = json['refInvoiceNo'];
    _supplierName = json['supplierName'];
    _remark = json['remark'];
    _rejectCommect = json['rejectCommect'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['grId'] = _grId;
    map['documentNo'] = _documentNo;
    map['documentDate'] = _documentDate;
    map['status'] = _status;
    map['cnt'] = _cnt;
    map['refPONo'] = _refPONo;
    map['refDONo'] = _refDONo;
    map['refInvoiceNo'] = _refInvoiceNo;
    map['supplierName'] = _supplierName;
    map['remark'] = _remark;
    map['rejectCommect'] = _rejectCommect;
    return map;
  }
}
