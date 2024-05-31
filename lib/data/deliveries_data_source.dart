// Product Data Source for Syncfusion DataGrid
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stock_management/controllers/delivery_controller.dart';
import 'package:stock_management/views/stock/delivery_items.dart';
import 'package:stock_management/views/stock/widgets/delivery_form_widget.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../main.dart';
import '../models/model_delivery.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/confirm_dialog.dart';

class DeliveryDataSource extends DataGridSource {
  final DeliveryController controller = Get.find<DeliveryController>();

  DeliveryDataSource() {
    controller.deliveryList.listen((items) {
      updateDataSource(items);
    });
    _updateRows(controller.deliveryList);
  }

  List<DataGridRow> _items = [];
  void _updateRows(List<Delivery> items) {
    _items = items.map<DataGridRow>((item) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'id', value: item.id),
        DataGridCell<String>(columnName: 'supplier', value: item.supplier),
        DataGridCell<String>(
            columnName: 'delivery_number', value: item.deliveryNumber),
        DataGridCell<String>(
            columnName: 'delivery_date',
            value: DateFormat('yyyy-MM-dd').format(item.deliveryDate)),
        //  DataGridCell<String>(columnName: 'action', value: ""),
      ]);
    }).toList();
  }

  void updateDataSource(List<Delivery> item) {
    _updateRows(item);
    notifyListeners();
  }

  @override
  List<DataGridRow> get rows => _items;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final Delivery item = controller.deliveryList
        .firstWhere((s) => s.id == row.getCells()[0].value);
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
        child: Text(row.getCells()[2].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[3].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              tooltip: 'Update',
              onPressed: () {
                update(item);
              },
              icon: const Icon(Icons.edit),
              color: Colors.green,
            ),
            IconButton(
              tooltip: 'Delete',
              onPressed: () async {
                delete(item);
              },
              icon: const Icon(Icons.delete),
              color: Colors.red,
            ),
            IconButton(
              tooltip: 'Items',
              onPressed: () async {
                Navigator.push(
                    navigatorKey.currentContext!,
                    MaterialPageRoute(
                        builder: (context) => DeliveryItems(delivery: item)));
              },
              icon: const Icon(Icons.add_box),
              color: Colors.blue,
            ),
          ],
        ),
      ),
    ]);
  }

  void update(Delivery item) async {
    showDialog(
        context: navigatorKey.currentContext!,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: DeliveryForm(
              data: item,
            ),
          );
        });
  }

  void delete(Delivery item) async {
    var action = await showConfirmDialog(
        navigatorKey.currentContext!,
        'Delete Delivery',
        'Are you sure you want to delete Transaction #: ${item.id}?');
    if (action) {
      await controller.deleteRecord(item.id);
      showAlertDialog(
          navigatorKey.currentContext!,
          controller.hasError ? 'Error!' : 'Success!',
          controller.resultMessage);
    }
  }
}
