import 'dart:math';

import 'package:checkstockpro/account/account.dart';
import 'package:checkstockpro/product/product_item.dart';
import 'package:checkstockpro/receiving/receiving_main.dart';
import 'package:checkstockpro/requisition/requisition_main.dart';
import 'package:checkstockpro/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  late Widget bodyWidget;
  int selectedIndex = 0;
  String selectedStatusReceiving = 'all';
  String selectedStatusRequisition = 'all';
  bool isShowSearch = false;

  void _selectIndex(int index) =>
      setState(() => {selectedIndex = index, updateBodyWidget()});

  void updateBodyWidget() => setState(() {
        print("updateBodyWidget = " +
            selectedIndex.toString() +
            " selectedStatusReceiving = " +
            selectedStatusReceiving.toString());
        if (selectedIndex == 0) {
          bodyWidget = Column(
            children: [
              ReceivingMain(
                isHome: true,
              ),
              RequisitionMain(
                isHome: true,
              )
            ],
          );
          ReceivingMain.globalKey.currentState?.updateIsHome(true);
          ReceivingMain.globalKey.currentState?.getListReceiving();
          RequisitionMain.globalKey.currentState?.updateIsHome(true);
          RequisitionMain.globalKey.currentState?.getRequisitionList();
        } else if (selectedIndex == 1) {
          bodyWidget = ReceivingMain(
              isHome: false, selectedStatus: selectedStatusReceiving);
          ReceivingMain.globalKey.currentState?.updateIsHome(false);
          ReceivingMain.globalKey.currentState
              ?.updateSelectStatus(selectedStatusReceiving);
        } else if (selectedIndex == 2) {
          bodyWidget = RequisitionMain(
              isHome: false, selectedStatus: selectedStatusRequisition);
          RequisitionMain.globalKey.currentState?.updateIsHome(false);
          RequisitionMain.globalKey.currentState
              ?.updateSelectStatus(selectedStatusReceiving);
        } else if (selectedIndex == 3) {
          bodyWidget = ProductItem(callback: (product) => {}, isHome: true);
        } else if (selectedIndex == 4) {
          bodyWidget = Account();
        } else {
          bodyWidget = SizedBox.shrink();
        }
      });

  String getTitle() {
    if (selectedIndex == 0) {
      return 'Home';
    } else if (selectedIndex == 1) {
      return 'Receiving';
    } else if (selectedIndex == 2) {
      return 'Requisition';
    } else if (selectedIndex == 3) {
      return 'Product';
    } else if (selectedIndex == 4) {
      return 'Account';
    } else {
      return '';
    }
  }

  bool getIconInfo() {
    if (selectedIndex == 0 || selectedIndex == 1 || selectedIndex == 2) {
      return true;
    } else {
      return false;
    }
  }

  String getTextStatus() {
    if (selectedIndex == 1) {
      return getStatus(selectedStatusReceiving);
    }
    return getStatus(selectedStatusRequisition);
  }

  String getStatus(String status) {
    switch (status) {
      case "all":
        return "Select Status";
      case "D":
        return "เอกสารร่าง";
      case "W":
        return "เอกสารรออนุมัติ";
      case "A":
        return "เอกสารอนุมัติ";
      case "C":
        return "เอกสารสมบูรณ์";
      case "R":
        return "เอกสารไม่อนุมัติ";
      default:
        return "";
    }
  }

  Widget getTitleAppBar() {
    if (selectedIndex == 1 || selectedIndex == 2) {
      return Row(
        children: [
          Text(getTitle()),
          Spacer(),
          TextButton.icon(
            onPressed: () {
              setState(() {
                selectStatusDialog();
              });
            },
            label: Text(
              getTextStatus(),
              style: TextStyle(color: Colors.white),
            ),
            icon: Icon(
              Icons.arrow_drop_down_circle,
              color: Colors.white,
            ),
          ),
          IconButton(
              onPressed: () {
                onClickInfo();
              },
              icon: Icon(Icons.info_outline))
        ],
      );
    } else if (selectedIndex == 3) {
      return Row(
        children: [
          Text(getTitle()),
          Spacer(),
          TextButton.icon(
            onPressed: () {
              setState(() {
                isShowSearch = !isShowSearch;
                ProductItem.globalKey.currentState
                    ?.toggleIsShowSearch();
              });
            },
            label: Text(
              "Search",
              style: TextStyle(color: Colors.white),
            ),
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
          ),
        ],
      );
    } else {
      return Text(getTitle());
    }
  }

  List<Widget> getSimpleDialogOption() {
    var list = <Widget>[
      SimpleDialogOption(
        onPressed: () {
          onSelectStatus('all');
          Navigator.pop(context, 'All');
        },
        child: const Text('All'),
      ),
      SimpleDialogOption(
        onPressed: () {
          onSelectStatus('D');
          Navigator.pop(context, 'Draft');
        },
        child: const Text('เอกสารร่าง'),
      ),
      SimpleDialogOption(
        onPressed: () {
          onSelectStatus('W');
          Navigator.pop(context, 'Waiting for approve');
        },
        child: const Text('เอกสารรออนุมัติ'),
      ),
    ];
    if (selectedIndex == 1) {
      list.add(SimpleDialogOption(
        onPressed: () {
          onSelectStatus('C');
          Navigator.pop(context, 'Complete');
        },
        child: const Text('เอกสารสมบูรณ์'),
      ));
    }
    if (selectedIndex == 2) {
      list.add(SimpleDialogOption(
        onPressed: () {
          onSelectStatus('A');
          Navigator.pop(context, 'Approve');
        },
        child: const Text('เอกสารอนุมัติ'),
      ));
      list.add(SimpleDialogOption(
        onPressed: () {
          onSelectStatus('C');
          Navigator.pop(context, 'Complete');
        },
        child: const Text('เอกสารสมบูรณ์'),
      ));
    }
    list.add(SimpleDialogOption(
      onPressed: () {
        onSelectStatus('R');
        Navigator.pop(context, 'Reject');
      },
      child: const Text('เอกสารไม่อนุมัติ'),
    ));
    return list;
  }

  void selectStatusDialog() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select Status'),
          children: getSimpleDialogOption(),
        );
      },
    );
  }

  void onSelectStatus(String status) {
    if (selectedIndex == 1) {
      setState(() {
        print('onSelectStatus 1 = ' + status);
        selectedStatusReceiving = status;
        ReceivingMain.globalKey.currentState?.updateSelectStatus(status);
      });
    } else {
      setState(() {
        print('onSelectStatus 2 = ' + status);
        selectedStatusRequisition = status;
        RequisitionMain.globalKey.currentState?.updateSelectStatus(status);
      });
    }
  }

  void onClickInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Info"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '- สีน้ำเงิน = Draft',
                textAlign: TextAlign.left,
              ),
              Text(
                '- สีเหลือง = Waiting for approve',
                textAlign: TextAlign.left,
              ),
              Text(
                '- สีเขียว = Approve',
                textAlign: TextAlign.left,
              ),
              Text(
                '- สีแดง = Reject',
                textAlign: TextAlign.left,
              ),
            ],
          ),
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

  @override
  void initState() {
    super.initState();
    updateBodyWidget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: getTitleAppBar(),
      ),
      body: bodyWidget,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                _selectIndex(0);
              },
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.archive),
              onPressed: () {
                _selectIndex(1);
              },
            ),
            label: 'Receiving',
          ),
          BottomNavigationBarItem(
            // icon: Icon(Icons.archive),
            icon: Transform.rotate(
              angle: 180 * pi / 180,
              child: IconButton(
                icon: Icon(Icons.archive),
                onPressed: () {
                  _selectIndex(2);
                },
              ),
            ),
            label: 'Requisition',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.list),
              onPressed: () {
                _selectIndex(3);
              },
            ),
            label: 'Product',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                _selectIndex(4);
              },
            ),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
