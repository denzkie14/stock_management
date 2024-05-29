// Product Data Source for Syncfusion DataGrid
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_management/controllers/delivery_controller.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../models/model_delivery.dart';

class DeliveryDataSource extends DataGridSource {
  final DeliveryController controller = Get.find<DeliveryController>();

  ProductDataSource() {
    controller.deliveryList.listen((items) {
      updateDataSource(items);
    });
    _updateProductRows(controller.deliveryList);
  }

  List<DataGridRow> _items = [];
  void _updateProductRows(List<Delivery> items) {
    _items = items.map<DataGridRow>((item) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'id', value: item.id),
        DataGridCell<String>(
            columnName: 'delivery_number', value: item.deliveryNumber),
        DataGridCell<String>(columnName: 'supplier', value: item.supplier),
        DataGridCell<DateTime>(
            columnName: 'delivery_date', value: item.deliveryDate),
        // DataGridCell<String>(columnName: 'category', value: item.category),
      ]);
    }).toList();
  }

  void updateDataSource(List<Delivery> item) {
    _updateProductRows(item);
    notifyListeners();
  }

  @override
  List<DataGridRow> get rows => _items;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    //   final Product product = dataGridRowToProduct(row);
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
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[4].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            IconButton(
              tooltip: 'Update',
              onPressed: () {
                //  update(product);
              },
              icon: const Icon(Icons.edit),
              color: Colors.green,
            ),
            IconButton(
              tooltip: 'Delete',
              onPressed: () async {
                // delete(product);
              },
              icon: const Icon(Icons.delete),
              color: Colors.red,
            ),
          ],
        ),
      ),
    ]);
  }

  // void update(Product product) async {
  //   showDialog(
  //       context: navigatorKey.currentContext!,
  //       builder: (BuildContext context) {
  //         return Dialog(
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(10),
  //           ),
  //           child: ProductForm(
  //             product: product,
  //           ),
  //         );
  //       });
  // }

  // void delete(Product product) async {
  //   var action = await showConfirmDialog(
  //       navigatorKey.currentContext!,
  //       'Delete Product',
  //       'Are you sure you want to delete ${product.name} with product code: ${product.id}?');
  //   if (action) {
  //     await controller.deleteProduct(product.id);
  //     showAlertDialog(
  //         navigatorKey.currentContext!,
  //         controller.hasError ? 'Error!' : 'Success!',
  //         controller.resultMessage);
  //   }
  // }
}
