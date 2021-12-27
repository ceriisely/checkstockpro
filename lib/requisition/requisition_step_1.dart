import 'package:checkstockpro/component/input_text_field.dart';
import 'package:checkstockpro/services/customer.dart';
import 'package:checkstockpro/services/employee.dart';
import 'package:checkstockpro/services/project.dart';
import 'package:checkstockpro/services/remark.dart';
import 'package:checkstockpro/services/services.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import 'model/requisition_model.dart';

class RequisitionStep1 extends StatefulWidget {
  final RequisitionModel requisitionModel;

  const RequisitionStep1({Key? key, required this.requisitionModel})
      : super(key: key);

  @override
  _RequisitionStep1 createState() => _RequisitionStep1();
}

class _RequisitionStep1 extends State<RequisitionStep1> {
  TextEditingController _documentNumberController = TextEditingController();
  TextEditingController _documentDateController = TextEditingController();
  TextEditingController _employeeController = TextEditingController();
  List<Employee> _employeeList = <Employee>[];
  List<Remark> _remarkList = <Remark>[];
  String? _validateEmployee;
  String? _validateRemark;
  String? _validateDocumentDate;

  // void getCustomers() async {
  //   List<Customer> list = await Services.getCustomers();
  //   setState(() {
  //     _customerList = list;
  //     if (widget.requisitionModel.customerName != null &&
  //         widget.requisitionModel.customerName != '') {
  //       widget.requisitionModel.customer = RequisitionModel.findCustomerByName(
  //           list, widget.requisitionModel.customerName);
  //     }
  //   });
  // }

  // void getProjects(String custId) async {
  //   List<Project> list = await Services.getProject(custId);
  //   setState(() {
  //     _projectList = list;
  //     if (widget.requisitionModel.projectName != null &&
  //         widget.requisitionModel.projectName != '') {
  //       widget.requisitionModel.project = RequisitionModel.findProjectByName(
  //           list, widget.requisitionModel.projectName);
  //     }
  //   });
  // }

  String getNewRequisitionDocumentNumber() {
    return "RQ" +
        DateTime.now().year.toString() +
        "-" +
        DateTime.now().millisecondsSinceEpoch.toString().substring(0, 10);
  }

  void getEmployee() async {
    List<Employee> list = await Services.getEmployee();
    setState(() {
      _employeeList = list;
      if (widget.requisitionModel.employeeName != null &&
          widget.requisitionModel.employeeName != '') {
        widget.requisitionModel.employee = RequisitionModel.findEmployeeByName(
            list, widget.requisitionModel.employeeName);
      }
    });
  }

  void getRemark() async {
    List<Remark> list = await Services.getRemark();
    setState(() {
      _remarkList = list;
      if (widget.requisitionModel.remarkName != null &&
          widget.requisitionModel.remarkName != '') {
        widget.requisitionModel.remark = RequisitionModel.findRemarkByName(
            list, widget.requisitionModel.remarkName);
      }
    });
  }

  bool canUpdateData() {
    return widget.requisitionModel.status == "D" ||
        widget.requisitionModel.status == "W" ||
        widget.requisitionModel.status == "" ||
        widget.requisitionModel.status == null;
  }

  @override
  void initState() {
    // getCustomers();
    getEmployee();
    getRemark();
    super.initState();
    if (widget.requisitionModel.documentNumber != null) {
      _documentNumberController.text =
          widget.requisitionModel.documentNumber.toString();
    } else {
      widget.requisitionModel.documentNumber =
          getNewRequisitionDocumentNumber();
      _documentNumberController.text =
          widget.requisitionModel.documentNumber.toString();
    }
    _documentNumberController.text =
        widget.requisitionModel.documentNumber.toString();
    _documentDateController.text = widget.requisitionModel.documentDate != null
        ? widget.requisitionModel.documentDate.toString()
        : intl.DateFormat("yyyy-MM-dd").format(DateTime.now());
    widget.requisitionModel.documentDate = _documentDateController.text;
    // _customerController.text = (widget.requisitionModel.customerName != null
    //     ? widget.requisitionModel.customerName.toString()
    //     : '');
    // _projectController.text = (widget.requisitionModel.projectName != null
    //     ? widget.requisitionModel.projectName.toString()
    //     : '');
    _employeeController.text = (widget.requisitionModel.employeeName != null
        ? widget.requisitionModel.employeeName.toString()
        : '');
  }

