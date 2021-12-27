import 'package:checkstockpro/item/item_model.dart';
import 'package:checkstockpro/services/customer.dart';
import 'package:checkstockpro/services/employee.dart';
import 'package:checkstockpro/services/project.dart';
import 'package:checkstockpro/services/remark.dart';

class RequisitionModel {
  String? rqId;
  String? documentNumber;
  String? documentDate;
  String? customerName;
  Customer? customer;
  String? projectName;
  Project? project;
  String? employeeName;
  Employee? employee;
  String? remarkName;
  Remark? remark;
  String? status;
  String? cnt;
  String? rejectCommect;
  String? approve;
  List<ItemModel> itemModel = <ItemModel>[];

  static RequisitionModel clone(RequisitionModel requisitionModel) {
    return RequisitionModel()
      ..rqId = requisitionModel.rqId
      ..documentNumber = requisitionModel.documentNumber
      ..documentDate = requisitionModel.documentDate
      ..itemModel = requisitionModel.itemModel
      ..customerName = requisitionModel.customerName
      ..projectName = requisitionModel.projectName
      ..employeeName = requisitionModel.employeeName
      ..remark = requisitionModel.remark
      ..remarkName = requisitionModel.remarkName
      ..status = requisitionModel.status
      ..cnt = requisitionModel.cnt
      ..rejectCommect = requisitionModel.rejectCommect
      ..approve = requisitionModel.approve;
  }

  static findCustomerByName(List<Customer> list, String? name) {
    if (name == null) return null;
    Customer? customer;
    list.forEach((element) {
      if (element.customerName == name) {
        customer = element;
      }
    });
    return customer;
  }

  static findProjectByName(List<Project> list, String? name) {
    if (name == null) return null;
    Project? project;
    list.forEach((element) {
      if (element.projectName == name) {
        project = element;
      }
    });
    return project;
  }

  static findEmployeeByName(List<Employee> list, String? name) {
    if (name == null) return null;
    Employee? employee;
    list.forEach((element) {
      if (element.employeeName == name) {
        employee = element;
      }
    });
    return employee;
  }

  static Remark? findRemarkByName(List<Remark> list, String? name) {
    if (name == null) return null;
    Remark? remark;
    list.forEach((element) {
      if (element.remarkName == name) {
        remark = element;
      }
    });
    return remark;
  }

  static Remark? findRemarkById(List<Remark> list, String? id) {
    if (id == null) return null;
    Remark? remark;
    list.forEach((element) {
      if (element.remarkId == id) {
        remark = element;
      }
    });
    return remark;
  }
}
