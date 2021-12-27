import 'package:checkstockpro/item/item_model.dart';
import 'package:checkstockpro/item/item_form.dart';
import 'package:checkstockpro/receiving/model/receiving_model.dart';
import 'package:checkstockpro/item/item_list.dart';
import 'package:checkstockpro/services/services.dart';
import 'package:flutter/material.dart';

class ReceivingStep2 extends StatefulWidget {
  // final ReceivingModel receivingModel;

  // const ReceivingStep2({Key? key, required this.receivingModel})
  //     : super(key: key);

  final String grId;

  const ReceivingStep2({Key? key, required this.grId}) : super(key: key);

  @override
  _ReceivingStep2 createState() => _ReceivingStep2();
}

class _ReceivingStep2 extends State<ReceivingStep2> {
  bool isLoading = true;
  bool isShowList = false;
  late ReceivingModel _model;

  void getGoodsReceive() async {
    setState(() {
      isLoading = true;
    });
    ReceivingModel model =
        await Services.getGoodsReceive(widget.grId.toString());
    setState(() {
      _model = model;
      isLoading = false;
    });
  }

  @override
  void initState() {
    getGoodsReceive();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: Container(child: CircularProgressIndicator()),
          )
        : Form(
            child: Column(
              children: [
                Expanded(
                  child: Column(children: [
                    Row(children: [TextButton.icon(
                      onPressed: () {
                        setState(() {
                          isShowList = !isShowList;
                        });
                      },
                      label: isShowList ? Text('Hide Detail') : Text('Show Detail'),
                      icon: Icon(
                        Icons.arrow_drop_down_circle,
                      ),
                    )]),
                    isShowList ? Container(
                      margin: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          color: Color.fromRGBO(245, 245, 245, 1)),
                      child: Column(
                        children: [
                          getWidgetOfData(
                              'Document No:', _model.documentNumber.toString()),
                          getWidgetOfData(
                              'Document Date:', _model.documentDate.toString()),
                          getWidgetOfData(
                              'Supplier:', _model.supplierName ?? ''),
                          getWidgetOfData(
                              'Ref PO No.:', _model.referencePONo.toString()),
                          getWidgetOfData('Remark:', _model.remark.toString()),
                          getWidgetOfData('Total:', _model.cnt.toString()),
                          _model.status == "R"
                              ? getWidgetOfData('rejectCommect:',
                                  _model.rejectCommect.toString())
                              : Text('')
                        ],
                      ),
                    ) : Column(),
                    Container(
                      child: ItemList(
                        type: 'receiving',
                        id: _model.grId.toString(),
                        enableEdit: enableEditItemModel(),
                        callback: () => {getGoodsReceive()},
                      ),
                    ),
                  ]),
                ),
                enableEditItemModel()
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 16, 16),
                              child: FloatingActionButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (BuildContext context,
                                            Animation<double> animation,
                                            Animation<double>
                                                secondaryAnimation) {
                                          return ItemForm(
                                            callback: (item) =>
                                                {getGoodsReceive()},
                                            type: 'receiving',
                                            itemModel: ItemModel(),
                                            id: widget.grId,
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
                                },
                                tooltip: 'Increment',
                                child: Icon(Icons.add),
                              ))
                        ],
                      )
                    : Column(),
              ],
            ),
          );
  }

  Widget getWidgetOfData(String title, String value) {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: Color.fromRGBO(228, 228, 228, 1), width: 1.0))),
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: Text(
                  title,
                  textAlign: TextAlign.end,
                )),
            Expanded(
                flex: 2,
                child: Container(
                    margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: Text(value.toString())))
          ],
        ));
  }

  bool enableEditItemModel() {
    return _model.status != "A" && _model.status != "C" && _model.status != "R";
  }
}
