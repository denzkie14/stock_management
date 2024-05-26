// Product Data Source for Syncfusion DataGrid
import 'package:flutter/material.dart';
import 'package:stock_management/views/product/widgets/product_form_widget.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../main.dart';
import '../models/model_product.dart';
import '../widgets/confirm_dialog.dart';

class ProductDataSource extends DataGridSource {
  ProductDataSource(List<Product> products) {
    _products = products
        .map<DataGridRow>((product) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'id', value: product.id),
              // DataGridCell<String>(columnName: 'code', value: product.code),
              DataGridCell<String>(columnName: 'name', value: product.name),
              DataGridCell<String>(columnName: 'unit', value: product.unit),
              DataGridCell<int>(
                  columnName: 'categoryId', value: product.categoryId),
            ]))
        .toList();
  }

  List<DataGridRow> _products = [];

  @override
  List<DataGridRow> get rows => _products;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final Product product = dataGridRowToProduct(row);
    return DataGridRowAdapter(cells: [
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[0].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
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
      // Container(
      //   alignment: Alignment.center,
      //   padding: const EdgeInsets.all(8.0),
      //   child: Text(row.getCells()[4].value.toString()),
      // ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            IconButton(
              tooltip: 'Update',
              onPressed: () {
                showDialog(
                  context: navigatorKey.currentContext!,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ProductForm(
                        product: product,
                        onSave: (Product newProduct) {
                          if (product == null) {
                            //   products.add(newProduct);
                          } else {
                            //  final index = products.indexOf(product);
                            //  products[index] = newProduct;
                          }
                          //  productDataSource = ProductDataSource(products);

                          Navigator.of(context).pop();
                        },
                      ),
                    );
                  },
                );
              },
              icon: const Icon(Icons.edit),
              color: Colors.green,
            ),
            IconButton(
                tooltip: 'Delete',
                onPressed: () async {
                  final action = await showConfirmDialog(
                      navigatorKey.currentContext!,
                      'Delete',
                      'Are you sure you want to delete the ${product.name}');
                },
                icon: const Icon(Icons.delete),
                color: Colors.red)
          ],
        ),
      ),
    ]);
  }
}

// Convert DataGridRow to Product
Product dataGridRowToProduct(DataGridRow row) {
  return Product(
    id: row.getCells()[0].value,
    //code: row.getCells()[1].value,
    name: row.getCells()[1].value,
    unit: row.getCells()[2].value,
    categoryId: row.getCells()[3].value,
  );
}

// Generate Sample Products
List<Product> generateProducts(int count) {
  return List.generate(count, (index) {
    return Product(
      id: '${index + 1}',
      // code: 'P${(index + 1).toString().padLeft(3, '0')}',
      name: 'Product ${index + 1}',
      unit: 'pcs',
      categoryId:
          100 + (index % 5) + 1, // Distributing categoryIds among 5 categories
    );
  });
}
