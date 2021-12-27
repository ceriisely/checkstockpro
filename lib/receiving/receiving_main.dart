import 'package:checkstockpro/component/input_text_field.dart';
import 'package:checkstockpro/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'model/receiving_model.dart';

import 'receiving_step_0.dart';

class ReceivingMain extends StatefulWidget {
  static final GlobalKey<_ReceivingMain> globalKey = GlobalKey();
  final bool isHome;
  String? selectedStatus;

  ReceivingMain({Key? key, required this.isHome, this.selectedStatus})
      : super(key: globalKey);

  @override
  _ReceivingMain createState() => _ReceivingMain();
}

class _ReceivingMain extends State<ReceivingMain> {
  bool isLoading = true;
  bool isSearch = false;
  bool isShowSearch = false;
  List<ReceivingModel> listShowReceivingModel = <ReceivingModel>[];
  List<ReceivingModel> listReceivingModel = <ReceivingModel>[];
  List<ReceivingModel> listSearchReceivingModel = <ReceivingModel>[];
  TextEditingController _searchController = TextEditingController();
  String _selectedStatus = "all";
  bool _isHome = false;

  void updateSelectStatus(String status) => setState(() {
    _selectedStatus = status;
    getListReceiving();
  });

  void updateIsHome(bool isHome) => setState(() {
    _isHome = isHome;
  });

  void getListReceiving() async {
    print("getListReceiving");
    setState(() {
      isLoading = true;
      listReceivingModel = <ReceivingModel>[];
    });
    late List<ReceivingModel> list;
    if (_isHome) {
      list = await Services.getGoodsreceiveW();
    } else {
      print('selectedStatus = ' + _selectedStatus);
      if (_selectedStatus == 'all') {
        list = await Services.getGoodsReceiveLst();
      } else {
        list = await Services.searchGoodsreceive(_selectedStatus);
      }
    }
    setState(() {
      list.forEach((element) {
        if (_isHome && element.status == "W") {
          listReceivingModel.add(element);
        } else if (!_isHome) {
          listReceivingModel.add(element);
        }
      });
      listShowReceivingModel = listReceivingModel;
      isLoading = false;
    });
  }

  @override
  void initState() {
    print("initState");
    setState(() {
      _selectedStatus = widget.selectedStatus ?? 'all';
      _isHome = widget.isHome;
    });
    getListReceiving();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: Container(child: CircularProgressIndicator()),
          )
        : widget.isHome
            ? getListView()
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(child: getListView()),
                  ),
                  !widget.isHome
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: ListTile(
                                title: isShowSearch
                                    ? TextField(
                                        controller: _searchController,
                                        decoration: InputDecoration(
                                          hintText: 'Search',
                                          border: defaultFocusedBorder,
                                          suffixIcon: IconButton(
                                            icon: Icon(Icons.cancel),
                                            onPressed: () {
                                              _searchController.clear();
                                              onSearchTextChanged('');
                                            },
                                          ),
                                        ),
                                        onChanged: onSearchTextChanged,
                                      )
                                    : SizedBox.shrink(),
                                trailing: FloatingActionButton(
                                  onPressed: () {
                                    setState(() {
                                      isShowSearch = !isShowSearch;
                                    });
                                  },
                                  child: isShowSearch
                                      ? Icon(Icons.arrow_forward_ios)
                                      : Icon(Icons.search),
                                ),
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.fromLTRB(0, 16, 16, 16),
                                child: FloatingActionButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (BuildContext context,
                                              Animation<double> animation,
                                              Animation<double>
                                                  secondaryAnimation) {
                                            return Receiving(
                                              saveReceivingCallback: (model) {
                                                getListReceiving();
                                              },
                                              grId: '',
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
              );
  }

  Widget getListView() {
    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      itemCount: listShowReceivingModel.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              border: Border.all(color: Color.fromRGBO(147, 147, 147, 1.0)),
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
                    color: getColorTabFromStatus(
                        listShowReceivingModel[index].status),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                    child: Column(
                      children: [
                        Expanded(
                          child: Text(
                            listShowReceivingModel[index].documentNumber!,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            listShowReceivingModel[index].documentDate!,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: Column(
                    children: [
                      Expanded(
                        child:
                            Text(listShowReceivingModel[index].cnt.toString()),
                      ),
                      Expanded(
                        child: Text('Items'),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  color: Color.fromRGBO(245, 245, 245, 1),
                  itemBuilder: (context) {
                    var list = <PopupMenuItem<String>>[];
                    list.add(PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit'),
                    ));
                    if (canDelete(listShowReceivingModel[index])) {
                      list.add(PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ));
                    }
                    return list;
                  },
                  icon: Icon(Icons.more_vert),
                  onSelected: (String value) {
                    if (value == 'delete') {
                      showDeleteAlertDialog(context,
                          listShowReceivingModel[index].grId.toString());
                    } else if (value == 'edit') {
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (BuildContext context,
                                Animation<double> animation,
                                Animation<double> secondaryAnimation) {
                              return Receiving(
                                saveReceivingCallback: (model) {
                                  getListReceiving();
                                },
                                grId: listShowReceivingModel[index].grId,
                              );
                            },
                            transitionsBuilder: (BuildContext context,
                                Animation<double> animation,
                                Animation<double> secondaryAnimation,
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
                  },
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  Color getColorTabFromStatus(status) {
    switch (status) {
      case "D":
        return Color.fromRGBO(51, 51, 255, 1);
      case "W":
        return Colors.yellow;
      case "C":
        return Colors.green;
      case "A":
        return Colors.green;
      case "R":
        return Colors.red;
    }
    return Color.fromRGBO(51, 51, 255, 1);
  }

  bool canDelete(ReceivingModel model) {
    return model.status == "W" || model.status == "D";
  }

  void showDeleteAlertDialog(BuildContext context, String grId) {
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
        Services.postGoodsreceiveDelete(grId).then((String value) {
          if (value.isEmpty) {
            getListReceiving();
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
        Navigator.of(context).pop();
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

  onSearchTextChanged(String text) async {
    listSearchReceivingModel.clear();
    if (text.isEmpty) {
      setState(() {
        isSearch = false;
      });
    } else {
      setState(() {
        isSearch = true;
      });
    }

    if (isSearch) {
      listReceivingModel.forEach((element) {
        if (element.documentNumber
            .toString()
            .toLowerCase()
            .contains(text.toLowerCase())) {
          listSearchReceivingModel.add(element);
        }
      });
      setState(() {
        listShowReceivingModel = listSearchReceivingModel;
      });
    } else {
      setState(() {
        listShowReceivingModel = listReceivingModel;
      });
    }
  }
}
