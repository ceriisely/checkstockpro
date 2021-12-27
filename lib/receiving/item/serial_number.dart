import 'package:checkstockpro/component/input_text_field.dart';
import 'package:checkstockpro/item/item_model.dart';
import 'package:checkstockpro/product/product_model.dart';
import 'package:checkstockpro/services/product.dart';
import 'package:checkstockpro/services/serial.dart';
import 'package:checkstockpro/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SerialNumber extends StatefulWidget {
  final Function callback;
  final ItemModel itemModel;
  final String id;
  final String type;

  const SerialNumber(
      {Key? key,
      required this.callback,
      required this.itemModel,
      required this.id,
      required this.type})
      : super(key: key);

  @override
  _SerialNumber createState() => _SerialNumber();
}

class _SerialNumber extends State<SerialNumber> {
  List<Serial> listSerial = <Serial>[];
  TextEditingController _inputController = TextEditingController();
  ItemModel item = ItemModel();
  bool isLoading = true;

  void getProduct() async {
    List<Product> list = await Services.getProduct();
    setState(() {
      list.forEach((element) {
        if (element.productName == widget.itemModel.productItem!.name) {
          setState(() {
            item.productItem = ProductItemModel()
              ..code = element.productCode
              ..id = element.productId
              ..name = element.productName
              ..qty = element.qty
              ..unit = element.unit;
          });
          isLoading = false;
          getSerial();
        }
      });
    });
  }

  void getSerial() async {
    late List<Serial> list;
    if (widget.type == "requisition") {
      list = await Services.getSerialRQ(item.productItem!.id, widget.id);
    } else {
      list = await Services.getSerial(item.productItem!.id, widget.id);
    }
    setState(() {
      listSerial = list;
    });
  }

  void postSerial(String serial) async {
    if (widget.type == "requisition") {
      Services.postSerialRQ(serial, item.productItem!.id, widget.id)
          .then((String value) {
        if (value.isEmpty) {
          getSerial();
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
      Services.postSerial(serial, item.productItem!.id, widget.id)
          .then((String value) {
        if (value.isEmpty) {
          getSerial();
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
  }

  @override
  void dispose() {
    super.dispose();
    _inputController.dispose();
  }

  @override
  void initState() {
    getProduct();
    super.initState();
    // this.listSerial = widget.itemModel.listSerialNumber;
    // _inputController.selection = TextSelection.fromPosition(
    //     TextPosition(offset: _inputController.text.length));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Expanded(child: Text('Input Serial Number')),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close))
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(24, 16, 0, 10),
                        child: Text(
                          item.productItem!.code,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(24, 0, 24, 0),
                      child: Text(
                        item.productItem!.name,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(24, 16, 24, 16),
                    child: TextFormField(
                      autofocus: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please input serial number';
                        }
                        return null;
                      },
                      controller: _inputController,
                      decoration: InputDecoration(
                          labelText: 'Serial Number',
                          hintText: 'Serial Number',
                          focusedBorder: defaultFocusedBorder,
                          enabledBorder: defaultBorder,
                          errorBorder: errorBorder,
                          focusedErrorBorder: errorBorder,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                if (_inputController.text != '') {
                                  postSerial(_inputController.text);
                                  // listSerial.add(_inputController.text);
                                  _inputController.text = '';
                                }
                              });
                            },
                            icon: Icon(Icons.archive),
                          )),
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.fromLTRB(28, 0, 28, 0),
                      itemCount: listSerial.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                listSerial[index].serialNo.toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              )),
                              IconButton(
                                  onPressed: () {
                                    showDeleteSerial(context, widget.id,
                                        listSerial[index].serialNo.toString());
                                  },
                                  icon: Icon(Icons.delete))
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                    ),
                  ),
                  Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 24, 24),
                            width: 80,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  backgroundColor:
                                      Color.fromRGBO(64, 101, 246, 1)),
                              onPressed: () {
                                setState(() {
                                  widget.callback(listSerial);
                                  Navigator.pop(context);
                                });
                              },
                              child: Text('OK'),
                            ),
                          ),
                        ]),
                  ),
                ],
              ),
            ),
    );
  }

  void showDeleteSerial(BuildContext context, String id, String serial) {
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
        if (widget.type == "requisition") {
          Services.postSerialDeleteRQ(id, serial).then((String value) {
            if (value.isEmpty) {
              getSerial();
            } else {
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
          Services.postSerialDelete(id, serial).then((String value) {
            if (value.isEmpty) {
              getSerial();
            } else {
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
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete Serial"),
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
}
