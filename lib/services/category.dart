/// categoryId : "7"
/// categoryName : "Printer"

class Category {
  String? _categoryId;
  String? _categoryName;

  String? get categoryId => _categoryId;
  String? get categoryName => _categoryName;

  Category({
      String? categoryId,
      String? categoryName}){
    _categoryId = categoryId;
    _categoryName = categoryName;
}

  Category.fromJson(dynamic json) {
    _categoryId = json['categoryId'];
    _categoryName = json['categoryName'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['categoryId'] = _categoryId;
    map['categoryName'] = _categoryName;
    return map;
  }

}