  @override
  void dispose() {
    super.dispose();
    _documentNumberController.dispose();
    _documentDateController.dispose();
    // _customerController.dispose();
    // _projectController.dispose();
    _employeeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.key,
      child: Scrollbar(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: AutofillGroup(
            child: Column(
              children: [
                ...[
                  TextFormField(
                    enabled: false,
                    controller: _documentNumberController,
                    decoration: InputDecoration(
                      labelText: 'Document Number',
                      hintText: 'Document Number',
                      focusedBorder: defaultFocusedBorder,
                      enabledBorder: defaultBorder,
                      disabledBorder: defaultBorder,
                    ),
                  ),
                  TextFormField(
                    enabled: canUpdateData(),
                    showCursor: false,
                    controller: _documentDateController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    readOnly: true,
                    validator: (value) {
                      if (widget.requisitionModel.documentDate == null ||
                          widget.requisitionModel.documentDate!.isEmpty) {
                        _validateDocumentDate = 'Please select Document date.';
                        return _validateDocumentDate;
                      }
                      _validateDocumentDate = null;
                      return _validateDocumentDate;
                    },
                    onTap: () async {
                      if (canUpdateData()) {
                        var newDate = await showDatePicker(
                          context: context,
                          initialDate:
                              widget.requisitionModel.documentDate != null &&
                                      widget.requisitionModel.documentDate != ''
                                  ? DateTime.parse(widget
                                      .requisitionModel.documentDate
                                      .toString())
                                  : DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.utc(DateTime.now().year + 2),
                        );

                        // Don't change the date if the date picker returns null.
                        if (newDate == null) {
                          return;
                        }

                        _documentDateController
                          ..text = intl.DateFormat("yyyy-MM-dd").format(newDate)
                          ..selection = TextSelection.fromPosition(TextPosition(
                              offset: _documentDateController.text.length,
                              affinity: TextAffinity.upstream));
                        widget.requisitionModel.documentDate =
                            _documentDateController.text;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Document Date',
                      hintText: 'Document Date',
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.calendar_today_sharp),
                      ),
                      errorText: _validateDocumentDate,
                      focusedBorder: defaultFocusedBorder,
                      enabledBorder: defaultBorder,
                      errorBorder: errorBorder,
                      border: defaultBorder,
                      focusedErrorBorder: defaultFocusedBorder,
                    ),
                  ),
                  // FormField<String>(
                  //   autovalidateMode: AutovalidateMode.onUserInteraction,
                  //   validator: (value) {
                  //     if (widget.requisitionModel.customerName == null ||
                  //         widget.requisitionModel.customerName!.isEmpty) {
                  //       _validateCustomer = 'Please select Customer';
                  //     } else {
                  //       _validateCustomer = null;
                  //     }
                  //     return _validateCustomer;
                  //   },
                  //   builder: (FormFieldState<String> state) {
                  //     return InputDecorator(
                  //       decoration: InputDecoration(
                  //         labelText: 'Customer',
                  //         hintText: 'Customer',
                  //         errorText: _validateCustomer,
                  //         focusedBorder: defaultFocusedBorder,
                  //         enabledBorder: defaultBorder,
                  //         errorBorder: errorBorder,
                  //       ),
                  //       child: DropdownButtonHideUnderline(
                  //         child: DropdownButton<String>(
                  //           hint: Text('Customer'),
                  //           icon: Icon(Icons.keyboard_arrow_down_sharp),
                  //           value: widget.requisitionModel.customerName,
                  //           isDense: true,
                  //           onChanged: (String? newValue) {
                  //             setState(() {
                  //               widget.requisitionModel.customerName =
                  //                   newValue.toString();
                  //               widget.requisitionModel.customer =
                  //                   RequisitionModel.findCustomerByName(
                  //                       _customerList, newValue);
                  //               state.didChange(newValue);
                  //               getProjects(widget
                  //                   .requisitionModel.customer!.customerId);
                  //             });
                  //           },
                  //           items: _customerList.map((Customer value) {
                  //             return DropdownMenuItem<String>(
                  //               value: value.customerName,
                  //               child: Text(value.customerName),
                  //             );
                  //           }).toList(),
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // ),
                  // FormField<String>(
                  //   autovalidateMode: AutovalidateMode.onUserInteraction,
                  //   validator: (value) {
                  //     if (widget.requisitionModel.projectName == null ||
                  //         widget.requisitionModel.projectName!.isEmpty) {
                  //       _validateProject = 'Please select Project';
                  //     } else {
                  //       _validateProject = null;
                  //     }
                  //     return _validateProject;
                  //   },
                  //   builder: (FormFieldState<String> state) {
                  //     return InputDecorator(
                  //       decoration: InputDecoration(
                  //         labelText: 'Project',
                  //         hintText: 'Project',
                  //         errorText: _validateProject,
                  //         focusedBorder: defaultFocusedBorder,
                  //         enabledBorder: defaultBorder,
                  //         errorBorder: errorBorder,
                  //       ),
                  //       child: DropdownButtonHideUnderline(
                  //         child: DropdownButton<String>(
                  //           hint: Text('Project'),
                  //           icon: Icon(Icons.keyboard_arrow_down_sharp),
                  //           value: widget.requisitionModel.projectName,
                  //           isDense: true,
                  //           onChanged: (String? newValue) {
                  //             setState(() {
                  //               widget.requisitionModel.projectName =
                  //                   newValue.toString();
                  //               widget.requisitionModel.project =
                  //                   RequisitionModel.findProjectByName(
                  //                       _projectList, newValue);
                  //               state.didChange(newValue);
                  //             });
                  //           },
                  //           items: _projectList.map((Project value) {
                  //             return DropdownMenuItem<String>(
                  //               value: value.projectName,
                  //               child: Text(value.projectName),
                  //             );
                  //           }).toList(),
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // ),
                  DropdownSearch<String>(
                      mode: Mode.DIALOG,
                      enabled: canUpdateData(),
                      items: _employeeList.map((Employee? element) {
                        return element?.employeeName ?? '';
                      }).toList(),
                      showSelectedItems: true,
                      showSearchBox: true,
                      label: "Employee",
                      hint: "Employee",
                      dropDownButton: Center(
                          child: Icon(
                            Icons.keyboard_arrow_down_sharp,
                            color: Color.fromRGBO(139, 139, 139, 1.0),
                          )),
                      maxHeight: MediaQuery.of(context).size.height,
                      dialogMaxWidth: MediaQuery.of(context).size.width,
                      dropdownSearchDecoration: InputDecoration(
                        isDense: true,
                        labelText: widget.requisitionModel.employeeName != ''
                            ? 'Employee'
                            : '',
                        hintText: 'Employee',
                        enabledBorder: defaultBorder,
                        border: defaultBorder,
                        contentPadding:
                        EdgeInsets.only(left: 12.0, top: 8.0, bottom: 8.0),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          if (canUpdateData()) {
                            widget.requisitionModel.employeeName =
                                newValue.toString();
                            widget.requisitionModel.employee =
                                RequisitionModel.findEmployeeByName(
                                    _employeeList, newValue);
                          }
                        });
                      },
                      selectedItem: widget.requisitionModel.employeeName),
                  // FormField<String>(
                  //   enabled: canUpdateData(),
                  //   // autovalidateMode: AutovalidateMode.onUserInteraction,
                  //   // validator: (value) {
                  //   //   if (widget.requisitionModel.employeeName == null ||
                  //   //       widget.requisitionModel.employeeName!.isEmpty) {
                  //   //     _validateEmployee = 'Please select Employee';
                  //   //   } else {
                  //   //     _validateEmployee = null;
                  //   //   }
                  //   //   return _validateEmployee;
                  //   // },
                  //   builder: (FormFieldState<String> state) {
                  //     return InputDecorator(
                  //       decoration: InputDecoration(
                  //         labelText: 'Employee',
                  //         hintText: 'Employee',
                  //         errorText: _validateEmployee,
                  //         focusedBorder: defaultFocusedBorder,
                  //         enabledBorder: defaultBorder,
                  //         errorBorder: errorBorder,
                  //       ),
                  //       child: DropdownButtonHideUnderline(
                  //         child: DropdownButton<String>(
                  //           hint: Text('Employee'),
                  //           icon: Icon(Icons.keyboard_arrow_down_sharp),
                  //           value: _employeeList.isEmpty
                  //               ? null
                  //               : widget.requisitionModel.employeeName,
                  //           isDense: true,
                  //           onChanged: (String? newValue) {
                  //             setState(() {
                  //               if (canUpdateData()) {
                  //                 widget.requisitionModel.employeeName =
                  //                     newValue.toString();
                  //                 widget.requisitionModel.employee =
                  //                     RequisitionModel.findEmployeeByName(
                  //                         _employeeList, newValue);
                  //                 state.didChange(newValue);
                  //               }
                  //             });
                  //           },
                  //           items: _employeeList.map((Employee value) {
                  //             return DropdownMenuItem<String>(
                  //               value: value.employeeName,
                  //               child: Text(value.employeeName.toString()),
                  //             );
                  //           }).toList(),
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // ),
                  DropdownSearch<String>(
                      mode: Mode.DIALOG,
                      enabled: canUpdateData(),
                      items: _remarkList.map((Remark? element) {
                        return element?.remarkName ?? '';
                      }).toList(),
                      showSelectedItems: true,
                      showSearchBox: true,
                      label: "Remark",
                      hint: "Remark",
                      dropDownButton: Center(
                          child: Icon(
                            Icons.keyboard_arrow_down_sharp,
                            color: Color.fromRGBO(139, 139, 139, 1.0),
                          )),
                      maxHeight: MediaQuery.of(context).size.height,
                      dialogMaxWidth: MediaQuery.of(context).size.width,
                      dropdownSearchDecoration: InputDecoration(
                        isDense: true,
                        labelText: widget.requisitionModel.remark != ''
                            ? 'Remark'
                            : '',
                        hintText: 'Remark',
                        enabledBorder: defaultBorder,
                        border: defaultBorder,
                        contentPadding:
                        EdgeInsets.only(left: 12.0, top: 8.0, bottom: 8.0),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          if (canUpdateData()) {
                            widget.requisitionModel.remark =
                                RequisitionModel.findRemarkByName(
                                    _remarkList, newValue);
                            widget.requisitionModel.remarkName =
                                widget.requisitionModel.remark!.remarkName;
                          }
                        });
                      },
                      selectedItem: widget.requisitionModel.remark?.remarkName),
                  // FormField<String>(
                  //   enabled: canUpdateData(),
                  //   // autovalidateMode: AutovalidateMode.onUserInteraction,
                  //   // validator: (value) {
                  //   //   if (widget.requisitionModel.remarkId == null ||
                  //   //       widget.requisitionModel.remarkId!.isEmpty) {
                  //   //     _validateRemark = 'Please select Remark';
                  //   //   } else {
                  //   //     _validateRemark = null;
                  //   //   }
                  //   //   return _validateRemark;
                  //   // },
                  //   builder: (FormFieldState<String> state) {
                  //     return InputDecorator(
                  //       decoration: InputDecoration(
                  //         labelText: 'Remark',
                  //         hintText: 'Remark',
                  //         errorText: _validateRemark,
                  //         focusedBorder: defaultFocusedBorder,
                  //         enabledBorder: defaultBorder,
                  //         errorBorder: errorBorder,
                  //       ),
                  //       child: DropdownButtonHideUnderline(
                  //         child: DropdownButton<String>(
                  //           hint: Text('Remark'),
                  //           icon: Icon(Icons.keyboard_arrow_down_sharp),
                  //           value: widget.requisitionModel.remarkId != null &&
                  //                   widget.requisitionModel.remarkId!
                  //                       .isNotEmpty &&
                  //                   _remarkList.isNotEmpty
                  //               ? RequisitionModel.findRemarkById(_remarkList,
                  //                       widget.requisitionModel.remarkId)!
                  //                   .remarkName
                  //               : null,
                  //           isDense: true,
                  //           onChanged: (String? newValue) {
                  //             setState(() {
                  //               if (canUpdateData()) {
                  //                 widget.requisitionModel.remark =
                  //                     RequisitionModel.findRemarkByName(
                  //                         _remarkList, newValue);
                  //                 widget.requisitionModel.remarkId =
                  //                     widget.requisitionModel.remark!.remarkId;
                  //                 state.didChange(newValue);
                  //               }
                  //             });
                  //           },
                  //           items: _remarkList.map((Remark value) {
                  //             return DropdownMenuItem<String>(
                  //               value: value.remarkName,
                  //               child: Text(value.remarkName.toString()),
                  //             );
                  //           }).toList(),
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // ),
                  // TextFormField(
                  //   initialValue: widget.requisitionModel.remark,
                  //   onChanged: (value) {
                  //     widget.requisitionModel.remark = value;
                  //   },
                  //   decoration: InputDecoration(
                  //     labelText: 'Remark',
                  //     hintText: 'Remark',
                  //     focusedBorder: defaultFocusedBorder,
                  //     enabledBorder: defaultBorder,
                  //   ),
                  // ),
                ].expand(
                  (widget) => [
                    widget,
                    const SizedBox(
                      height: 24,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
