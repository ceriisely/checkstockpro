import 'package:checkstockpro/component/input_text_field.dart';
import 'package:checkstockpro/requisition/model/requisition_model.dart';
import 'package:checkstockpro/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'requisition_step_0.dart';

class RequisitionMain extends StatefulWidget {
  static final GlobalKey<_RequisitionMain> globalKey = GlobalKey();
  final bool isHome;
  String? selectedStatus;

  RequisitionMain({Key? key, required this.isHome, this.selectedStatus}) : super(key: globalKey);

  @override
  _RequisitionMain createState() => _RequisitionMain();
}

class _RequisitionMain extends State<RequisitionMain>
    with WidgetsBindingObserver {
  bool isLoading = true;
  bool isSearch = false;
  bool isShowSearch = false;
  List<RequisitionModel> listShowRequisitionModel = <RequisitionModel>[];
  List<RequisitionModel> listRequisitionModel = <RequisitionModel>[];
  List<RequisitionModel> listSearchRequisitionModel = <RequisitionModel>[];
  TextEditingController _searchController = TextEditingController();
  String _selectedStatus = "all";
  bool _isHome = false;

  void updateSelectStatus(String status) => setState(() {
    _selectedStatus = status;
    getRequisitionList();
  });

  void updateIsHome(bool isHome) => setState(() {
    _isHome = isHome;
  });

  void getRequisitionList() async {
    setState(() {
      isLoading = true;
      listRequisitionModel = <RequisitionModel>[];
    });
    late List<RequisitionModel> list;
    if (_isHome) {
      list = await Services.getRequisitionW();
    } else {
      print('selectedStatus = ' + _selectedStatus);
      if (_selectedStatus == 'all') {
        list = await Services.getRequisitionLst();
      } else {
        list = await Services.searchRequisition(_selectedStatus);
      }
    }
    setState(() {
      list.forEach((element) {
        if (_isHome && element.status == "W") {
          listRequisitionModel.add(element);
        } else if (!_isHome) {
          listRequisitionModel.add(element);
        }
      });
      listShowRequisitionModel = listRequisitionModel;
      isLoading = false;
    });
  }

  @override
  void initState() {
    setState(() {
      _selectedStatus = widget.selectedStatus ?? 'all';
      _isHome = widget.isHome;
    });
    getRequisitionList();
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getRequisitionList();
    }
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
                    child: SingleChildScrollView(
                      child: getListView(),
                    ),
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
                                            return Requisition(
                                              saveRequisitionCallback: (model) {
                                                getRequisitionList();
                                              },
                                              rqId: '',
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
      itemCount: listShowRequisitionModel.length,
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
                        listShowRequisitionModel[index].status),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                    child: Column(
                      children: [
                        Expanded(
                          child: Text(
                            listShowRequisitionModel[index].documentNumber!,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            listShowRequisitionModel[index].documentDate!,
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
                        child: Text(listShowRequisitionModel[index].cnt.toString()),
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
                    if (canDelete(listShowRequisitionModel[index])) {
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
                      showDeleteAlertDialog(
                          context, listShowRequisitionModel[index].rqId.toString());
                    } else if (value == 'edit') {
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (BuildContext context,
                                Animation<double> animation,
                                Animation<double> secondaryAnimation) {
                              return Requisition(
                                saveRequisitionCallback: (model) {
                                  getRequisitionList();
                                },
                                rqId: listShowRequisitionModel[index].rqId,
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
      case "A":
        return Colors.green;
      case "C":
        return Colors.green;
      case "R":
        return Colors.red;
    }
    return Color.fromRGBO(51, 51, 255, 1);
  }

  bool canDelete(RequisitionModel model) {
    return model.status == "W" || model.status == "D";
  }

  void showDeleteAlertDialog(BuildContext context, String rqId) {
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
        Services.postRequisitionDelete(rqId).then((String value) {
          if (value.isEmpty) {
            getRequisitionList();
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
    listSearchRequisitionModel.clear();
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
      listRequisitionModel.forEach((element) {
        if (element.documentNumber
            .toString()
            .toLowerCase()
            .contains(text.toLowerCase())) {
          listSearchRequisitionModel.add(element);
        }
      });
      setState(() {
        listShowRequisitionModel = listSearchRequisitionModel;
      });
    } else {
      setState(() {
        listShowRequisitionModel = listRequisitionModel;
      });
    }
  }
}
