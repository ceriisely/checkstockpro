import 'dart:convert';

import 'package:checkstockpro/item/item_model.dart';
import 'package:checkstockpro/product/product_model.dart';
import 'package:checkstockpro/receiving/model/receiving_model.dart';
import 'package:checkstockpro/requisition/model/requisition_model.dart';
import 'package:checkstockpro/services/category.dart';
import 'package:checkstockpro/services/customer.dart';
import 'package:checkstockpro/services/employee.dart';
import 'package:checkstockpro/services/goods_receive_item.dart';
import 'package:checkstockpro/services/goods_receive_list.dart';
import 'package:checkstockpro/services/product.dart';
import 'package:checkstockpro/services/product_by_bar_code.dart';
import 'package:checkstockpro/services/product_group.dart';
import 'package:checkstockpro/services/project.dart';
import 'package:checkstockpro/services/remark.dart';
import 'package:checkstockpro/services/requisition_from_service.dart';
import 'package:checkstockpro/services/requisition_item.dart';
import 'package:checkstockpro/services/serial.dart';
import 'package:checkstockpro/services/stock_place.dart';
import 'package:checkstockpro/services/unit.dart';
import 'package:checkstockpro/services/user.dart';
import 'package:checkstockpro/sharedpref/shared_pref_user.dart';
import 'package:http/http.dart' as Http;

import 'goodsreceive_item.dart';
import 'lot_no.dart';

class Services {
  static Future<List<ReceivingModel>> getGoodsReceiveLst() async {
    var url = Uri.parse(
        "http://45.91.132.217/api/getGoodsreceiveLst.php?username=" +
            SharedPref.userNameValuesSF.toString() +
            "&dbName" +
            SharedPref.dbNameValueSF.toString());
    print("request getGoodsReceiveLst = " + url.toString());
    var response = await Http.get(url);
    print("response getGoodsReceiveLst = " + response.body);
    List listJson = json.decode(response.body);
    List<ReceivingModel> list = <ReceivingModel>[];
    if (listJson.isEmpty) return list;
    GoodsReceive model;
    listJson.forEach((element) {
      model = GoodsReceive.fromJson(element);
      list.add(ReceivingModel()
        ..grId = model.grId
        ..documentNumber = model.documentNo
        ..documentDate = model.documentDate
        ..status = model.status
        ..cnt = model.cnt);
    });
    return list;
  }

  static Future<List<ReceivingModel>> getGoodsreceiveW() async {
    var url = Uri.parse(
        "http://45.91.132.217/api/getGoodsreceiveW.php?username=" +
            SharedPref.userNameValuesSF.toString() +
            "&dbName=" +
            SharedPref.dbNameValueSF.toString());
    print("request getGoodsreceiveW = " + url.toString());
    var response = await Http.get(url);
    print("response getGoodsreceiveW = " + response.body);
    List listJson = json.decode(response.body);
    List<ReceivingModel> list = <ReceivingModel>[];
    if (listJson.isEmpty) return list;
    GoodsReceive model;
    listJson.forEach((element) {
      model = GoodsReceive.fromJson(element);
      list.add(ReceivingModel()
        ..grId = model.grId
        ..documentNumber = model.documentNo
        ..documentDate = model.documentDate
        ..status = model.status
        ..cnt = model.cnt);
    });
    return list;
  }

  static Future<List<RequisitionModel>> getRequisitionLst() async {
    var url = Uri.parse(
        "http://45.91.132.217/api/getRequisitionLst.php?username=" +
            SharedPref.userNameValuesSF.toString() +
            "&dbName=" +
            SharedPref.dbNameValueSF.toString());
    print("request getRequisitionLst = " + url.toString());
    var response = await Http.get(url);
    print("response getRequisitionLst = " + response.body);
    List listJson = json.decode(response.body);
    List<RequisitionModel> list = <RequisitionModel>[];
    if (listJson.isEmpty) return list;
    RequisitionFromService model;
    listJson.forEach((element) {
      model = RequisitionFromService.fromJson(element);
      list.add(RequisitionModel()
        ..rqId = model.rqId
        ..documentNumber = model.documentNo
        ..documentDate = model.documentDate
        ..status = model.status
        ..cnt = model.cnt);
    });
    return list;
  }

  static Future<List<RequisitionModel>> getRequisitionW() async {
    var url = Uri.parse(
        "http://45.91.132.217/api/getRequisitionW.php?username=" +
            SharedPref.userNameValuesSF.toString() +
            "&dbName=" +
            SharedPref.dbNameValueSF.toString());
    print("request getRequisitionW = " + url.toString());
    var response = await Http.get(url);
    print("response getRequisitionW = " + response.body);
    List listJson = json.decode(response.body);
    List<RequisitionModel> list = <RequisitionModel>[];
    if (listJson.isEmpty) return list;
    RequisitionFromService model;
    listJson.forEach((element) {
      model = RequisitionFromService.fromJson(element);
      list.add(RequisitionModel()
        ..rqId = model.rqId
        ..documentNumber = model.documentNo
        ..documentDate = model.documentDate
        ..status = model.status
        ..cnt = model.cnt);
    });
    return list;
  }

