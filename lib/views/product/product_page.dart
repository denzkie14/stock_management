import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:stock_management/controllers/product_controller.dart';
import 'package:stock_management/widgets/sidebar.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../data/product_data_source.dart';
import '../../models/model_product.dart';
import 'widgets/product_form_widget.dart';

class ProductPage extends StatelessWidget {
  ProductPage({super.key});
  final controller = Get.put(ProductController());

  void _showProductForm(context, {Product? product}) {
    showDialog(
      context: context,
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
  }

  @override
  Widget build(BuildContext context) {
    final ProductDataSource productDataSource =
        ProductDataSource(controller.productList);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      drawer: const SideBar(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Product',
        backgroundColor: Colors.red,
        child: const Icon(color: Colors.white, Icons.add),
        onPressed: () => _showProductForm(context),
      ),
      body: SfDataGrid(
        source: productDataSource,
        columns: <GridColumn>[
          GridColumn(
            columnName: 'id',
            label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text(
                'ID',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // GridColumn(
          //   columnName: 'code',
          //   label: Container(
          //     padding: const EdgeInsets.all(8.0),
          //     alignment: Alignment.center,
          //     child: const Text(
          //       'Code',
          //       style: TextStyle(fontWeight: FontWeight.bold),
          //     ),
          //   ),
          // ),
          GridColumn(
            columnName: 'name',
            label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text(
                'Name',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          GridColumn(
            columnName: 'unit',
            label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text(
                'Unit',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          GridColumn(
            columnName: 'categoryId',
            label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text(
                'Category ID',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          GridColumn(
            columnName: 'actions',
            label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text(
                'Actions',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}
