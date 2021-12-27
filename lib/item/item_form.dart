import 'package:checkstockpro/component/input_text_field.dart';
import 'package:checkstockpro/product/product_item.dart';
import 'package:checkstockpro/product/product_model.dart';
import 'package:checkstockpro/services/lot_no.dart';
import 'package:checkstockpro/services/product.dart';
import 'package:checkstockpro/services/product_by_bar_code.dart';
import 'package:checkstockpro/services/services.dart';
import 'package:checkstockpro/services/stock_place.dart';
import 'package:checkstockpro/services/unit.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;
import 'package:qrscan/qrscan.dart' as scanner;

import 'item_model.dart';

class ItemForm extends StatefulWidget {
  final Function callback;
  final String type;
  final ItemModel itemModel;
  final String id;

  const ItemForm(
      {Key? key,
      required this.callback,
      required this.type,
      required this.itemModel,
      required this.id})
      : super(key: key);

  @override
  _ItemForm createState() => _ItemForm();
}

class _ItemForm extends State<ItemForm> {
  TextEditingController _productController = TextEditingController();
  TextEditingController _qtyController = TextEditingController();
  TextEditingController _manufactureDateController = TextEditingController();
  TextEditingController _expiryDateController = TextEditingController();
  TextEditingController _barcodeController = TextEditingController();
  TextEditingController _stockPlaceController = TextEditingController();
  ItemModel item = ItemModel();
  List<StockPlace> listStockPlace = <StockPlace>[];
  List<Unit> listUnit = <Unit>[];
  List<LotNo> listLotNo = <LotNo>[];
  String lotNoSelected = '';
  bool isLoading = true;

  void getProduct() async {
    Services.getProduct().then((list) {
      setState(() {
        list.forEach((element) {
          if (widget.itemModel.productItem != null) {
            if (element.productName == widget.itemModel.productItem!.name) {
              item.productItem = ProductItemModel()
                ..code = element.productCode
                ..id = element.productId
                ..name = element.productName
                ..qty = element.qty
                ..unit = element.unit
                ..isLotControl = element.isLotControl
                ..isSerial = element.isSerial;
              _productItemModel(item.productItem!);
            }
          }
        });
      });
    });
  }

  void _productItemModel(ProductItemModel value) {
    setState(() {
      item.productItem = value;
      _productController.text = value.name.toString();
    });
    getStockPlace();
    getLotNo(item.productItem!.id.toString());
    getUnit(item.productItem!.id.toString());
  }

  void getLotNo(String id) async {
    if (widget.type == 'requisition') {
      List<LotNo> list = await Services.getLotRQ(
          id, _barcodeController.text, item.stockPlaceId ?? '');
      setState(() {
        listLotNo = list;
      });
    } else {
      List<LotNo> list = await Services.getLotGR(id, _barcodeController.text);
      setState(() {
        listLotNo = list;
      });
    }
  }

  void _unitModel(Unit value) => setState(() => {
        item.unit = value,
        item.unitName = value.uomName.toString(),
      });

  void _stockPlaceModel(StockPlace value) => setState(() => {
        print("_stockPlaceModel id = " + value.stockPlaceId),
        item.stockPlaceId = value.stockPlaceId,
        item.stockPlace = value,
        print("listStockPlace length = " + listStockPlace.length.toString()),
        listStockPlace.forEach((element) {
          print("stockPlaceId = " + element.stockPlaceId.toString());
        }),
        _stockPlaceController.text =
            item.stockPlace?.stockPlaceName.toString() ?? ''
      });

  void getStockPlace() async {
    if (widget.type == 'requisition') {
      await Services.getStockplaceRQ(
              _barcodeController.text, item.productItem?.id ?? '')
          .then((list) {
        setState(() {
          listStockPlace = list;
          isLoading = false;
        });
      });
    } else {
      await Services.getStockplace(
              _barcodeController.text, item.productItem?.id ?? '')
          .then((list) {
        setState(() {
          listStockPlace = list;
          isLoading = false;
        });
      });
    }
  }

  void getUnit(String id) async {
    Services.getUnit(id, _barcodeController.text).then((list) {
      setState(() {
        listUnit = list;
        item.unitName = list.first.uomName;
        item.unit = list.first;
      });
    });
  }

