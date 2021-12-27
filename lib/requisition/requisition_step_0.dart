import 'package:checkstockpro/requisition/requisition_step_1.dart';
import 'package:checkstockpro/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'model/requisition_model.dart';
import 'requisition_step_2.dart';

class Requisition extends StatefulWidget {
  final Function saveRequisitionCallback;
  final String? rqId;

  const Requisition(
      {Key? key, required this.saveRequisitionCallback, required this.rqId})
      : super(key: key);

  @override
  _Requisition createState() => _Requisition();
}

class _Requisition extends State<Requisition> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_Requisition');
  Widget bodyWidget = Column();
  RequisitionModel requisitionModel = RequisitionModel();
  int step = 1;
  bool enableBackButton = false;
  String labelRightButton = '';
  bool isLoading = true;

  void getRequisitionByRqId(String rqId) async {
    RequisitionModel model = await Services.getRequisitionByRqId(rqId);
    setState(() {
      this.requisitionModel = model;
      updateStep(1);
      isLoading = false;
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
            bodyWidget = RequisitionStep1(
                key: _formKey, requisitionModel: requisitionModel);
            break;
          case 2:
            bodyWidget = RequisitionStep2(
              rqId: this.requisitionModel.rqId.toString(),
            );
            break;
          default:
            bodyWidget = RequisitionStep1(
                key: _formKey, requisitionModel: requisitionModel);
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
    if (widget.rqId != null && widget.rqId != '') {
      getRequisitionByRqId(widget.rqId.toString());
    } else {
      updateStep(1);
      isLoading = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(children: [
          Expanded(child: Text('Requisition')),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close),
          )
        ]),
      ),
      body: isLoading
          ? Center(
              child: Container(child: CircularProgressIndicator()),
            )
          : Column(
              children: [
                !isLoading ? Expanded(child: bodyWidget) : Column(),
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
                                ]),
                          )
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
                                  print('requisition step ' +
                                      step.toString());
                                  if (((step == 1 &&
                                              _formKey.currentState?.validate() == true) ||
                                          step == 2) ||
                                      canPassNextStep1()) {
                                    setState(() {
                                      if (step == 1) {
                                        print('canPassNextStep1 = ' + canPassNextStep1().toString());
                                        if (!canPassNextStep1()) {
                                          Services.postRequisition(
                                                  this.requisitionModel)
                                              .then((String value) {
                                            if (value.isEmpty) {
                                              if (this
                                                          .requisitionModel
                                                          .status ==
                                                      null ||
                                                  this
                                                          .requisitionModel
                                                          .status ==
                                                      '') {
                                                widget.saveRequisitionCallback(
                                                    this.requisitionModel);
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
                                          if (this.requisitionModel.rqId ==
                                                  null ||
                                              this.requisitionModel.rqId ==
                                                  '') {
                                            widget.saveRequisitionCallback(
                                                this.requisitionModel);
                                            Navigator.pop(context);
                                          } else {
                                            updateStep(++step);
                                          }
                                        }
                                      } else {
                                        if (labelRightButton == 'Save') {
                                          widget.saveRequisitionCallback(
                                              this.requisitionModel);
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
    print('requisitionModel.status = ' + this.requisitionModel.status.toString());
    return this.requisitionModel.status == "C" ||
        this.requisitionModel.status == "A" ||
        this.requisitionModel.status == "R";
  }

  void backToReceivingHome(BuildContext context) {
    widget.saveRequisitionCallback(this.requisitionModel);
    Navigator.pop(context);
  }

  List<ElevatedButton> getListButtonStatus() {
    var list = <ElevatedButton>[];
    if (this.requisitionModel.status == "D") {
      // list.add(Elev
      list.add(ElevatedButton(
          style: ElevatedButton.styleFrom(
              minimumSize: Size(100, 40),
              fixedSize: Size(100, 40),
              primary: Color.fromRGBO(64, 101, 246, 1)),
          onPressed: () {
            // showConfirmChangeStatus(context, "Send Approve",
            //     Services.postGoodsreceiveW(widget.grId.toString()));
            showConfirmChangeStatus(context, "Send Approve", null);
          },
          child: Text('Send Approve')));
    } else if (this.requisitionModel.status == "W" &&
        this.requisitionModel.approve == "1") {
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
    } else if (this.requisitionModel.status == "A" &&
        this.requisitionModel.approve == "1") {
      list.add(ElevatedButton(
          style: ElevatedButton.styleFrom(
              minimumSize: Size(100, 40),
              fixedSize: Size(100, 40),
              primary: Colors.green),
          onPressed: () {
            showConfirmChangeStatus(context, "Confirm", null);
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
    } else if (this.requisitionModel.status == "A" &&
        this.requisitionModel.approve == 1) {
      list.add(ElevatedButton(
          style: ElevatedButton.styleFrom(
              minimumSize: Size(100, 40),
              fixedSize: Size(100, 40),
              primary: Colors.green),
          onPressed: () {
            showConfirmChangeStatus(context, "Confirm", null);
          },
          child: Text('Confirm')));
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
          Services.postRequisitionW("rqId", widget.rqId.toString())
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
          Services.postRequisitionA("rqId", widget.rqId.toString())
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
        } else if (status == "Confirm") {
          Services.postRequisitionC("rqId", widget.rqId.toString())
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
          Services.postRequisitionR("rqId", widget.rqId.toString())
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
