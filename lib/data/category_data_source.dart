// Product Data Source for Syncfusion DataGrid
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_management/views/category/widgets/category_form_widget.dart';
import 'package:stock_management/widgets/alert_dialog.dart';
import 'package:stock_management/widgets/confirm_dialog.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../controllers/category_controller.dart';
import '../main.dart';
import '../models/model_category.dart';

class CategoryDataSource extends DataGridSource {
  final CategoryController controller = Get.find<CategoryController>();

  CategoryDataSource() {
    controller.list.listen((items) {
      updateDataSource(items);
    });
    _updateProductRows(controller.list);
  }

  List<DataGridRow> _items = [];

  void _updateProductRows(List<Category> items) {
    _items = items.map<DataGridRow>((item) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: item.id),
        DataGridCell<String>(columnName: 'name', value: item.description),
      ]);
    }).toList();
  }

  void updateDataSource(List<Category> items) {
    _updateProductRows(items);
    notifyListeners();
  }

  @override
  List<DataGridRow> get rows => _items;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final Category record =
        controller.list.firstWhere((e) => e.id == row.getCells()[0].value);
    return DataGridRowAdapter(cells: [
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[0].value.toString()),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[1].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            IconButton(
              tooltip: 'Update',
              onPressed: () {
                update(record);
              },
              icon: const Icon(Icons.edit),
              color: Colors.green,
            ),
            IconButton(
              tooltip: 'Delete',
              onPressed: () async {
                delete(record);
              },
              icon: const Icon(Icons.delete),
              color: Colors.red,
            ),
          ],
        ),
      ),
    ]);
  }

  void update(Category item) async {
    showDialog(
        context: navigatorKey.currentContext!,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: CategoryForm(
              data: item,
            ),
          );
        });
  }

  void delete(Category item) async {
    var action = await showConfirmDialog(
        navigatorKey.currentContext!,
        'Delete Record',
        'Are you sure you want to delete ${item.description} with Record ID: ${item.id}?');
    if (action) {
      await controller.deleteRecord(item.id);
      showAlertDialog(
          navigatorKey.currentContext!,
          controller.hasError ? 'Error!' : 'Success!',
          controller.resultMessage);
    }
  }
}
