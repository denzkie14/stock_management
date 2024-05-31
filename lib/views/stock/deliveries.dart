import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_management/controllers/delivery_controller.dart';
import 'package:stock_management/data/deliveries_data_source.dart';
import 'package:stock_management/models/model_delivery.dart';
import 'package:stock_management/widgets/sidebar.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'widgets/delivery_form_widget.dart';

class DeliveryPage extends StatelessWidget {
  DeliveryPage({super.key});
  final controller = Get.put(DeliveryController());
  final DeliveryDataSource dataSource = DeliveryDataSource();

  void _showForm(context, {Delivery? data}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: DeliveryForm(
            data: data,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    controller.loadRecord();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Stock Deliveries',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () => controller.loadRecord(),
              icon: const Icon(Icons.refresh)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.search))
        ],
      ),
      drawer: const SideBar(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'New Delivery',
        backgroundColor: Colors.red,
        child: const Icon(color: Colors.white, Icons.add),
        onPressed: () => _showForm(context),
      ),
      body: Obx(() {
        return controller.isListLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SfDataGrid(
                source: dataSource,
                columns: <GridColumn>[
                  GridColumn(
                    columnName: 'id',
                    //    columnWidthMode: ColumnWidthMode.auto,
                    width: 220,
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
                    columnName: 'supplier',
                    columnWidthMode: ColumnWidthMode.auto,
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Supplier',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  GridColumn(
                    columnName: 'delivery_number',
                    columnWidthMode: ColumnWidthMode.auto,
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Delivery Number',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  GridColumn(
                    // visible: false,
                    columnWidthMode: ColumnWidthMode.auto,
                    columnName: 'delivery_date',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text(
                        'Delivery Date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  GridColumn(
                    width: 200,
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