  static Future<RequisitionModel> getRequisitionByRqId(String rqId) async {
    var url = Uri.parse("http://45.91.132.217/api/getRequisition.php?rqId=" +
        rqId +
        "&dbName=" +
        SharedPref.dbNameValueSF.toString() +
        "&username=" +
        SharedPref.userNameValuesSF.toString());
    print("request getRequisitionByRqId = " + url.toString());
    var response = await Http.get(url);
    print("response getRequisitionByRqId = " + response.body);
    RequisitionFromService model =
        RequisitionFromService.fromJson(json.decode(response.body));
    RequisitionModel requisitionModel = RequisitionModel();
    // if (listJson.isEmpty) return requisitionModel;
    // RequisitionFromService model;
    // listJson.forEach((element) {
    //   model = RequisitionFromService.fromJson(element);
    requisitionModel = RequisitionModel()
      ..rqId = model.rqId
      ..cnt = model.cnt
      ..documentNumber = model.documentNo
      ..documentDate = model.documentDate
      ..customerName = model.customerName
      ..employeeName = model.employeeName
      ..projectName = model.projectName
      ..remarkName = model.remark
      ..status = model.status
      ..approve = model.approve;
    // });
    return requisitionModel;
  }

  static Future<List<Supplier>> getSuppliers() async {
    var url = Uri.parse("http://45.91.132.217/api/getSuppliers.php" +
        "?dbName=" +
        SharedPref.dbNameValueSF.toString());
    print("request getSuppliers = " + url.toString());
    var response = await Http.get(url);
    // print("response getSuppliers = " + response.body);
    // List listJson = json.decode(response.body);
    Iterable listJson = json.decode(response.body);
    List<Supplier> list =
        List<Supplier>.from(listJson.map((model) => Supplier.fromJson(model)));
    // List<Supplier> list = <Supplier>[];
    // if (listJson.isEmpty) return list;
    // Supplier model;
    // listJson.forEach((element) {
    //   model = Supplier.fromJson(element);
    //   list.add(model);
    // });
    return list;
  }

  static Future<List<Customer>> getCustomers() async {
    var url = Uri.parse("http://45.91.132.217/api/getCustomers.php" +
        "?dbName=" +
        SharedPref.dbNameValueSF.toString());
    print("request getCustomers = " + url.toString());
    var response = await Http.get(url);
    print("response getCustomers = " + response.body);
    List listJson = json.decode(response.body);
    List<Customer> list = <Customer>[];
    if (listJson.isEmpty) return list;
    Customer model;
    listJson.forEach((element) {
      model = Customer.fromJson(element);
      list.add(model);
    });
    return list;
  }

  static Future<List<Project>> getProject(custId) async {
    var url = Uri.parse("http://45.91.132.217/api/getProject.php?custId=" +
        custId +
        "&dbName=" +
        SharedPref.dbNameValueSF.toString());
    print("request getProject = " + url.toString());
    var response = await Http.get(url);
    print("response getProject = " + response.body);
    List listJson = json.decode(response.body);
    List<Project> list = <Project>[];
    if (listJson.isEmpty) return list;
    Project model;
    listJson.forEach((element) {
      model = Project.fromJson(element);
      list.add(model);
    });
    return list;
  }

  static Future<List<Employee>> getEmployee() async {
    var url = Uri.parse("http://45.91.132.217/api/getEmployee.php" +
        "?dbName=" +
        SharedPref.dbNameValueSF.toString());
    print("request getEmployee = " + url.toString());
    var response = await Http.get(url);
    print("response getEmployee = " + response.body);
    List listJson = json.decode(response.body);
    List<Employee> list = <Employee>[];
    if (listJson.isEmpty) return list;
    Employee model;
    listJson.forEach((element) {
      model = Employee.fromJson(element);
      list.add(model);
    });
    return list;
  }

  static Future<ReceivingModel> getGoodsReceive(String grId) async {
    var url = Uri.parse("http://45.91.132.217/api/getGoodsreceive.php?grId=" +
        grId +
        "&dbName=" +
        SharedPref.dbNameValueSF.toString() +
        "&username=" +
        SharedPref.userNameValuesSF.toString());
    print("request getGoodsReceive = " + url.toString());
    var response = await Http.get(url);
    print("response getGoodsReceive = " + response.body);
    print(json.decode(response.body));
    GoodsReceiveItem model =
        GoodsReceiveItem.fromJson(json.decode(response.body));
    // GoodsReceiveItem model;
    late ReceivingModel receivingModel;
    // list.forEach((element) {
    //   model = GoodsReceiveItem.fromJson(element);
    receivingModel = ReceivingModel()
      ..grId = model.grId
      ..cnt = model.cnt
      ..documentNumber = model.documentNo
      ..documentDate = model.documentDate
      ..status = model.status
      ..supplierName = model.supplierName
      ..referenceInvoiceNo = model.refInvoiceNo
      ..referencePONo = model.refPONo
      ..referenceDONo = model.refDONo
      ..remark = (model.remark != null ? model.remark : '')!
      ..approve = model.approve;
    // });
    return receivingModel;
  }

  static Future<List<Product>> getProduct() async {
    var url = Uri.parse("http://45.91.132.217/api/getProduct.php" +
        "?dbName=" +
        SharedPref.dbNameValueSF.toString());
    print("request getProduct = " + url.toString());
    var response = await Http.get(url);
    print("response getProduct = " + response.body);
    List list = json.decode(response.body);
    List<Product> listProduct = <Product>[];
    Product model;
    list.forEach((element) {
      model = Product.fromJson(element);
      listProduct.add(model);
    });
    return listProduct;
  }

