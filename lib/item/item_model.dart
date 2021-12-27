import 'package:checkstockpro/product/product_model.dart';
import 'package:checkstockpro/services/serial.dart';
import 'package:checkstockpro/services/stock_place.dart';
import 'package:checkstockpro/services/unit.dart';

class ItemModel {
  ProductItemModel? productItem;
  String? qty;
  String? unitName;
  Unit? unit;
  StockPlace? stockPlace;
  String? stockPlaceId;
  List<Serial> listSerialNumber = <Serial>[];
  String? isLotControl;
  String? lotNo;
  String? isSerial;

  // receiving
  String? manufactureDate;
  String? expiryDate;

  static ItemModel clone(ItemModel model) {
    return ItemModel()
      ..productItem = model.productItem
      ..qty = model.qty
      ..unitName = model.unitName
      ..stockPlaceId = model.stockPlaceId
      ..listSerialNumber = model.listSerialNumber
      ..lotNo = model.lotNo
      ..manufactureDate = model.manufactureDate
      ..expiryDate = model.expiryDate
      ..isLotControl = model.isLotControl
      ..isSerial = model.isSerial;
  }

  static findUnitByName(List<Unit> list, String? name) {
    if (name == null) return null;
    Unit? unit;
    list.forEach((element) {
      if (element.uomName == name) {
        unit = element;
      }
    });
    return unit;
  }

  static findStockPlaceByName(List<StockPlace> list, String? name) {
    if (name == null) return null;
    StockPlace? unit;
    list.forEach((element) {
      if (element.stockPlaceName == name) {
        unit = element;
      }
    });
    return unit;
  }

  static findStockPlaceById(List<StockPlace> list, String? id) {
    if (id == null) return null;
    StockPlace? unit;
    list.forEach((element) {
      if (element.stockPlaceId == id) {
        unit = element;
      }
    });
    return unit;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['productItem_id'] = productItem!.id;
    map['productItem_name'] = productItem!.name;
    map['productItem_code'] = productItem!.code;
    map['qty'] = qty;
    map['unit_name'] = unitName;
    map['unit_id'] = unit!.alternateUOMId.toString();
    map['placeId'] = stockPlaceId;
    map['lotNo'] = lotNo;
    map['manufactureDate'] = manufactureDate;
    map['expiryDate'] = expiryDate;
    map['isLotControl'] = isLotControl;
    map['isSerial'] = isSerial;
    return map;
  }
}
