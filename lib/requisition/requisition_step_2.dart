import 'package:checkstockpro/item/item_model.dart';
import 'package:checkstockpro/item/item_form.dart';
import 'package:checkstockpro/item/item_list.dart';
import 'package:checkstockpro/services/services.dart';
import 'package:flutter/material.dart';

import 'model/requisition_model.dart';

class RequisitionStep2 extends StatefulWidget {
  final String rqId;

  const RequisitionStep2({Key? key, required this.rqId}) : super(key: key);

  @override
  _RequisitionStep2 createState() => _RequisitionStep2();
}

class _RequisitionStep2 extends State<RequisitionStep2> {
  bool isLoading = true;
  bool isShowList = false;
  late RequisitionModel requisitionModel;

  void getRequisitionByRqId(String rqId) async {
    setState(() {
      isLoading = true;
    });
    RequisitionModel model = await Services.getRequisitionByRqId(rqId);
    setState(() {
      this.requisitionModel = model;
      isLoading = false;
    });
  }

  @override
  void initState() {
    getRequisitionByRqId(widget.rqId);
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
                          getWidgetOfData('Document No:',
                              this.requisitionModel.documentNumber.toString()),
                          getWidgetOfData('Document Date:',
                              this.requisitionModel.documentDate.toString()),
                          getWidgetOfData('Employee:',
                              this.requisitionModel.employeeName.toString()),
                          // getWidgetOfData('Project:',
                          //     this.requisitionModel.projectName.toString()),
                          getWidgetOfData('Remark:',
                              this.requisitionModel.remarkName ?? ''),
                          getWidgetOfData(
                              'Total:', this.requisitionModel.cnt.toString()),
                          this.requisitionModel.status == "R"
                              ? getWidgetOfData(
                                  'rejectCommect:',
                                  this
                                      .requisitionModel
                                      .rejectCommect
                                      .toString())
                              : Text('')
                        ],
                      ),
                    ) : Column(),
                    Container(
                      child: ItemList(
                        type: 'requisition',
                        id: this.requisitionModel.rqId.toString(),
                        enableEdit: enableEditItemModel(),
                        callback: () => getRequisitionByRqId(widget.rqId),
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
                                            callback: (item) => {
                                              getRequisitionByRqId(widget.rqId)
                                            },
                                            type: 'requisition',
                                            itemModel: ItemModel(),
                                            id: widget.rqId,
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
                    child: Text(value)))
          ],
        ));
  }

  bool enableEditItemModel() {
    return requisitionModel.status != "A" &&
        requisitionModel.status != "C" &&
        requisitionModel.status != "R";
  }
}
