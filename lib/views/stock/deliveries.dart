import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_management/controllers/product_controller.dart';
import 'package:stock_management/widgets/sidebar.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../data/product_data_source.dart';
import '../../models/model_product.dart';
import '../product/widgets/product_form_widget.dart';

class DeliveryPage extends StatelessWidget {
  DeliveryPage({super.key});
  final controller = Get.put(ProductController());
  final ProductDataSource productDataSource = ProductDataSource();
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
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Stock Deliveries',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () => controller.loadProducts(),
              icon: const Icon(Icons.refresh)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.search))
        ],
      ),
      drawer: const SideBar(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'New Delivery',
        backgroundColor: Colors.red,
        child: const Icon(color: Colors.white, Icons.add),
        onPressed: () => _showProductForm(context),
      ),
      body: Obx(() {
        return controller.isListLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SfDataGrid(
                source: productDataSource,
                columns: <GridColumn>[
                  GridColumn(
                    columnName: 'id',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Transaction #',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Supplier',
                    columnWidthMode: ColumnWidthMode.auto,
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'suppler',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Total Amount',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text(
                        'amount',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  GridColumn(
                    visible: false,
                    columnName: 'deliveryDate',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text(
                        'Delivery Date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  // GridColumn(
                  //   columnName: 'category',
                  //   columnWidthMode: ColumnWidthMode.auto,
                  //   label: Container(
                  //     padding: const EdgeInsets.all(8.0),
                  //     alignment: Alignment.centerLeft,
                  //     child: const Text(
                  //       'Category',
                  //       style: TextStyle(fontWeight: FontWeight.bold),
                  //     ),
                  //   ),
                  // ),
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
              );
      }),
    );
  }
}
