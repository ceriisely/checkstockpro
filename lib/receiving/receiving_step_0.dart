import 'package:checkstockpro/receiving/model/receiving_model.dart';
import 'package:checkstockpro/receiving/receiving_step_1.dart';
import 'package:checkstockpro/receiving/receiving_step_2.dart';
import 'package:checkstockpro/services/services.dart';
import 'package:flutter/material.dart';

class Receiving extends StatefulWidget {
  final Function saveReceivingCallback;
  final String? grId;

  const Receiving(
      {Key? key, required this.saveReceivingCallback, required this.grId})
      : super(key: key);

  @override
  _Receiving createState() => _Receiving();
}

class _Receiving extends State<Receiving> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_Receiving');
  Widget bodyWidget = Column();
  ReceivingModel receivingModel = ReceivingModel();
  List<Supplier> supplierList = <Supplier>[];
  int step = 1;
  bool enableBackButton = false;
  String labelRightButton = '';
  int isLoading = 0;

  void getGoodsReceiveByGrId(String grId) async {
    ReceivingModel model = await Services.getGoodsReceive(grId);
    setState(() {
      this.receivingModel = model;
      getSuppliers();
      updateStep(1);
      isLoading++;
    });
  }

  void getSuppliers() async {
    List<Supplier> list = await Services.getSuppliers();
    setState(() {
      supplierList = list;
      this.receivingModel.supplier =
          Supplier.findSupplierByName(list, this.receivingModel.supplierName);
      updateStep(1);
      if (isLoading < 2) {
        isLoading++;
      }
    });
  }

  void updateStep(int value) => setState(() {
        if (value < 1) {
          value = 1;
        } else if (value > 2) {
          value = 2;
        }
        step = value;
        updateValueChanged();
        switch (value) {
          case 1:
            bodyWidget = ReceivingStep1(
                key: this._formKey,
                receivingModel: this.receivingModel,
                supplierList: this.supplierList);
            break;
          case 2:
            bodyWidget =
                ReceivingStep2(grId: this.receivingModel.grId.toString());
            break;
          default:
            bodyWidget = ReceivingStep1(
                key: this._formKey,
                receivingModel: this.receivingModel,
                supplierList: this.supplierList);
            break;
        }
      });

  void updateValueChanged() => setState(() {
        if (step > 1) {
          enableBackButton = true;
        } else {
          enableBackButton = false;
        }
        if (step == 1) {
          labelRightButton = 'Next';
        } else if (step == 2) {
          labelRightButton = 'Save';
        }
      });

  @override
  void initState() {
    if (widget.grId != null && widget.grId != '') {
      getGoodsReceiveByGrId(widget.grId.toString());
    } else {
      updateStep(1);
      getSuppliers();
      isLoading = 2;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(children: [
          Expanded(child: Text('Receiving')),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close),
          )
        ]),
      ),
      body: isLoading < 2
          ? Center(
              child: Container(child: CircularProgressIndicator()),
            )
          : Column(
              children: [
                isLoading == 2
                    ? Expanded(child: bodyWidget)
                    : SizedBox.shrink(),
                Row(
                  children: [
                    enableBackButton
                        ? Expanded(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(24, 0, 0, 24),
                                  width: 80,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                        primary: Colors.black,
                                        backgroundColor: Colors.grey),
                                    onPressed: () {
                                      setState(() {
                                        updateStep(--step);
                                      });
                                    },
                                    child: Text('Back'),
                                  ),
                                ),
                              ]))
                        : Container(
                            margin: EdgeInsets.fromLTRB(24, 0, 0, 24),
                            child: Row(
                              children: getListButtonStatus(),
                            ),
                          ),
                    Expanded(
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
                                  if (((step == 1 &&
                                              _formKey.currentState!
                                                  .validate()) ||
                                          step == 2) ||
                                      canPassNextStep1()) {
                                    // If the form is valid, display a snackbar. In the real world,
                                    // you'd often call a server or save the information in a database.
                                    // ScaffoldMessenger.of(context).showSnackBar(
                                    //   const SnackBar(content: Text('Processing Data')),
                                    // );
                                    setState(() {
                                      if (step == 1) {
                                        if (!canPassNextStep1()) {
                                          Services.postGoodsReceive(
                                                  this.receivingModel)
                                              .then((String value) {
                                            if (value.isEmpty) {
                                              if (this.receivingModel.status ==
                                                      null ||
                                                  this.receivingModel.status ==
                                                      '') {
                                                widget.saveReceivingCallback(
                                                    this.receivingModel);
                                                Navigator.pop(context);
                                              } else {
                                                updateStep(++step);
                                              }
                                            } else {
                                              // show the dialog
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text("Sorry"),
                                                    content: Text(value),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context, 'OK'),
                                                        child: const Text('OK'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          });
                                        } else {
                                          if (this.receivingModel.grId ==
                                                  null ||
                                              this.receivingModel.grId == '') {
                                            widget.saveReceivingCallback(
                                                this.receivingModel);
                                            Navigator.pop(context);
                                          } else {
                                            updateStep(++step);
                                          }
                                        }
                                      } else {
                                        if (labelRightButton == 'Save') {
                                          widget.saveReceivingCallback(
                                              this.receivingModel);
                                          Navigator.pop(context);
                                        } else {
                                          updateStep(++step);
                                        }
                                      }
                                    });
                                  }
                                },
                                child: Text(labelRightButton),
                              ),
                            ),
                          ]),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  bool canPassNextStep1() {
    return this.receivingModel.status == "A" ||
        this.receivingModel.status == "C" ||
        this.receivingModel.status == "R";
  }

  List<ElevatedButton> getListButtonStatus() {
    var list = <ElevatedButton>[];
    if (this.receivingModel.status == "D") {
      // list.add(Elev
      list.add(ElevatedButton(
          style: ElevatedButton.styleFrom(
              minimumSize: Size(100, 40),
              fixedSize: Size(100, 40),
              primary: Color.fromRGBO(64, 101, 246, 1)),
          onPressed: () {
            showConfirmChangeStatus(context, "Send Approve", null);
          },
          child: Text('Send Approve')));
    } else if (this.receivingModel.status == "W" &&
        this.receivingModel.approve == "1") {
      list.add(ElevatedButton(
          style: ElevatedButton.styleFrom(
              minimumSize: Size(100, 40),
              fixedSize: Size(100, 40),
              primary: Colors.green),
          onPressed: () {
            showConfirmChangeStatus(context, "Approve", null);
          },
          child: Text('Approve')));
      list.add(ElevatedButton(
          style: ElevatedButton.styleFrom(
              minimumSize: Size(100, 40),
              fixedSize: Size(100, 40),
              primary: Colors.deepOrange),
          onPressed: () {
            showConfirmChangeStatus(context, "Reject", null);
          },
          child: Text('Reject')));
    }
    return list;
  }

  void backToReceivingHome(BuildContext context) {
    widget.saveReceivingCallback(this.receivingModel);
    Navigator.pop(context);
  }

  showConfirmChangeStatus(
      BuildContext context, String status, Function? callback) {
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
        if (status == "Send Approve") {
          Services.postGoodsreceiveW("grId", widget.grId.toString())
              .then((String value) {
            if (value.isEmpty) {
              backToReceivingHome(context);
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
        } else if (status == "Approve") {
          Services.postGoodsreceiveC("grId", widget.grId.toString())
              .then((String value) {
            if (value.isEmpty) {
              backToReceivingHome(context);
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
        } else if (status == "Reject") {
          Services.postGoodsreceiveR("grId", widget.grId.toString())
              .then((String value) {
                if (value.isEmpty) {
                  backToReceivingHome(context);
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
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Status"),
      content: Text("Would you like to " + status + " ?"),
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
