import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_management/data/delivery_product_data_source.dart';
import 'package:stock_management/models/model_delivery.dart';
import 'package:stock_management/views/stock/widgets/cart.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/delivery_controller.dart';

class DeliveryItems extends StatelessWidget {
  DeliveryItems({super.key, required this.delivery});
  final Delivery delivery;
  final controller = Get.find<DeliveryController>();
  final productDataSource = DeliveryProductDataSource();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
        //    drawer: const SideBar(),
        appBar: AppBar(
          title: const Text(
            'Stock Delivery - Items',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Row(
          children: [
            Expanded(
                flex: 1,
                child: CartWidget(
                  delivery: delivery,
                )),
            Expanded(
                flex: 2,
                child: Column(
                  children: [
                    SizedBox(
                        height: 45, width: size.width, child: categoryMenu()),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                          height: size.height - 120, child: productTable()),
                    ),
                  ],
                ))
          ],
        ));
  }

  Widget productTable() {
    return Obx(() {
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
                      'ID',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                GridColumn(
                  columnName: 'name',
                  columnWidthMode: ColumnWidthMode.auto,
                  label: Container(
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.centerLeft,
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
                  visible: false,
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
                  columnName: 'category',
                  columnWidthMode: ColumnWidthMode.auto,
                  label: Container(
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Category',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            );
    });
  }

  Widget categoryMenu() {
    return ListView(
      //padding: const EdgeInsets.all(6),
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      children: controller.categoryList.map((c) {
        return Container(
          margin: const EdgeInsets.all(4),
          child: Obx(() {
            return Card(
              color: controller.selectedCategory.value?.id == c.id
                  ? Colors.red
                  : null,
              child: TextButton(
                // style: OutlinedButton.styleFrom(
                //   backgroundColor: Colors.red, // Background color
                //   disabledBackgroundColor: Colors.white, // Text color
                // ),
                child: Text(
                  c.description,
                  style: TextStyle(
                    color: controller.selectedCategory.value?.id == c.id
                        ? Colors.white
                        : Colors.red,
                  ),
                ),
                onPressed: () {
                  if (controller.selectedCategory.value?.id == c.id) {
                    controller.selectedCategory.value = null;
                  } else {
                    controller.selectedCategory.value = c;
                  }

                  controller.loadProducts();
                },
              ),
            );
          }),
        );
      }).toList(),
    );
  }
}