  static Future<List<Product>> getProductById(productId) async {
    var url = Uri.parse("http://45.91.132.217/api/getProduct.php?productId=" +
        productId +
        "&dbName=" +
        SharedPref.dbNameValueSF.toString());
    print("request getProductById = " + url.toString());
    var response = await Http.get(url);
    print("response getProductById = " + response.body);
    List list = json.decode(response.body);
    List<Product> listProduct = <Product>[];
    Product model;
    list.forEach((element) {
      model = Product.fromJson(element);
      listProduct.add(model);
    });
    return listProduct;
  }

  static Future<List<StockPlace>> getStockplace(
      String barcode, String productId) async {
    var url = Uri.parse("http://45.91.132.217/api/getStockplace.php" +
        "?dbName=" +
        SharedPref.dbNameValueSF.toString() +
        "&barcode=" +
        barcode +
        "&productId=" +
        productId);
    print("request getStockplace = " + url.toString());
    var response = await Http.get(url);
    print("response getStockplace = " + response.body);
    List list = json.decode(response.body);
    List<StockPlace> listStockPlace = <StockPlace>[];
    StockPlace model;
    list.forEach((element) {
      model = StockPlace.fromJson(element);
      listStockPlace.add(model);
    });
    return listStockPlace;
  }

  static Future<List<StockPlace>> getStockplaceRQ(
      String barcode, String productId) async {
    var url = Uri.parse("http://45.91.132.217/api/getStockplaceRQ.php" +
        "?dbName=" +
        SharedPref.dbNameValueSF.toString() +
        "&barcode=" +
        barcode +
        "&productId=" +
        productId);
    print("request getStockplaceRQ = " + url.toString());
    return Http.get(url).then((response) {
      print("response getStockplaceRQ then = " + response.body);
      List list = json.decode(response.body);
      List<StockPlace> listStockPlace = <StockPlace>[];
      StockPlace model;
      list.forEach((element) {
        model = StockPlace.fromJson(element);
        listStockPlace.add(model);
      });
      return listStockPlace;
    });
    // print("response getStockplaceRQ = " + response.body);
    // List list = json.decode(response.body);
    // List<StockPlace> listStockPlace = <StockPlace>[];
    // StockPlace model;
    // list.forEach((element) {
    //   model = StockPlace.fromJson(element);
    //   listStockPlace.add(model);
    // });
    // return listStockPlace;
  }

  static Future<List<Unit>> getUnit(String productId, String barcode) async {
    var url = Uri.parse("http://45.91.132.217/api/getUnit.php?productId=" +
        productId +
        "&dbName=" +
        SharedPref.dbNameValueSF.toString() +
        "&barcode=" +
        barcode);
    print("request getUnit = " + url.toString());
    return Http.get(url).then((response) {
      print("response getUnit = " + response.body);
      List list = json.decode(response.body);
      List<Unit> listUnit = <Unit>[];
      Unit model;
      list.forEach((element) {
        model = Unit.fromJson(element);
        listUnit.add(model);
      });
      return listUnit;
    });
  }

  static Future<List<GoodsreceiveItem>> getGoodsreceiveItem(String grId) async {
    var url = Uri.parse(
        "http://45.91.132.217/api/getGoodsreceiveItem.php?grId=" +
            grId +
            "&dbName=" +
            SharedPref.dbNameValueSF.toString());
    print("request getGoodsreceiveItem = " + url.toString());
    var response = await Http.get(url);
    print("response getGoodsreceiveItem = " + response.body);
    List list = json.decode(response.body);
    List<GoodsreceiveItem> listGoodsreceiveItem = <GoodsreceiveItem>[];
    GoodsreceiveItem model;
    list.forEach((element) {
      model = GoodsreceiveItem.fromJson(element);
      listGoodsreceiveItem.add(model);
    });
    return listGoodsreceiveItem;
  }

  static Future<List<RequisitionItem>> getRequisitionItem(String rqId) async {
    var url = Uri.parse(
        "http://45.91.132.217/api/getRequisitionItem.php?rqId=" +
            rqId +
            "&dbName=" +
            SharedPref.dbNameValueSF.toString());
    print("request getRequisitionItem = " + url.toString());
    var response = await Http.get(url);
    print("response getRequisitionItem = " + response.body);
    List list = json.decode(response.body);
    List<RequisitionItem> listRequisitionItem = <RequisitionItem>[];
    RequisitionItem model;
    list.forEach((element) {
      model = RequisitionItem.fromJson(element);
      listRequisitionItem.add(model);
    });
    return listRequisitionItem;
  }

  static Future<List<Serial>> getSerial(String productId, String grId) async {
    var url = Uri.parse("http://45.91.132.217/api/getSerial.php?productId=" +
        productId +
        "&grId=" +
        grId +
        "&dbName=" +
        SharedPref.dbNameValueSF.toString());
    print("request getSerial = " + url.toString());
    var response = await Http.get(url);
    print("response getSerial = " + response.body);
    List list = json.decode(response.body);
    List<Serial> listSerial = <Serial>[];
    list.forEach((element) {
      listSerial.add(Serial.fromJson(element));
    });
    return listSerial;
  }

