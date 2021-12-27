import 'package:checkstockpro/component/input_text_field.dart';
import 'package:checkstockpro/product/product_model.dart';
import 'package:checkstockpro/services/category.dart';
import 'package:checkstockpro/services/product.dart';
import 'package:checkstockpro/services/product_by_bar_code.dart';
import 'package:checkstockpro/services/product_group.dart';
import 'package:checkstockpro/services/qty.dart';
import 'package:checkstockpro/services/services.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'dart:math';

class ProductItem extends StatefulWidget {
  static final GlobalKey<_ProductItem> globalKey = GlobalKey();
  final Function callback;
  final bool isHome;
  ProductItemModel? productItemModel;

  ProductItem(
      {Key? key,
      required this.callback,
      this.productItemModel,
      required this.isHome})
      : super(key: globalKey);

  @override
  _ProductItem createState() => _ProductItem();
}

class _ProductItem extends State<ProductItem> {
  ProductItemModel? productSelected;
  final List<int> colorCodes = <int>[240, 255];
  TextEditingController _searchController = TextEditingController();
  List<ProductGroup> listProductGroup = <ProductGroup>[];
  List<Category> listCategory = <Category>[];
  List<Qty> listQty = <Qty>[];
  ProductGroup? productGroupSelected;
  String groupSelected = "";
  Category? categoryModelSelected;
  String categorySelected = "";
  Qty? qtyModelSelected;
  String qtySelected = "";
  List<ProductItemModel> _productItemSearchServices = [];
  bool isSearch = false;
  bool isLoading = true;
  bool isShowSearch = false;

  void toggleIsShowSearch() {
    setState(() {
      isShowSearch = !isShowSearch;
    });
  }

  void getProduct() async {
    List<Product> list = await Services.getProduct();
    setState(() {
      list.forEach((element) {
        _productItem.add(ProductItemModel()
          ..name = element.productName
          ..id = element.productId
          ..code = element.productCode
          ..qty = element.qty
          ..unit = element.unit
          ..isLotControl = element.isLotControl
          ..isSerial = element.isSerial);
      });
      isLoading = false;
    });
  }

  void getProductGroup() async {
    List<ProductGroup> list = await Services.getProductGroup();
    setState(() {
      listProductGroup = list;
    });
  }

  void getCategory(String groupId) async {
    List<Category> list = await Services.getCategoryByGroup(groupId);
    setState(() {
      listCategory = list;
    });
  }

  void getQty() async {
    setState(() {
      listQty.add(Qty(qtyId: "0", qtyName: "min Stock", qtyValue: "0"));
      listQty.add(Qty(qtyId: "1", qtyName: "< 10", qtyValue: "10"));
      listQty.add(Qty(qtyId: "2", qtyName: "< 100", qtyValue: "100"));
      listQty.add(Qty(qtyId: "3", qtyName: "< 1000", qtyValue: "1000"));
    });
  }

  void searchProduct() async {
    setState(() {
      isSearch = true;
      isLoading = true;
    });
    Services.searchProduct(groupSelected.toString(),
            categorySelected.toString(), qtySelected.toString())
        .then((List<ProductItemModel>? value) {
      if (value != null) {
        setProductItemSearchServices(value);
      } else {
        setProductItemSearchServices(<ProductItemModel>[]);
      }
    });
  }

  void setProductItemSearchServices(List<ProductItemModel> value) {
    setState(() {
      _productItemSearchServices = value;
      isLoading = false;
    });
  }

  void clearSearch() {
    setState(() {
      print("clearSearch");
      productGroupSelected = null;
      groupSelected = "";
      qtyModelSelected = null;
      qtySelected = "";
      categoryModelSelected = null;
      categorySelected = "";
      _productItemSearchServices = [];
      isSearch = false;
    });
  }

  void getProductByBarcode(String barcode) async {
    setState(() {
      _productItemSearchServices = [];
      isSearch = true;
      isLoading = true;
    });
    ProductByBarCode model = await Services.getProductByBarcode(barcode);
    setState(() {
      _productItemSearchServices.add(ProductItemModel()
        ..id = model.productId ?? ""
        ..name = model.productName ?? "");
      isLoading = false;
    });
  }

