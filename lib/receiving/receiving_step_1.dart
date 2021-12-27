import 'package:checkstockpro/component/input_text_field.dart';
import 'package:checkstockpro/receiving/model/receiving_model.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' as intl;

class ReceivingStep1 extends StatefulWidget {
  final ReceivingModel receivingModel;
  final List<Supplier> supplierList;

  const ReceivingStep1(
      {Key? key, required this.receivingModel, required this.supplierList})
      : super(key: key);

  @override
  _ReceivingStep1 createState() => _ReceivingStep1();
}

class _ReceivingStep1 extends State<ReceivingStep1> {
  TextEditingController _documentNumberController = TextEditingController();
  TextEditingController _documentDateController = TextEditingController();
  String? _validateSupplier;
  String? _validateDocumentDate;

  String getNewReceivingDocumentNumber() {
    return "GR" +
        DateTime.now().year.toString() +
        "-" +
        DateTime.now().millisecondsSinceEpoch.toString().substring(0, 10);
  }

  @override
  void initState() {
    super.initState();
    if (widget.receivingModel.documentNumber != null) {
      _documentNumberController.text =
          widget.receivingModel.documentNumber.toString();
    } else {
      widget.receivingModel.documentNumber = getNewReceivingDocumentNumber();
      _documentNumberController.text =
          widget.receivingModel.documentNumber.toString();
    }
    _documentDateController.text = widget.receivingModel.documentDate != null
        ? widget.receivingModel.documentDate.toString()
        : intl.DateFormat("yyyy-MM-dd").format(DateTime.now());
    widget.receivingModel.documentDate = _documentDateController.text;
  }