  static Future<List<Serial>> getSerialRQ(String productId, String rqId) async {
    var url = Uri.parse("http://45.91.132.217/api/getSerialRQ.php?productId=" +
        productId +
        "&rqId=" +
        rqId +
        "&dbName=" +
        SharedPref.dbNameValueSF.toString());
    print("request getSerialRQ = " + url.toString());
    var response = await Http.get(url);
    print("response getSerialRQ = " + response.body);
    List list = json.decode(response.body);
    List<Serial> listSerial = <Serial>[];
    list.forEach((element) {
      listSerial.add(Serial.fromJson(element));
    });
    return listSerial;
  }

  static Future<ProductByBarCode> getProductByBarcode(String barcode) async {
    var url = Uri.parse(
        "http://45.91.132.217/api/getProductByBarcode.php?barcode=" +
            barcode +
            "&dbName=" +
            SharedPref.dbNameValueSF.toString());
    print("request getProductByBarcode = " + url.toString());
    var response = await Http.get(url);
    print("response ProductByBarCode = " + response.body);
    List list = json.decode(response.body);
    ProductByBarCode model = ProductByBarCode();
    list.forEach((element) {
      model = ProductByBarCode.fromJson(element);
    });
    return model;
  }

  static Future<List<Remark>> getRemark() async {
    var url = Uri.parse("http://45.91.132.217/api/getRemark.php" +
        "?dbName=" +
        SharedPref.dbNameValueSF.toString());
    print("request getRemark = " + url.toString());
    var response = await Http.get(url);
    print("response getRemark = " + response.body);
    List list = json.decode(response.body);
    List<Remark> listRemark = <Remark>[];
    list.forEach((element) {
      Remark model = Remark.fromJson(element);
      listRemark.add(model);
    });
    return listRemark;
  }

  static Future<List<ProductGroup>> getProductGroup() async {
    var url = Uri.parse("http://45.91.132.217/api/getProductGroup.php" +
        "?dbName=" +
        SharedPref.dbNameValueSF.toString());
    print("request getProductGroup = " + url.toString());
    var response = await Http.get(url);
    print("response getProductGroup = " + response.body);
    List list = json.decode(response.body);
    List<ProductGroup> listProductGroup = <ProductGroup>[];
    list.forEach((element) {
      ProductGroup model = ProductGroup.fromJson(element);
      listProductGroup.add(model);
    });
    return listProductGroup;
  }

  static Future<List<Category>> getCategoryByGroup(String groupId) async {
    var url = Uri.parse("http://45.91.132.217/api/getCategoryByGroup.php" +
        "?dbName=" +
        SharedPref.dbNameValueSF.toString() +
        "&groupId=" +
        groupId);
    print("request getCategoryByGroup = " + url.toString());
    var response = await Http.get(url);
    print("response getCategory = " + response.body);
    List list = json.decode(response.body);
    List<Category> listCategory = <Category>[];
    list.forEach((element) {
      Category model = Category.fromJson(element);
      listCategory.add(model);
    });
    return listCategory;
  }

  static Future<List<LotNo>> getLotGR(String productId, String barcode) async {
    var url = Uri.parse("http://45.91.132.217/api/getLotGR.php?productId=" +
        productId +
        "&dbName=" +
        SharedPref.dbNameValueSF.toString() +
        "&barcode=" +
        barcode);
    print("request getLotGR = " + url.toString());
    var response = await Http.get(url);
    print("response getLotGR = " + response.body);
    List list = json.decode(response.body);
    List<LotNo> listLotNo = <LotNo>[];
    list.forEach((element) {
      LotNo model = LotNo.fromJson(element);
      listLotNo.add(model);
    });
    return listLotNo;
  }

  static Future<List<LotNo>> getLotRQ(
      String productId, String barcode, String stockPlaceId) async {
    var url = Uri.parse("http://45.91.132.217/api/getLotRQ.php?productId=" +
        productId +
        "&dbName=" +
        SharedPref.dbNameValueSF.toString() +
        "&barcode=" +
        barcode +
        "&placeId=" +
        stockPlaceId);
    print("request getLotRQ = " + url.toString());
    var response = await Http.get(url);
    print("response getLotRQ = " + response.body);
    List list = json.decode(response.body);
    List<LotNo> listLotNo = <LotNo>[];
    list.forEach((element) {
      LotNo model = LotNo.fromJson(element);
      listLotNo.add(model);
    });
    return listLotNo;
  }

  static Future<User?> postLogin(String username, String psswd) async {
    var response = await Http.post(
        Uri.parse("http://45.91.132.217/api/postLogin.php"),
        body: {
          "username": username,
          "psswd": psswd,
        });
    //check response status, if response status OK
    print("Response postLogin: " + response.body);
    List list = json.decode(response.body);
    if (response.statusCode != 200 || list.isEmpty)
      return null;
    else
      return User.fromJson(list.first);
    // if(response.statusCode == 200){
    //   var data = json.decode(response.body);
    //
    //   if(data.length>0){
    //     //Convert your JSON to Model here
    //   }
    //   else{
    //     //Get Your ERROR message's here
    //     var errorMessage = data["error_msg"];
    //   }
    // }
  }

