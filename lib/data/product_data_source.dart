// Product Data Source for Syncfusion DataGrid
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_management/controllers/product_controller.dart';
import 'package:stock_management/views/product/widgets/product_form_widget.dart';
import 'package:stock_management/widgets/alert_dialog.dart';
import 'package:stock_management/widgets/confirm_dialog.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../main.dart';
import '../models/model_product.dart';

class ProductDataSource extends DataGridSource {
  final ProductController controller = Get.find<ProductController>();

  ProductDataSource() {
    controller.productList.listen((products) {
      updateDataSource(products);
    });
    _updateProductRows(controller.productList);
  }

  List<DataGridRow> _products = [];

  void _updateProductRows(List<Product> products) {
    _products = products.map<DataGridRow>((product) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'id', value: product.id),
        DataGridCell<String>(columnName: 'name', value: product.name),
        DataGridCell<String>(columnName: 'unit', value: product.unit),
        DataGridCell<int>(columnName: 'categoryId', value: product.categoryId),
        DataGridCell<String>(columnName: 'category', value: product.category),
      ]);
    }).toList();
  }

  void updateDataSource(List<Product> products) {
    _updateProductRows(products);
    notifyListeners();
  }

  @override
  List<DataGridRow> get rows => _products;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final Product product = dataGridRowToProduct(row);
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
                update(product);
              },
              icon: const Icon(Icons.edit),
              color: Colors.green,
            ),
            IconButton(
              tooltip: 'Delete',
              onPressed: () async {
                delete(product);
              },
              icon: const Icon(Icons.delete),
              color: Colors.red,
            ),
          ],
        ),
      ),
    ]);
  }

  void update(Product product) async {
    showDialog(
        context: navigatorKey.currentContext!,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ProductForm(
              product: product,
            ),
          );
        });
  }

  void delete(Product product) async {
    var action = await showConfirmDialog(
        navigatorKey.currentContext!,
        'Delete Product',
        'Are you sure you want to delete ${product.name} with product code: ${product.id}?');
    if (action) {
      await controller.deleteProduct(product.id);
      showAlertDialog(
          navigatorKey.currentContext!,
          controller.hasError ? 'Error!' : 'Success!',
          controller.resultMessage);
    }
  }

  Product dataGridRowToProduct(DataGridRow row) {
    return Product(
      id: row.getCells()[0].value,
      name: row.getCells()[1].value,
      unit: row.getCells()[2].value,
      categoryId: row.getCells()[3].value,
      category: row.getCells()[4].value,
    );
  }
}
