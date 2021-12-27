import 'package:checkstockpro/product/product_model.dart';
import 'package:checkstockpro/receiving/item/serial_number.dart';
import 'package:checkstockpro/services/goodsreceive_item.dart';
import 'package:checkstockpro/services/requisition_item.dart';
import 'package:checkstockpro/services/serial.dart';
import 'package:checkstockpro/services/services.dart';
import 'package:flutter/material.dart';

import 'item_model.dart';
import 'item_form.dart';

class ItemList extends StatefulWidget {
  final String type;
  final String id;
  final bool enableEdit;
  final bool? enableSerialNumber;
  final Function? callback;

  const ItemList(
      {Key? key,
      required this.type,
      required this.id,
      required this.enableEdit,
      this.enableSerialNumber,
      this.callback})
      : super(key: key);

  @override
  _ItemList createState() => _ItemList();
}

class _ItemList extends State<ItemList> {
  List<ItemModel> itemModel = <ItemModel>[];
  bool isLoading = true;

  // List<Serial> listSerialNumber = <Serial>[];

  // void getSerial(String productId) async {
  //   List<Serial> list = await Services.getSerial(productId, widget.id);
  //   setState(() {
  //     listSerialNumber = list;
  //   });
  // }

  void getSerialByItemModel(ItemModel itemModel) async {
    if (widget.type == 'requisition') {
      List<Serial> list =
          await Services.getSerialRQ(itemModel.productItem!.id, widget.id);
      setState(() {
        itemModel.listSerialNumber = list;
      });
    } else {
      List<Serial> list =
          await Services.getSerial(itemModel.productItem!.id, widget.id);
      setState(() {
        itemModel.listSerialNumber = list;
      });
    }
  }

  void getItemModel(String id) async {
    setState(() {
      isLoading = true;
      itemModel = <ItemModel>[];
    });
    if (widget.type == 'requisition') {
      List<RequisitionItem> list = await Services.getRequisitionItem(id);
      list.forEach((element) async {
        List<Serial> listSerial =
            await Services.getSerialRQ(element.productId.toString(), id);
        setState(() {
          ProductItemModel productItemModel = ProductItemModel()
            ..name = element.productName.toString()
            ..id = element.productId.toString();
          itemModel.add(ItemModel()
            ..productItem = productItemModel
            ..qty = element.qty
            ..listSerialNumber = listSerial
            ..unitName = element.uomName
            ..isSerial = element.isSerial);
          // ..stockPlace = model.stockPlace
          // ..lotNo = model.lotNo
          // ..manufactureDate = model.manufactureDate
          // ..expiryDate = model.expiryDate;);
        });
      });
      setState(() {
        isLoading = false;
      });
    } else {
      List<GoodsreceiveItem> list = await Services.getGoodsreceiveItem(id);
      list.forEach((element) async {
        List<Serial> listSerial =
            await Services.getSerial(element.productId.toString(), id);
        setState(() {
          ProductItemModel productItemModel = ProductItemModel()
            ..name = element.productName.toString()
            ..id = element.productId.toString();
          itemModel.add(
            ItemModel()
              ..productItem = productItemModel
              ..qty = element.qty
              ..listSerialNumber = listSerial
              ..unitName = element.uomName
              ..isSerial = element.isSerial,
          );
          // ..stockPlace = model.stockPlace
          // ..lotNo = model.lotNo
          // ..manufactureDate = model.manufactureDate
          // ..expiryDate = model.expiryDate;);
        });
      });
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    getItemModel(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? CircularProgressIndicator()
        : Expanded(
                    child: ListView.separated(
                      scrollDirection: Axis.vertical,
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(8),
                      itemCount: itemModel.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 70,
                          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                              border: Border.all(
                                  color: Color.fromRGBO(147, 147, 147, 1.0)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 10,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                    color: Color.fromRGBO(51, 51, 255, 1),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            itemModel[index]
                                                .productItem!
                                                .name
                                                .toString(),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            itemModel[index]
                                                .productItem!
                                                .code
                                                .toString(),
                                          ),
                                        ),
                                        // itemModel[index].lotNo != null
                                        //     ? Expanded(
                                        //         child: Text(
                                        //           itemModel[index].lotNo!,
                                        //           style: TextStyle(color: Colors.red),
                                        //         ),
                                        //       )
                                        //     : SizedBox.shrink(),
                                        itemModel[index]
                                                .listSerialNumber
                                                .isNotEmpty
                                            ? Expanded(
                                                child: Text(
                                                  getTextSerialNo(
                                                      itemModel[index]
                                                          .listSerialNumber),
                                                  style: TextStyle(
                                                      color: Colors.green),
                                                ),
                                              )
                                            : SizedBox.shrink(),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          itemModel[index].qty!,
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  70, 70, 255, 1)),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(itemModel[index].unitName!),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuButton(
                                  color: Color.fromRGBO(245, 245, 245, 1),
                                  itemBuilder: (context) {
                                    return getPopupMenuButton(itemModel[index]);
                                  },
                                  icon: Icon(Icons.more_vert),
                                  onSelected: (String value) {
                                    if (value == 'delete') {
                                      showDeleteItemAlertDialog(context,
                                          itemModel[index].productItem!.id);
                                    }
                                    if (value == 'edit') {
                                      Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (BuildContext context,
                                                Animation<double> animation,
                                                Animation<double>
                                                    secondaryAnimation) {
                                              return ItemForm(
                                                callback: (item) =>
                                                    {getItemModel(widget.id)},
                                                type: widget.type,
                                                itemModel: itemModel[index],
                                                id: widget.id,
                                              );
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
                                    } else if (value == 'serial_number') {
                                      Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (BuildContext context,
                                                Animation<double> animation,
                                                Animation<double>
                                                    secondaryAnimation) {
                                              return SerialNumber(
                                                callback: (item) => {
                                                  getSerialByItemModel(
                                                      itemModel[index])
                                                },
                                                itemModel: itemModel[index],
                                                id: widget.id,
                                                type: widget.type,
                                              );
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
                                    }
                                    // print('You Click on po up menu item');
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                    ),
                  );
            // )
          // );
  }

  String getTextSerialNo(List<Serial> list) {
    print('S/N ' + list.map((e) => e.serialNo).toList().join(", "));
    return 'S/N ' + list.map((e) => e.serialNo).toList().join(", ");
  }

  void showDeleteItemAlertDialog(BuildContext context, String prodId) {
    // set up the buttons
    Widget leftButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget rightButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        Navigator.of(context).pop();
        if (widget.type == "requisition") {
          Services.postRequisitionItemDelete(widget.id, prodId)
              .then((String value) {
            if (value.isEmpty) {
              getItemModel(widget.id);
              widget.callback?.call();
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
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }
          });
        } else {
          Services.postGoodsreceiveItemDelete(widget.id, prodId)
              .then((String value) {
            if (value.isEmpty) {
              getItemModel(widget.id);
              widget.callback?.call();
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
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }
          });
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete Item"),
      content: Text("Would you like to delete this item?"),
      actions: [
        leftButton,
        rightButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  List<PopupMenuItem<String>> getPopupMenuButton(ItemModel itemModel) {
    var list = <PopupMenuItem<String>>[];
    if (widget.enableEdit) {
      list.add(PopupMenuItem(
        value: 'delete',
        child: Text('Delete'),
      ));
    }
    if (int.parse(itemModel.isSerial ?? "0") == 1) {
      list.add(PopupMenuItem(
        value: 'serial_number',
        child: Text('Serial Number'),
      ));
    }
    return list;
  }
}