  static Future<String> postGoodsReceive(ReceivingModel model) {
    var jsonRequest = {
      "docno": model.documentNumber,
      "docDate": model.documentDate,
      "remark": model.remark,
      "username": SharedPref.userNameValuesSF,
      "dbName": SharedPref.dbNameValueSF
    };
    if (model.supplier != null) {
      jsonRequest.addAll({"supplierId": model.supplier?.supplierId});
    }
    if (model.referencePONo != null) {
      jsonRequest.addAll({"refPONo": model.referencePONo});
    }
    if (model.referenceDONo != null) {
      jsonRequest.addAll({"refDONo": model.referenceDONo});
    }
    if (model.referenceInvoiceNo != null) {
      jsonRequest.addAll({"refInvoiceNo": model.referenceInvoiceNo});
    }
    if (model.grId != null) {
      jsonRequest.addAll({"grId": model.grId});
    }
    print("Request postGoodsReceive ");
    jsonRequest.forEach((key, value) {
      print("key: " + key + ", value: " + value.toString());
    });
    return Http.post(Uri.parse("http://45.91.132.217/api/postGoodsreceive.php"),
            body: jsonRequest)
        .then((response) {
      //check response status, if response status OK
      print("Response postGoodsReceive Status : " + response.body);
      if (response.body.toLowerCase().contains("status") &&
          response.body.toLowerCase().contains("failed")) {
        return "ไม่สามารถบันทึกข้อมูลได้";
      }
      return '';
    });
  }

  static Future<String> postGoodsreceiveItem(
      String grId, ItemModel model, String barcode) {
    var jsonRequest = {
      "prod": model.productItem?.id ?? '',
      "qty": model.qty ?? '',
      "unit": model.unit!.alternateUOMId ?? '',
      "placeId": model.stockPlaceId ?? '',
      "lot": model.lotNo ?? '',
      "manufactureDate": model.manufactureDate ?? '',
      "expiryDate": model.expiryDate ?? '',
      "grId": grId ?? '',
      "barcode": barcode ?? '',
      "dbName": SharedPref.dbNameValueSF ?? ''
    };
    print("Request postGoodsreceiveItem ");
    jsonRequest.forEach((key, value) {
      print("key: " + key + ", value: " + value.toString());
    });
    return Http.post(
            Uri.parse("http://45.91.132.217/api/postGoodsreceiveItem.php"),
            body: jsonRequest)
        .then((response) {
      //check response status, if response status OK
      print("Response postGoodsreceiveItem Status : " + response.body);
      if (response.body.toLowerCase().contains("status") &&
          response.body.toLowerCase().contains("failed")) {
        return "ไม่สามารถบันทึกข้อมูลได้";
      }
      return '';
    });
  }

  static Future<String> postRequisitionItem(
      String rqId, ItemModel model, String barcode) {
    var jsonRequest = {
      "prod": model.productItem?.id ?? '',
      "qty": model.qty ?? '',
      "unit": model.unit!.alternateUOMId ?? '',
      "placeId": model.stockPlaceId ?? '',
      "lot": model.lotNo ?? '',
      "rqId": rqId ?? '',
      "barcode": barcode ?? '',
      "username": SharedPref.userNameValuesSF,
      "dbName": SharedPref.dbNameValueSF
    };
    print("Request postRequisitionItem ");
    jsonRequest.forEach((key, value) {
      print("key: " + key + ", value: " + value.toString());
    });
    return Http.post(
            Uri.parse("http://45.91.132.217/api/postRequisitionItem.php"),
            body: jsonRequest)
        .then((response) {
      //check response status, if response status OK
      print("Response postRequisitionItem Status : " + response.body);
      if (response.body.toLowerCase().contains("status") &&
          response.body.toLowerCase().contains("failed")) {
        return "ไม่สามารถบันทึกข้อมูลได้";
      }
      return '';
    });
  }

  static Future<String> postRequisition(RequisitionModel model) {
    var jsonRequest = {
      "docno": model.documentNumber,
      "docDate": model.documentDate,
      "username": SharedPref.userNameValuesSF,
      "dbName": SharedPref.dbNameValueSF
    };
    if (model.employee?.employeeId != null) {
      jsonRequest.addAll({"employeeId": model.employee?.employeeId});
    }
    if (model.remark?.remarkId != null) {
      jsonRequest.addAll({"remark": model.remark?.remarkId});
    }
    if (model.rqId != null) {
      jsonRequest.addAll({"rqId": model.rqId});
    }
    print("Request postRequisition ");
    jsonRequest.forEach((key, value) {
      print("key: " + key + ", value: " + value.toString());
    });
    return Http.post(Uri.parse("http://45.91.132.217/api/postRequisition.php"),
            body: jsonRequest)
        .then((response) {
      //check response status, if response status OK
      print("Response postRequisition Status : " + response.body);
      if (response.body.toLowerCase().contains("status") &&
          response.body.toLowerCase().contains("failed")) {
        return "ไม่สามารถบันทึกข้อมูลได้";
      }
      return '';
    });
  }

