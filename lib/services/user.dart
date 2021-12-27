/// usersname : "admin"
/// email : "icyjoy@gmail.com"
/// departmentId : "1"
/// departmentLevel : "0"
/// priGR : "1"
/// priRQ : "1"
/// permitGR : "1"
/// permitRQ : "1"
/// usersType : "1"
/// permitRQstock : "1"
/// priRP : "1"
/// rpMIN : "1"
/// createGR : "1"
/// createRQ : "1"
/// dbName : "qsim"

class User {
  String _usersname = "";
  String _email = "";
  String _departmentId = "";
  String _departmentLevel = "";
  String _priGR = "";
  String _priRQ = "";
  String _permitGR = "";
  String _permitRQ = "";
  String _usersType = "";
  String _permitRQstock = "";
  String _priRP = "";
  String _rpMIN = "";
  String _createGR = "";
  String _createRQ = "";
  String _dbName = "";

  String get usersname => _usersname;

  String get email => _email;

  String get departmentId => _departmentId;

  String get departmentLevel => _departmentLevel;

  String get priGR => _priGR;

  String get priRQ => _priRQ;

  String get permitGR => _permitGR;

  String get permitRQ => _permitRQ;

  String get usersType => _usersType;

  String get permitRQstock => _permitRQstock;

  String get priRP => _priRP;

  String get rpMIN => _rpMIN;

  String get createGR => _createGR;

  String get createRQ => _createRQ;

  String get dbName => _dbName;

  User(
      {required String usersname,
      required String email,
      required String departmentId,
      required String departmentLevel,
      required String priGR,
      required String priRQ,
      required String permitGR,
      required String permitRQ,
      required String usersType,
      required String permitRQstock,
      required String priRP,
      required String rpMIN,
      required String createGR,
      required String createRQ,
      required String dbName}) {
    _usersname = usersname;
    _email = email;
    _departmentId = departmentId;
    _departmentLevel = departmentLevel;
    _priGR = priGR;
    _priRQ = priRQ;
    _permitGR = permitGR;
    _permitRQ = permitRQ;
    _usersType = usersType;
    _permitRQstock = permitRQstock;
    _priRP = priRP;
    _rpMIN = rpMIN;
    _createGR = createGR;
    _createRQ = createRQ;
    _dbName = dbName;
  }

  User.fromJson(dynamic json) {
    _usersname = json['usersname'];
    _email = json['email'];
    _departmentId = json['departmentId'];
    _departmentLevel = json['departmentLevel'];
    _priGR = json['priGR'];
    _priRQ = json['priRQ'];
    _permitGR = json['permitGR'];
    _permitRQ = json['permitRQ'];
    _usersType = json['usersType'];
    _permitRQstock = json['permitRQstock'];
    _priRP = json['priRP'];
    _rpMIN = json['rpMIN'];
    _createGR = json['createGR'];
    _createRQ = json['createRQ'];
    _dbName = json['dbName'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['usersname'] = _usersname;
    map['email'] = _email;
    map['departmentId'] = _departmentId;
    map['departmentLevel'] = _departmentLevel;
    map['priGR'] = _priGR;
    map['priRQ'] = _priRQ;
    map['permitGR'] = _permitGR;
    map['permitRQ'] = _permitRQ;
    map['usersType'] = _usersType;
    map['permitRQstock'] = _permitRQstock;
    map['priRP'] = _priRP;
    map['rpMIN'] = _rpMIN;
    map['createGR'] = _createGR;
    map['createRQ'] = _createRQ;
    map['dbName'] = _dbName;
    return map;
  }
}