  void getProductByBarcode(String barcode) async {
    Services.getProductByBarcode(barcode).then((model) {
      setState(() {
        _productItemModel(ProductItemModel()
          ..id = model.productId ?? ""
          ..name = model.productName ?? ""
          ..isLotControl = model.isLotControl
          ..isSerial = model.isSerial);
        _unitModel(Unit(
            alternateUOMId: model.uomId ?? "", uomName: model.uomName ?? ""));
        if ((model.stockId ?? '').isNotEmpty) {
          _stockPlaceModel(StockPlace(
              stockPlaceId: model.stockId.toString(),
              stockPlaceName: model.stockName.toString()));
        }
        item.lotNo = model.lotNo.toString() ?? '';
      });
    });
  }

  String findNameStockPlace(String id) {
    late StockPlace model;
    listStockPlace.forEach((element) {
      if (id == element.stockPlaceId) {
        model = element;
      }
    });
    return model.stockPlaceName;
  }

  String findNameUnit(String id) {
    late Unit model;
    listUnit.forEach((element) {
      if (id == element.alternateUOMId) {
        model = element;
      }
    });
    return model.uomName.toString();
  }

  @override
  void dispose() {
    super.dispose();
    _productController.dispose();
    _qtyController.dispose();
  }

  @override
  void initState() {
    getProduct();
    getStockPlace();
    super.initState();
    _manufactureDateController.text =
        intl.DateFormat("yyyy-MM-dd").format(DateTime.now());
    _expiryDateController.text =
        intl.DateFormat("yyyy-MM-dd").format(DateTime.now());
    item = widget.itemModel;
    item.manufactureDate = _manufactureDateController.text;
    item.expiryDate = _expiryDateController.text;
    // if (item.productItem != null) {
    //   _productItemModel(item.productItem!);
    // }
    // if (item.placeId != null) {
    //   _stockPlaceModel(item.placeId!);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Expanded(
                child: isReceivingType()
                    ? Text('Receiving Item')
                    : Text('Requisition Item')),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close))
          ],
        ),
      ),
      body: isLoading
          ? CircularProgressIndicator()
          : Column(
              children: [
                Expanded(
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(16),
                      child: AutofillGroup(
                        child: Column(
                          children: [
                            ...[
                              TextFormField(
                                controller: _barcodeController,
                                autofocus: true,
                                decoration: InputDecoration(
                                  labelText: 'Barcode',
                                  hintText: 'Barcode',
                                  focusedBorder: defaultFocusedBorder,
                                  enabledBorder: defaultBorder,
                                  suffixIcon: IconButton(
                                    onPressed: () async {
                                      await Permission.camera.request();
                                      String? cameraScanResult =
                                          await scanner.scan();
                                      if (cameraScanResult != null &&
                                          cameraScanResult != '') {
                                        _barcodeController.text =
                                            cameraScanResult;
                                        getProductByBarcode(cameraScanResult);
                                      }
                                    },
                                    icon: Icon(Icons.camera_alt),
                                  ),
                                ),
                                onChanged: (value) {
                                  getProductByBarcode(value);
                                },
                              ),
                              TextFormField(
                                showCursor: false,
                                readOnly: true,
                                enableInteractiveSelection: false,
                                enableSuggestions: false,
                                focusNode:
                                    new FocusNode(canRequestFocus: false),
                                controller: _productController,
                                decoration: InputDecoration(
                                  labelText: 'Product',
                                  hintText: 'Product',
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (BuildContext context,
                                                Animation<double> animation,
                                                Animation<double>
                                                    secondaryAnimation) {
                                              return ProductItem(
                                                  callback: (product) => {
                                                        _productItemModel(
                                                            product)
                                                      },
                                                  productItemModel:
                                                      item.productItem,
                                                  isHome: false);
                                            },
                                            transitionsBuilder:
                                                (BuildContext context,
                                                    Animation<double> animation,
                                                    Animation<double>
                                                        secondaryAnimation,
                                                    Widget child) {
                                              return SlideTransition(
                                                position: Tween<Offset>(
                                                  begin: Offset(0.0, 1.0),
                                                  end: Offset(0.0, 0.0),
                                                ).animate(animation),
                                                child: child,
                                              );
                                            },
                                          ));
                                    },
                                    icon: Icon(Icons.more_vert),
                                  ),
                                  focusedBorder: defaultFocusedBorder,
                                  enabledBorder: defaultBorder,
                                  disabledBorder: defaultBorder,
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 10,
                                    child: TextFormField(
                                      // controller: _qtyController,
                                      initialValue: item.qty,
                                      decoration: InputDecoration(
                                        labelText: item.qty == null ||
                                                item.qty.toString() == ''
                                            ? '* Qty'
                                            : 'Qty',
                                        labelStyle: item.qty == null ||
                                                item.qty.toString() == ''
                                            ? TextStyle(color: Colors.red)
                                            : TextStyle(),
                                        // hintText: 'Qty',
                                        focusedBorder: defaultFocusedBorder,
                                        enabledBorder: defaultBorder,
                                      ),
                                      onChanged: (value) => setState(() => {
                                            // _qtyController.text = value,
                                            item.qty = value
                                          }),
                                    ),
                                  ),
                                  Spacer(),
                                  Expanded(
                                    flex: 14,
                                    child: FormField<String>(
                                      builder: (FormFieldState<String> state) {
                                        return InputDecorator(
                                          decoration: InputDecoration(
                                            labelText: item.unit == null ||
                                                    item.unitName.toString() ==
                                                        ''
                                                ? ''
                                                : 'Unit',
                                            // hintText: item.unit == null || item.unitName.toString() == ''
                                            //     ? '* Unit'
                                            //     : 'Unit',
                                            // hintStyle: item.unit == null || item.unitName.toString() == ''
                                            //     ? TextStyle(color: Colors.red)
                                            //     : TextStyle(),
                                            focusedBorder: defaultFocusedBorder,
                                            enabledBorder: defaultBorder,
                                            errorBorder: errorBorder,
                                          ),
                                          // isEmpty: widget.receivingModel.supplier == '',
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              hint: item.unit == null ||
                                                      item.unitName
                                                              .toString() ==
                                                          ''
                                                  ? Text(
                                                      '* Unit',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    )
                                                  : Text('Unit'),
                                              icon: Icon(Icons
                                                  .keyboard_arrow_down_sharp),
                                              value: item.unitName,
                                              isDense: true,
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  item.unitName =
                                                      newValue.toString();
                                                  item.unit =
                                                      ItemModel.findUnitByName(
                                                          listUnit, newValue);
                                                  state.didChange(newValue);
                                                });
                                              },
                                              items:
                                                  listUnit.map((Unit element) {
                                                return DropdownMenuItem<String>(
                                                  value: element.uomName
                                                      .toString(),
                                                  child: Text(element.uomName
                                                      .toString()),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              // FormField<String>(
                              //   builder: (FormFieldState<String> state) {
                              //     return InputDecorator(
                              //       decoration: InputDecoration(
                              //         labelText: 'Stock Place',
                              //         hintText: 'Stock Place',
                              //         focusedBorder: defaultFocusedBorder,
                              //         enabledBorder: defaultBorder,
                              //         errorBorder: errorBorder,
                              //       ),
                              //       // isEmpty: widget.receivingModel.supplier == '',
                              //       child: DropdownButtonHideUnderline(
                              //         child: DropdownButton<String>(
                              //           hint: Text('Stock Place'),
                              //           icon: Icon(Icons.keyboard_arrow_down_sharp),
                              //           value: item.stockPlaceId,
                              //           isDense: true,
                              //           onChanged: (String? newValue) {
                              //             setState(() {
                              //               item.stockPlaceId = newValue.toString();
                              //               state.didChange(newValue);
                              //             });
                              //           },
                              //           items:
                              //               listStockPlace.map((StockPlace element) {
                              //             return DropdownMenuItem<String>(
                              //               value: element.stockPlaceId,
                              //               child: Text(element.stockPlaceName),
                              //             );
                              //           }).toList(),
                              //         ),
                              //       ),
                              //     );
                              //   },
                              // ),
                              DropdownSearch<StockPlace>(
                                mode: Mode.DIALOG,
                                itemAsString: (StockPlace? element) {
                                  return element?.stockPlaceName ?? '';
                                },
                                selectedItem: item.stockPlace,
                                items: listStockPlace,
                                showSelectedItems: false,
                                showSearchBox: true,
                                // label: item.stockPlace == null ? '* Stock Place' : 'Stock Place',
                                // hint: "Stock Place",
                                dropDownButton: Center(
                                    child: Icon(Icons.keyboard_arrow_down_sharp,
                                        color: Color.fromRGBO(
                                            139, 139, 139, 1.0))),
                                dialogMaxWidth:
                                    MediaQuery.of(context).size.width,
                                onChanged: (StockPlace? newValue) {
                                  setState(() {
                                    item.stockPlaceId =
                                        newValue?.stockPlaceId ?? '';
                                    item.stockPlace = newValue;
                                  });
                                },
                                dropdownSearchDecoration: InputDecoration(
                                  isDense: true,
                                  labelText: item.stockPlace == null
                                      ? "* Stock Place"
                                      : 'Stock Place',
                                  labelStyle: item.stockPlace == null
                                      ? TextStyle(color: Colors.red)
                                      : TextStyle(),
                                  // hintText: "Stock Place",
                                  enabledBorder: defaultBorder,
                                  border: defaultBorder,
                                  contentPadding: EdgeInsets.only(
                                      left: 12.0, top: 8.0, bottom: 8.0),
                                ),
                              ),
                              (item.productItem?.isLotControl == "1")
                                  ? DropdownSearch<LotNo>(
                                      mode: Mode.DIALOG,
                                      itemAsString: (LotNo? element) {
                                        return element?.lotNo.toString() ?? '';
                                      },
                                      items: listLotNo.toList(),
                                      showSelectedItems: false,
                                      showSearchBox: true,
                                      label: "Lot No",
                                      hint: "Lot No",
                                      dropDownButton: Center(
                                          child: Icon(
                                              Icons.keyboard_arrow_down_sharp,
                                              color: Color.fromRGBO(
                                                  139, 139, 139, 1.0))),
                                      dialogMaxWidth:
                                          MediaQuery.of(context).size.width,
                                      onChanged: (LotNo? newValue) {
                                        setState(() {
                                          item.lotNo =
                                              newValue?.lotNo.toString() ?? '';
                                        });
                                      },
                                      dropdownSearchDecoration: InputDecoration(
                                        isDense: true,
                                        labelText: "Lot No",
                                        hintText: "Lot No",
                                        enabledBorder: defaultBorder,
                                        border: defaultBorder,
                                        contentPadding: EdgeInsets.only(
                                            left: 12.0, top: 8.0, bottom: 8.0),
                                      ),
                                    )
                                  : Column(),
                              !isReceivingType()
                                  ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                      Column(
                                          children:
                                              getWidgetTextStockPlaceList())
                                    ])
                                  : Column(),
                              // (item.productItem?.isLotControl == "1")
                              //     ? TextFormField(
                              //         decoration: InputDecoration(
                              //           labelText: 'Lot No.',
                              //           hintText: 'Lot No.',
                              //           focusedBorder: defaultFocusedBorder,
                              //           enabledBorder: defaultBorder,
                              //         ),
                              //         onChanged: (value) => setState(() => {
                              //               item.lotNo = value,
                              //             }),
                              //       )
                              //     : Column(),
                              isReceivingType() &&
                                      (item.productItem?.isLotControl == "1")
                                  ? TextFormField(
                                      readOnly: true,
                                      controller: _manufactureDateController,
                                      onTap: () async {
                                        var newDate = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime(2100),
                                        );

                                        // Don't change the date if the date picker returns null.
                                        if (newDate == null) {
                                          return;
                                        }

                                        _manufactureDateController
                                          ..text = intl.DateFormat("yyyy-MM-dd")
                                              .format(newDate)
                                          ..selection = TextSelection
                                              .fromPosition(TextPosition(
                                                  offset:
                                                      _manufactureDateController
                                                          .text.length,
                                                  affinity:
                                                      TextAffinity.upstream));
                                        setState(() {
                                          item.manufactureDate =
                                              _manufactureDateController.text;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Manufacture Date',
                                        hintText: 'Manufacture Date',
                                        suffixIcon: IconButton(
                                          onPressed: () {},
                                          icon:
                                              Icon(Icons.calendar_today_sharp),
                                        ),
                                        focusedBorder: defaultFocusedBorder,
                                        enabledBorder: defaultBorder,
                                      ),
                                    )
                                  : SizedBox.shrink(),
                              isReceivingType() &&
                                      (item.productItem?.isLotControl == "1")
                                  ? TextFormField(
                                      controller: _expiryDateController,
                                      readOnly: true,
                                      onTap: () async {
                                        var newDate = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime(2100),
                                        );

                                        // Don't change the date if the date picker returns null.
                                        if (newDate == null) {
                                          return;
                                        }

                                        _expiryDateController
                                          ..text = intl.DateFormat("yyyy-MM-dd")
                                              .format(newDate)
                                          ..selection =
                                              TextSelection.fromPosition(
                                                  TextPosition(
                                                      offset:
                                                          _expiryDateController
                                                              .text.length,
                                                      affinity: TextAffinity
                                                          .upstream));
                                        setState(() {
                                          item.expiryDate =
                                              _expiryDateController.text;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Expiry Date',
                                        hintText: 'Expiry Date',
                                        suffixIcon: IconButton(
                                          onPressed: () {},
                                          icon:
                                              Icon(Icons.calendar_today_sharp),
                                        ),
                                        focusedBorder: defaultFocusedBorder,
                                        enabledBorder: defaultBorder,
                                      ),
                                    )
                                  : SizedBox.shrink(),
                            ].expand((widget) => [
                                  widget,
                                  const SizedBox(
                                    height: 24,
                                  )
                                ]),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 24, 24),
                      width: 80,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: isEnabledButton()
                                ? Color.fromRGBO(64, 101, 246, 1)
                                : Color.fromRGBO(99, 99, 99, 1.0)),
                        onPressed: () {
                          if (isEnabledButton()) {
                            if (isReceivingType()) {
                              Services.postGoodsreceiveItem(
                                      widget.id,
                                      item
                                        ..manufactureDate =
                                            _manufactureDateController.text
                                        ..expiryDate =
                                            _expiryDateController.text,
                                      _barcodeController.text)
                                  .then((String value) {
                                if (value.isEmpty) {
                                  widget.callback(item);
                                  Navigator.pop(context);
                                } else {
                                  // show the dialog
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Sorry"),
                                        content: Text(value),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, 'OK'),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              });
                            } else {
                              Services.postRequisitionItem(
                                      widget.id, item, _barcodeController.text)
                                  .then((String value) {
                                if (value.isEmpty) {
                                  widget.callback(item);
                                  Navigator.pop(context);
                                } else {
                                  // show the dialog
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Sorry"),
                                        content: Text(value),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, 'OK'),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              });
                            }
                          }
                        },
                        child: Text('OK'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  List<Widget> getWidgetTextStockPlaceList() {
    var list = <Widget>[];
    if (listStockPlace.isNotEmpty) {
      list.add(Text('จำนวนคงเหลือ = ' + listStockPlace.first.productOnhand));
      listStockPlace.forEach((element) {
        list.add(Text(element.stockPlaceName + ' = ' + element.stockOnhand));
      });
    }
    return list.toList();
  }

  bool isEnabledButton() {
    return true;
    if (isReceivingType()) {
      print('item.unitName = ' + item.unitName.toString());
      print('item.qty = ' + item.qty.toString());
      print('item.stockPlaceId = ' + item.stockPlaceId.toString());
      print('item.lotNo = ' + item.lotNo.toString());
      print('item.manufactureDate = ' + item.manufactureDate.toString());
      print('item.expiryDate = ' + item.expiryDate.toString());
      return item.productItem != null &&
          item.qty != null &&
          item.qty != '' &&
          item.unitName != null &&
          item.unitName != '' &&
          item.stockPlaceId != null &&
          item.stockPlaceId != '' &&
          ((item.lotNo != null &&
                  item.lotNo != '' &&
                  item.manufactureDate != null &&
                  item.manufactureDate != '' &&
                  item.expiryDate != null &&
                  item.expiryDate != '') ||
              ((item.lotNo == null || item.lotNo == '') &&
                  (item.manufactureDate == null ||
                      item.manufactureDate == '') &&
                  (item.expiryDate == null || item.expiryDate == '')));
    } else {
      return item.productItem != null &&
          item.qty != null &&
          item.qty != '' &&
          item.unitName != null &&
          item.unitName != '' &&
          item.stockPlaceId != null &&
          item.stockPlaceId != '';
    }
  }

  bool isReceivingType() {
    return widget.type == 'receiving';
  }
}