  static Future<String> postSerial(String serial, String productId, String id) {
    var jsonRequest = {
      "serial": serial,
      "prod": productId,
      "grId": id,
      "dbName": SharedPref.dbNameValueSF
    };
    print("Request postSerial ");
    jsonRequest.forEach((key, value) {
      print("key: " + key + ", value: " + value.toString());
    });
    return Http.post(Uri.parse("http://45.91.132.217/api/postSerial.php"),
            body: jsonRequest)
        .then((response) {
      //check response status, if response status OK
      print("Response postSerial Status : " + response.body);
      if (response.body.toLowerCase().contains("status") &&
          response.body.toLowerCase().contains("failed")) {
        return "ไม่สามารถบันทึกข้อมูลได้ เนื่องจากรายการซ้ำ หรือไม่มี serial ในระบบ หรือ serial เกินจำนวน";
      }
      return '';
    });
  }

  static Future<String> postSerialRQ(
      String serial, String productId, String id) {
    var jsonRequest = {
      "serial": serial,
      "prod": productId,
      "rqId": id,
      "dbName": SharedPref.dbNameValueSF
    };
    print("Request postSerialRQ ");
    jsonRequest.forEach((key, value) {
      print("key: " + key + ", value: " + value.toString());
    });
    return Http.post(Uri.parse("http://45.91.132.217/api/postSerialRQ.php"),
            body: jsonRequest)
        .then((response) {
      //check response status, if response status OK
      print("Response postSerialRQ Status : " + response.body);
      if (response.body.toLowerCase().contains("status") &&
          response.body.toLowerCase().contains("failed")) {
        return "ไม่สามารถบันทึกข้อมูลได้ เนื่องจากรายการซ้ำ หรือไม่มี serial ในระบบ หรือ serial เกินจำนวน";
      }
      return '';
    });
  }

  static Future<String> postGoodsreceiveDelete(String grId) {
    var jsonRequest = {"grId": grId, "dbName": SharedPref.dbNameValueSF};
    print("Request postGoodsreceiveDelete ");
    jsonRequest.forEach((key, value) {
      print("key: " + key + ", value: " + value.toString());
    });
    var url = Uri.parse("http://45.91.132.217/api/postGoodsreceiveDelete.php");
    return Http.post(url, body: jsonRequest).then((response) {
      //check response status, if response status OK
      print("Response postGoodsreceiveDelete Status : " + response.body);
      if (response.body.toLowerCase().contains("status") &&
          response.body.toLowerCase().contains("failed")) {
        return "ไม่สามารถลบข้อมูลได้";
      }
      return '';
    });
  }

  static Future<String> postGoodsreceiveItemDelete(String grId, String prod) {
    var jsonRequest = {
      "productId": prod,
      "grId": grId,
      "dbName": SharedPref.dbNameValueSF
    };
    print("Request postGoodsreceiveItemDelete ");
    jsonRequest.forEach((key, value) {
      print("key: " + key + ", value: " + value.toString());
    });
    var url =
        Uri.parse("http://45.91.132.217/api/postGoodsreceiveItemDelete.php");
    return Http.post(url, body: jsonRequest).then((response) {
      //check response status, if response status OK
      print("Response postGoodsreceiveItemDelete Status : " + response.body);
      if (response.body.toLowerCase().contains("status") &&
          response.body.toLowerCase().contains("failed")) {
        return "ไม่สามารถลบข้อมูลได้";
      }
      return '';
    });
  }

  static Future<String> postRequisitionDelete(String rqId) {
    var jsonRequest = {"rqId": rqId, "dbName": SharedPref.dbNameValueSF};
    print("Request postRequisitionDelete ");
    jsonRequest.forEach((key, value) {
      print("key: " + key + ", value: " + value.toString());
    });
    var url = Uri.parse("http://45.91.132.217/api/postRequisitionDelete.php");
    return Http.post(url, body: jsonRequest).then((response) {
      //check response status, if response status OK
      print("Response postRequisitionDelete Status : " + response.body);
      if (response.body.toLowerCase().contains("status") &&
          response.body.toLowerCase().contains("failed")) {
        return "ไม่สามารถลบข้อมูลได้";
      }
      return '';
    });
  }

  static Future<String> postRequisitionItemDelete(String rqId, String prod) {
    var jsonRequest = {
      "productId": prod,
      "rqId": rqId,
      "dbName": SharedPref.dbNameValueSF
    };
    print("Request postRequisitionItemDelete ");
    jsonRequest.forEach((key, value) {
      print("key: " + key + ", value: " + value.toString());
    });
    var url =
        Uri.parse("http://45.91.132.217/api/postRequisitionItemDelete.php");
    return Http.post(url, body: jsonRequest).then((response) {
      //check response status, if response status OK
      print("Response postRequisitionItemDelete Status : " + response.body);
      if (response.body.toLowerCase().contains("status") &&
          response.body.toLowerCase().contains("failed")) {
        return "ไม่สามารถลบข้อมูลได้";
      }
      return '';
    });
  }