  @override
  void initState() {
    getProduct();
    getProductGroup();
    getQty();
    super.initState();
    if (widget.productItemModel != null) {
      productSelected = widget.productItemModel;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.isHome
        ? getColumnOfProduct()
        : Scaffold(
            appBar: AppBar(
              title: Row(children: [
                Text('Select a product item'),
                Spacer(),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      ProductItem.globalKey.currentState
                          ?.toggleIsShowSearch();
                    });
                  },
                  label: Text(""),
                  icon: isShowSearch
                      ? Transform.rotate(
                          angle: 180 * pi / 180,
                          child: Icon(
                            Icons.arrow_drop_down_circle,
                            color: Colors.white,
                          ),
                        )
                      : Icon(
                          Icons.arrow_drop_down_circle,
                          color: Colors.white,
                        ),
                )
              ]),
              elevation: 0.0,
            ),
            body: getColumnOfProduct());
  }

  Column getColumnOfProduct() {
    return Column(
      children: [
        isShowSearch
            ? Row(
                children: [
                  Expanded(
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 4.0, top: 8.0, bottom: 8.0),
                        child: Card(
                          child: ListTile(
                            title: DropdownSearch<ProductGroup>(
                              mode: Mode.DIALOG,
                              itemAsString: (ProductGroup? element) {
                                return element?.groupName ?? '';
                              },
                              selectedItem: productGroupSelected,
                              items: listProductGroup,
                              showSelectedItems: false,
                              showSearchBox: true,
                              hint: "Group",
                              dropDownButton: Center(
                                  child: Icon(Icons.keyboard_arrow_down_sharp,
                                      color:
                                          Color.fromRGBO(139, 139, 139, 1.0))),
                              maxHeight: MediaQuery.of(context).size.height,
                              dialogMaxWidth: MediaQuery.of(context).size.width,
                              onChanged: (ProductGroup? newValue) {
                                setState(() {
                                  productGroupSelected = newValue;
                                  groupSelected = newValue?.groupId ?? '';
                                  getCategory(groupSelected);
                                });
                              },
                              dropdownSearchDecoration: InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(0),
                              ),
                            ),
                            // title: FormField<String>(
                            //   builder: (FormFieldState<String> state) {
                            //     return InputDecorator(
                            //       decoration: InputDecoration(
                            //         hintText: 'Group',
                            //         border: InputBorder.none,
                            //       ),
                            //       child: DropdownButtonHideUnderline(
                            //         child: DropdownButton<String>(
                            //           hint: Text('Group'),
                            //           icon: Icon(Icons.keyboard_arrow_down_sharp),
                            //           value:
                            //               groupSelected == "" ? null : groupSelected,
                            //           isDense: true,
                            //           onChanged: (String? newValue) {
                            //             setState(() {
                            //               groupSelected = newValue.toString();
                            //               state.didChange(newValue);
                            //             });
                            //           },
                            //           items: listProductGroup
                            //               .map((ProductGroup element) {
                            //             return DropdownMenuItem<String>(
                            //               value: element.groupId,
                            //               child: Text(element.groupName.toString()),
                            //             );
                            //           }).toList(),
                            //         ),
                            //       ),
                            //     );
                            //   },
                            // ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: ListTile(
                            title: DropdownSearch<Category>(
                              mode: Mode.DIALOG,
                              itemAsString: (Category? element) {
                                return element?.categoryName ?? '';
                              },
                              items: listCategory,
                              selectedItem: categoryModelSelected,
                              showSelectedItems: false,
                              showSearchBox: true,
                              hint: "Category",
                              dropDownButton: Center(
                                  child: Icon(Icons.keyboard_arrow_down_sharp,
                                      color:
                                          Color.fromRGBO(139, 139, 139, 1.0))),
                              maxHeight: MediaQuery.of(context).size.height,
                              dialogMaxWidth: MediaQuery.of(context).size.width,
                              onChanged: (Category? newValue) {
                                setState(() {
                                  categoryModelSelected = newValue;
                                  categorySelected = newValue?.categoryId ?? '';
                                });
                              },
                              dropdownSearchDecoration: InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(0),
                              ),
                            ),
                            // title: FormField<String>(
                            //   builder: (FormFieldState<String> state) {
                            //     return InputDecorator(
                            //       decoration: InputDecoration(
                            //         hintText: 'Category',
                            //         border: InputBorder.none,
                            //       ),
                            //       // isEmpty: widget.receivingModel.supplier == '',
                            //       child: DropdownButtonHideUnderline(
                            //         child: DropdownButton<String>(
                            //           hint: Text('Category'),
                            //           icon: Icon(Icons.keyboard_arrow_down_sharp),
                            //           value: categorySelected == ""
                            //               ? null
                            //               : categorySelected,
                            //           isDense: true,
                            //           onChanged: (String? newValue) {
                            //             setState(() {
                            //               categorySelected = newValue.toString();
                            //               state.didChange(newValue);
                            //             });
                            //           },
                            //           items: listCategory.map((Category element) {
                            //             return DropdownMenuItem<String>(
                            //               value: element.categoryId,
                            //               child:
                            //                   Text(element.categoryName.toString()),
                            //             );
                            //           }).toList(),
                            //         ),
                            //       ),
                            //     );
                            //   },
                            // ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Column(),
        isShowSearch
            ? Row(
                children: [
                  Expanded(
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: ListTile(
                            title: DropdownSearch<Qty>(
                              mode: Mode.DIALOG,
                              itemAsString: (Qty? element) {
                                return element?.qtyName ?? '';
                              },
                              items: listQty,
                              selectedItem: qtyModelSelected,
                              showSelectedItems: false,
                              showSearchBox: true,
                              hint: "QTY",
                              dropDownButton: Center(
                                  child: Icon(
                                Icons.keyboard_arrow_down_sharp,
                                color: Color.fromRGBO(139, 139, 139, 1.0),
                              )),
                              maxHeight: MediaQuery.of(context).size.height,
                              dialogMaxWidth: MediaQuery.of(context).size.width,
                              onChanged: (Qty? newValue) {
                                setState(() {
                                  qtyModelSelected = newValue;
                                  qtySelected = newValue?.qtyId ?? '';
                                });
                              },
                              dropdownSearchDecoration: InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(0),
                              ),
                            ),
                            // title: FormField<String>(
                            //   builder: (FormFieldState<String> state) {
                            //     return InputDecorator(
                            //       decoration: InputDecoration(
                            //         hintText: 'QTY',
                            //         border: InputBorder.none,
                            //       ),
                            //       child: DropdownButtonHideUnderline(
                            //         child: DropdownButton<String>(
                            //           hint: Text('QTY'),
                            //           icon: Icon(Icons.keyboard_arrow_down_sharp),
                            //           value: qtySelected == "" ? null : qtySelected,
                            //           isDense: true,
                            //           onChanged: (String? newValue) {
                            //             setState(() {
                            //               qtySelected = newValue.toString();
                            //               state.didChange(newValue);
                            //             });
                            //           },
                            //           items: listQty.map((Qty element) {
                            //             return DropdownMenuItem<String>(
                            //               value: element.qtyId,
                            //               child: Text(element.qtyName.toString()),
                            //             );
                            //           }).toList(),
                            //         ),
                            //       ),
                            //     );
                            //   },
                            // ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    color: Theme.of(context).primaryColor,
                    child: Column(
                      children: [
                        Container(
                          height: 40,
                          width: 120,
                          color: Theme.of(context).primaryColor,
                          child: TextButton(
                            style: TextButton.styleFrom(
                                primary: Colors.white,
                                backgroundColor: Colors.grey),
                            onPressed: () {
                              clearSearch();
                            },
                            child: Text('Clear'),
                          ),
                        ),
                        Container(
                          height: 40,
                          width: 120,
                          color: Theme.of(context).primaryColor,
                          child: TextButton(
                            style: TextButton.styleFrom(
                                primary: Colors.black,
                                backgroundColor: Colors.white),
                            onPressed: () {
                              searchProduct();
                            },
                            child: Text('Search'),
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              )
            : Column(),
        isShowSearch
            ? Container(
                color: Theme.of(context).primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      leading: Icon(Icons.search),
                      title: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                            hintText: 'Search', border: InputBorder.none),
                        onChanged: onSearchTextChanged,
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: () async {
                          await Permission.camera.request();
                          String? cameraScanResult = await scanner.scan();
                          if (cameraScanResult != null &&
                              cameraScanResult != '') {
                            _searchController.text = cameraScanResult;
                            getProductByBarcode(cameraScanResult);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              )
            : Column(),
        (isLoading)
            ? CircularProgressIndicator()
            : Container(
                margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Product Code',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Product Name',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Qty',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Unit',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
        Expanded(
          child: Container(
            margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: _searchResult.length != 0 ||
                    _searchController.text.isNotEmpty
                ? ListView.builder(
                    itemCount: _searchResult.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            print("Container _searchResult clicked");
                            productSelected = _searchResult[index];
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
                          decoration: BoxDecoration(
                              color: !widget.isHome &&
                                      isProductSelected(_searchResult[index])
                                  ? Color.fromRGBO(64, 101, 246, 1.0)
                                  : Color.fromRGBO(
                                      colorCodes[index % 2],
                                      colorCodes[index % 2],
                                      colorCodes[index % 2],
                                      1),
                              border: Border(
                                  bottom: BorderSide(
                                      color: Color.fromRGBO(120, 120, 120, 1.0),
                                      width: 1.0))),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _searchResult[index].code.toString(),
                                  style: TextStyle(
                                      color: !widget.isHome &&
                                              isProductSelected(
                                                  _searchResult[index])
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  _searchResult[index].name.toString(),
                                  style: TextStyle(
                                      color: !widget.isHome &&
                                              isProductSelected(
                                                  _searchResult[index])
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  _searchResult[index].qty.toString(),
                                  style: TextStyle(
                                      color: !widget.isHome &&
                                              isProductSelected(
                                                  _searchResult[index])
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  _searchResult[index].unit.toString(),
                                  style: TextStyle(
                                      color: !widget.isHome &&
                                              isProductSelected(
                                                  _searchResult[index])
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    itemCount: isSearch
                        ? _productItemSearchServices.length
                        : _productItem.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            print("Container _productItem clicked");
                            if (isSearch) {
                              productSelected =
                                  _productItemSearchServices[index];
                            } else {
                              productSelected = _productItem[index];
                            }
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
                          decoration: BoxDecoration(
                              color: !widget.isHome &&
                                      isProductSelected(
                                          getProductItemModel(index))
                                  ? Color.fromRGBO(64, 101, 246, 1.0)
                                  : Color.fromRGBO(
                                      colorCodes[index % 2],
                                      colorCodes[index % 2],
                                      colorCodes[index % 2],
                                      1),
                              border: Border(
                                  bottom: BorderSide(
                                      color: Color.fromRGBO(101, 101, 101, 1.0),
                                      width: 1.0))),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  getProductItemModel(index).code.toString(),
                                  style: TextStyle(
                                      color: !widget.isHome &&
                                              isProductSelected(
                                                  getProductItemModel(index))
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  getProductItemModel(index).name.toString(),
                                  style: TextStyle(
                                      color: !widget.isHome &&
                                              isProductSelected(
                                                  getProductItemModel(index))
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  getProductItemModel(index).qty.toString(),
                                  style: TextStyle(
                                      color: !widget.isHome &&
                                              isProductSelected(
                                                  getProductItemModel(index))
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  getProductItemModel(index).unit.toString(),
                                  style: TextStyle(
                                      color: !widget.isHome &&
                                              isProductSelected(
                                                  getProductItemModel(index))
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
        widget.isHome
            ? SizedBox.shrink()
            : Container(
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 24, 24),
                    width: 80,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: productSelected != null
                              ? Color.fromRGBO(64, 101, 246, 1)
                              : Color.fromRGBO(99, 99, 99, 1.0)),
                      onPressed: () {
                        setState(() {
                          if (productSelected != null) {
                            widget.callback(productSelected);
                            print(productSelected.toString());
                            Navigator.pop(context);
                          }
                        });
                      },
                      child: Text('OK'),
                    ),
                  ),
                ]),
              ),
      ],
    );
  }

  ProductItemModel getProductItemModel(int index) {
    if (isSearch) {
      return _productItemSearchServices[index];
    } else {
      return _productItem[index];
    }
  }

  bool isProductSelected(ProductItemModel item) {
    return productSelected != null && productSelected!.code == item.code;
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    if (isSearch) {
      _productItemSearchServices.forEach((productItem) {
        if (productItem.code.contains(text) || productItem.name.contains(text))
          _searchResult.add(productItem);
      });
    } else {
      _productItem.forEach((productItem) {
        if (productItem.code.contains(text) || productItem.name.contains(text))
          _searchResult.add(productItem);
      });
    }

    setState(() {});
  }

  List<ProductItemModel> _searchResult = [];

  List<ProductItemModel> _productItem = [];
}