  @override
  void dispose() {
    super.dispose();
    _documentNumberController.dispose();
    _documentDateController.dispose();
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Document number.';
                      }
                      return null;
                    },
                    controller: _documentNumberController,
                    decoration: InputDecoration(
                        labelText: 'Document Number',
                        hintText: 'Document Number',
                        focusedBorder: defaultFocusedBorder,
                        enabledBorder: defaultBorder,
                        errorBorder: errorBorder,
                        disabledBorder: defaultBorder),
                  ),
                  TextFormField(
                    enabled: canUpdateData(),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    showCursor: false,
                    readOnly: true,
                    validator: (value) {
                      if (widget.receivingModel.documentDate == null ||
                          widget.receivingModel.documentDate!.isEmpty) {
                        _validateDocumentDate = 'Please select Document date.';
                        return _validateDocumentDate;
                      }
                      _validateDocumentDate = null;
                      return _validateDocumentDate;
                    },
                    controller: _documentDateController,
                    onTap: () {
                      if (canUpdateData()) {
                        onClickDocumentDate(context);
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Document Date',
                      hintText: 'Document Date',
                      errorText: _validateDocumentDate,
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.calendar_today_sharp),
                      ),
                      focusedBorder: defaultFocusedBorder,
                      enabledBorder: defaultBorder,
                      errorBorder: errorBorder,
                      border: defaultBorder,
                      focusedErrorBorder: defaultFocusedBorder,
                    ),
                  ),
                  DropdownSearch<String>(
                      mode: Mode.DIALOG,
                      enabled: canUpdateData(),
                      items: widget.supplierList.map((Supplier element) {
                        return element.supplierName;
                      }).toList(),
                      showSelectedItems: true,
                      showSearchBox: true,
                      label: "Supplier",
                      hint: "Supplier",
                      dropDownButton: Center(
                          child: Icon(
                        Icons.keyboard_arrow_down_sharp,
                        color: Color.fromRGBO(139, 139, 139, 1.0),
                      )),
                      maxHeight: MediaQuery.of(context).size.height,
                      dialogMaxWidth: MediaQuery.of(context).size.width,
                      dropdownSearchDecoration: InputDecoration(
                        isDense: true,
                        labelText: widget.receivingModel.supplierName != ''
                            ? 'Supplier'
                            : '',
                        hintText: 'Supplier',
                        enabledBorder: defaultBorder,
                        border: defaultBorder,
                        contentPadding:
                            EdgeInsets.only(left: 12.0, top: 8.0, bottom: 8.0),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          if (canUpdateData()) {
                            widget.receivingModel.supplierName =
                                newValue.toString();
                            widget.receivingModel.supplier =
                                Supplier.findSupplierByName(
                                    widget.supplierList, newValue);
                          }
                        });
                      },
                      selectedItem: widget.receivingModel.supplierName),

                  // FormField<String>(
                  //   enabled: canUpdateData(),
                  //   autovalidateMode: AutovalidateMode.onUserInteraction,
                  //   validator: (value) {
                  //     // if (widget.receivingModel.supplierName == null ||
                  //     //     widget.receivingModel.supplierName!.isEmpty) {
                  //     //   _validateSupplier = 'Please select Supplier';
                  //     //   return _validateSupplier;
                  //     // }
                  //     _validateSupplier = null;
                  //     return _validateSupplier;
                  //   },
                  //   builder: (FormFieldState<String> state) {
                  //     return InputDecorator(
                  //       decoration: InputDecoration(
                  //         labelText: widget.receivingModel.supplierName != ''
                  //             ? 'Supplier'
                  //             : '',
                  //         errorText: _validateSupplier,
                  //         hintText: 'Supplier',
                  //         focusedBorder: defaultFocusedBorder,
                  //         enabledBorder: defaultBorder,
                  //         errorBorder: errorBorder,
                  //         border: defaultBorder,
                  //         focusedErrorBorder: defaultFocusedBorder,
                  //       ),
                  //       child: DropdownButtonHideUnderline(
                  //         child: DropdownButton<String>(
                  //           hint: Text('Supplier'),
                  //           icon: Icon(Icons.keyboard_arrow_down_sharp),
                  //           value: widget.receivingModel.supplierName,
                  //           isDense: true,
                  //           onChanged: (String? newValue) {
                  //             setState(() {
                  //               if (canUpdateData()) {
                  //                 widget.receivingModel.supplierName =
                  //                     newValue.toString();
                  //                 widget.receivingModel.supplier =
                  //                     Supplier.findSupplierByName(
                  //                         widget.supplierList, newValue);
                  //                 state.didChange(newValue);
                  //               }
                  //             });
                  //           },
                  //           items: widget.supplierList.map((Supplier element) {
                  //             return DropdownMenuItem<String>(
                  //               value: element.supplierName,
                  //               child: Text(
                  //                 element.supplierName,
                  //                 overflow: TextOverflow.clip,
                  //               ),
                  //             );
                  //           }).toList(),
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // ),
                  TextFormField(
                    enabled: canUpdateData(),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    initialValue: widget.receivingModel.referencePONo,
                    onChanged: (value) {
                      widget.receivingModel.referencePONo = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Reference PO No.',
                      hintText: 'Reference PO No.',
                      focusedBorder: defaultFocusedBorder,
                      enabledBorder: defaultBorder,
                      errorBorder: errorBorder,
                      border: defaultBorder,
                      focusedErrorBorder: defaultFocusedBorder,
                    ),
                    validator: (value) {
                      // if (value == null || value.isEmpty) {
                      //   return 'Please enter Reference PO No.';
                      // }
                      return null;
                    },
                  ),
                  TextFormField(
                    enabled: canUpdateData(),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    initialValue: widget.receivingModel.referenceDONo,
                    onChanged: (value) {
                      widget.receivingModel.referenceDONo = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Reference DO No.',
                      hintText: 'Reference DO No.',
                      focusedBorder: defaultFocusedBorder,
                      enabledBorder: defaultBorder,
                      errorBorder: errorBorder,
                      border: defaultBorder,
                      focusedErrorBorder: defaultFocusedBorder,
                    ),
                    validator: (value) {
                      // if (value == null || value.isEmpty) {
                      //   return 'Please enter Reference DO No.';
                      // }
                      return null;
                    },
                  ),
                  TextFormField(
                    enabled: canUpdateData(),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    initialValue: widget.receivingModel.referenceInvoiceNo,
                    onChanged: (value) {
                      widget.receivingModel.referenceInvoiceNo = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Reference Invoice No.',
                      hintText: 'Reference Invoice No.',
                      focusedBorder: defaultFocusedBorder,
                      enabledBorder: defaultBorder,
                      errorBorder: errorBorder,
                      border: defaultBorder,
                      focusedErrorBorder: defaultFocusedBorder,
                    ),
                    validator: (value) {
                      // if (value == null || value.isEmpty) {
                      //   return 'Please enter Reference Invoice No.';
                      // }
                      return null;
                    },
                  ),
                  TextFormField(
                    enabled: canUpdateData(),
                    initialValue: widget.receivingModel.remark,
                    onChanged: (value) {
                      widget.receivingModel.remark = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Remark',
                      hintText: 'Remark',
                      focusedBorder: defaultFocusedBorder,
                      enabledBorder: defaultBorder,
                      errorBorder: errorBorder,
                      border: defaultBorder,
                    ),
                  ),
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

  bool canUpdateData() {
    return widget.receivingModel.status == "D" ||
        widget.receivingModel.status == "W" ||
        widget.receivingModel.status == "" ||
        widget.receivingModel.status == null;
  }

  void onClickDocumentDate(BuildContext context) async {
    var newDate = await showDatePicker(
      context: context,
      initialDate: widget.receivingModel.documentDate != null &&
              widget.receivingModel.documentDate != ''
          ? DateTime.parse(widget.receivingModel.documentDate.toString())
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
    widget.receivingModel.documentDate = _documentDateController.text;
  }
}