  static Future<List<ProductItemModel>?> searchProduct(
      String groupId, String categoryId, String qty) async {
    var url = Uri.parse("http://45.91.132.217/api/searchProduct.php");
    var jsonRequest = {
      "groupId": groupId,
      "categoryId": categoryId,
      "qty": qty,
      "dbName": SharedPref.dbNameValueSF
    };
    print("Request searchProduct ");
    jsonRequest.forEach((key, value) {
      print("key: " + key + ", value: " + value.toString());
    });
    return Http.post(url, body: jsonRequest).then((response) {
      //check response status, if response status OK
      print("Response searchProduct Status : " + response.body);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        //
        if (data.length > 0) {
          List list = json.decode(response.body);
          List<ProductItemModel> listProduct = [];
          list.forEach((element) {
            Product model = Product.fromJson(element);
            listProduct.add(ProductItemModel()
              ..name = model.productName
              ..id = model.productId
              ..code = model.productCode
              ..qty = model.qty
              ..unit = model.unit
              ..isSerial = model.isSerial
              ..isLotControl = model.isLotControl);
          });
          return listProduct;
          //     //Convert your JSON to Model here
        } else {
          return null;
          //     //Get Your ERROR message's here
          //     var errorMessage = data["error_msg"];
        }
      }
      return null;
    });
  }

  static Future<String> postSerialDelete(String grId, String serial) async {
    var jsonRequest = {
      "serial": serial,
      "grId": grId,
      "dbName": SharedPref.dbNameValueSF
    };
    print("Request postSerialDelete ");
    jsonRequest.forEach((key, value) {
      print("key: " + key + ", value: " + value.toString());
    });
    var url = Uri.parse("http://45.91.132.217/api/postSerialDelete.php");
    return Http.post(url, body: jsonRequest).then((response) {
      //check response status, if response status OK
      print("Response postSerialDelete Status : " + response.body);
      if (response.body.toLowerCase().contains("status") &&
          response.body.toLowerCase().contains("failed")) {
        return "ไม่สามารถลบข้อมูลได้";
      }
      return '';
    });
  }

  static Future<String> postSerialDeleteRQ(String rqId, String serial) async {
    var jsonRequest = {
      "serial": serial,
      "rqId": rqId,
      "dbName": SharedPref.dbNameValueSF
    };
    print("Request postSerialDeleteRQ ");
    jsonRequest.forEach((key, value) {
      print("key: " + key + ", value: " + value.toString());
    });
    var url = Uri.parse("http://45.91.132.217/api/postSerialDeleteRQ.php");
    return Http.post(url, body: jsonRequest).then((response) {
      //check response status, if response status OK
      print("Response postSerialDeleteRQ Status : " + response.body);
      if (response.body.toLowerCase().contains("status") &&
          response.body.toLowerCase().contains("failed")) {
        return "ไม่สามารถลบข้อมูลได้";
      }
      return '';
    });
  }

  static Future<String> postRequisitionA(String value, String id) async {
    var jsonRequest = {value: id, "dbName": SharedPref.dbNameValueSF};
    print("Request postRequisitionA ");
    jsonRequest.forEach((key, value) {
      print("key: " + key + ", value: " + value.toString());
    });
    var url = Uri.parse("http://45.91.132.217/api/postRequisitionA.php");
    return Http.post(url, body: jsonRequest).then((response) {
      print("Response postRequisitionA Status : " + response.body);
      if (response.body.toLowerCase().contains("status") &&
          response.body.toLowerCase().contains("failed")) {
        if (value == "grId") {
          return "ไม่สามารถบันทึกข้อมูลได้ เนื่องจากไม่มีรายการสินค้าในใบรับสินค้า";
        } else {
          return "ไม่สามารถบันทึกข้อมูลได้ เนื่องจากไม่มีรายการสินค้าในใบเบิกสินค้า";
        }
      }
      return '';
    });
  }

  static Future<String> postGoodsreceiveW(String value, String id) async {
    var jsonRequest = {value: id, "dbName": SharedPref.dbNameValueSF};
    print("Request postGoodsreceiveW ");
    jsonRequest.forEach((key, value) {
      print("key: " + key + ", value: " + value.toString());
    });
    var url = Uri.parse("http://45.91.132.217/api/postGoodsreceiveW.php");
    return Http.post(url, body: jsonRequest).then((response) {
      print("Response postGoodsreceiveW Status : " + response.body);
      if (response.body.toLowerCase().contains("status") &&
          response.body.toLowerCase().contains("failed")) {
        if (value == "grId") {
          return "ไม่สามารถบันทึกข้อมูลได้ เนื่องจากไม่มีรายการสินค้าในใบรับสินค้า";
        } else {
          return "ไม่สามารถบันทึกข้อมูลได้ เนื่องจากไม่มีรายการสินค้าในใบเบิกสินค้า";
        }
      }
      return '';
    });
  }

  static Future<String> postRequisitionW(String value, String id) async {
    var jsonRequest = {value: id, "dbName": SharedPref.dbNameValueSF};
    print("Request postRequisitionW ");
    jsonRequest.forEach((key, value) {
      print("key: " + key + ", value: " + value.toString());
    });
    var url = Uri.parse("http://45.91.132.217/api/postRequisitionW.php");
    return Http.post(url, body: jsonRequest).then((response) {
      print("Response postRequisitionW Status : " + response.body);
      if (response.body.toLowerCase().contains("status") &&
          response.body.toLowerCase().contains("failed")) {
        if (value == "grId") {
          return "ไม่สามารถบันทึกข้อมูลได้ เนื่องจากไม่มีรายการสินค้าในใบรับสินค้า";
        } else {
          return "ไม่สามารถบันทึกข้อมูลได้ เนื่องจากไม่มีรายการสินค้าในใบเบิกสินค้า";
        }
      }
      return '';
    });
  }

  static Future<String> postGoodsreceiveC(String value, String id) async {
    var jsonRequest = {value: id, "dbName": SharedPref.dbNameValueSF};
    print("Request postGoodsreceiveC");
    jsonRequest.forEach((key, value) {
      print("key: " + key + ", value: " + value.toString());
    });
    var url = Uri.parse("http://45.91.132.217/api/postGoodsreceiveC.php");
    return Http.post(url, body: jsonRequest).then((response) {
      print("Response postGoodsreceiveC Status : " + response.body);
      if (response.body.toLowerCase().contains("status") &&
          response.body.toLowerCase().contains("failed")) {
        return "ไม่สามารถบันทึกข้อมูลได้";
      }
      return '';
    });
  }

  static Future<String> postRequisitionC(String value, String id) async {
    var jsonRequest = {value: id, "dbName": SharedPref.dbNameValueSF};
    print("Request postRequisitionC");
    jsonRequest.forEach((key, value) {
      print("key: " + key + ", value: " + value.toString());
    });
    var url = Uri.parse("http://45.91.132.217/api/postRequisitionC.php");
    return Http.post(url, body: jsonRequest).then((response) {
      print("Response postRequisitionC Status : " + response.body);
      if (response.body.toLowerCase().contains("status") &&
          response.body.toLowerCase().contains("failed")) {
        return "ไม่สามารถบันทึกข้อมูลได้";
      }
      return '';
    });
  }

  static Future<String> postGoodsreceiveR(String value, String id) async {
    var jsonRequest = {value: id, "dbName": SharedPref.dbNameValueSF};
    print("Request postGoodsreceiveR ");
    jsonRequest.forEach((key, value) {
      print("key: " + key + ", value: " + value.toString());
    });
    var url = Uri.parse("http://45.91.132.217/api/postGoodsreceiveR.php");
    return Http.post(url, body: jsonRequest).then((response) {
      print("Response postGoodsreceiveR Status : " + response.body);
      if (response.body.toLowerCase().contains("status") &&
          response.body.toLowerCase().contains("failed")) {
        return "ไม่สามารถบันทึกข้อมูลได้";
      }
      return '';
    });
  }

  static Future<String> postRequisitionR(String value, String id) async {
    var jsonRequest = {value: id, "dbName": SharedPref.dbNameValueSF};
    print("Request postRequisitionR ");
    jsonRequest.forEach((key, value) {
      print("key: " + key + ", value: " + value.toString());
    });
    var url = Uri.parse("http://45.91.132.217/api/postRequisitionR.php");
    return Http.post(url, body: jsonRequest).then((response) {
      print("Response postRequisitionR Status : " + response.body);
      if (response.body.toLowerCase().contains("status") &&
          response.body.toLowerCase().contains("failed")) {
        return "ไม่สามารถบันทึกข้อมูลได้";
      }
      return '';
    });
  }

  static Future<List<ReceivingModel>> searchGoodsreceive(String status) async {
    var jsonRequest = {
      "status": status,
      "dbName": SharedPref.dbNameValueSF,
      "username": SharedPref.userNameValuesSF
    };
    print("Request searchGoodsreceive ");
    jsonRequest.forEach((key, value) {
      print("key: " + key + ", value: " + value.toString());
    });
    var url = Uri.parse("http://45.91.132.217/api/searchGoodsreceive.php");
    return Http.post(url, body: jsonRequest).then((response) {
      print("Response searchGoodsreceive Status : " + response.body);
      List listJson = json.decode(response.body);
      List<ReceivingModel> list = <ReceivingModel>[];
      if (listJson.isEmpty) return list;
      GoodsReceive model;
      listJson.forEach((element) {
        model = GoodsReceive.fromJson(element);
        list.add(ReceivingModel()
          ..grId = model.grId
          ..documentNumber = model.documentNo
          ..documentDate = model.documentDate
          ..status = model.status
          ..cnt = model.cnt);
      });
      return list;
    });
  }

  static Future<List<RequisitionModel>> searchRequisition(String status) async {
    var jsonRequest = {
      "status": status,
      "dbName": SharedPref.dbNameValueSF,
      "username": SharedPref.userNameValuesSF
    };
    print("Request searchRequisition ");
    jsonRequest.forEach((key, value) {
      print("key: " + key + ", value: " + value.toString());
    });
    var url = Uri.parse(
        "http://45.91.132.217/api/searchRequisition.php?status=" +
            status +
            "&dbName=" +
            SharedPref.dbNameValueSF.toString() +
            "&username=" +
            SharedPref.userNameValuesSF.toString());
    return Http.get(url).then((response) {
      print("Response searchRequisition Status : " + response.body);
      List listJson = json.decode(response.body);
      List<RequisitionModel> list = <RequisitionModel>[];
      if (listJson.isEmpty) return list;
      RequisitionFromService model;
      listJson.forEach((element) {
        model = RequisitionFromService.fromJson(element);
        list.add(RequisitionModel()
          ..rqId = model.rqId
          ..documentNumber = model.documentNo
          ..documentDate = model.documentDate
          ..status = model.status
          ..cnt = model.cnt);
      });
      return list;
    });
  }
}
