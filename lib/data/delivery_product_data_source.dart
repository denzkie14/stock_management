// Product Data Source for Syncfusion DataGrid
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_management/controllers/delivery_controller.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../main.dart';
import '../models/model_product.dart';
import '../views/stock/widgets/item_form_widget.dart';

class DeliveryProductDataSource extends DataGridSource {
  final DeliveryController controller = Get.find<DeliveryController>();

  DeliveryProductDataSource() {
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
    final Product product = controller.productList
        .firstWhere((s) => s.id == row.getCells()[0].value);
    return DataGridRowAdapter(cells: [
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[0].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[1].value.toString()),
      ),
      Container(
        alignment: Alignment.centerLeft,
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
    ]);
  }

  void _onRowTap(Product item) {
    showDialog(
        context: navigatorKey.currentContext!,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ItemForm(
              data: item,
            ),
          );
        });
  }
}
