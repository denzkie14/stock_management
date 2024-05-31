import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stock_management/data/delivery_product_data_source.dart';
import 'package:stock_management/models/model_delivery.dart';
import 'package:stock_management/views/stock/widgets/cart.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/delivery_controller.dart';
import '../../main.dart';
import '../../models/model_product.dart';
import 'widgets/item_form_widget.dart';
import 'package:pdf/widgets.dart' as pw;

class DeliveryItems extends StatelessWidget {
  DeliveryItems({super.key, required this.delivery});
  final Delivery delivery;
  final controller = Get.find<DeliveryController>();
  final productDataSource = DeliveryProductDataSource();
  final DataGridController dgController = DataGridController();
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

    dgController.selectedRow = null;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    controller.loadItems(delivery);
    return WillPopScope(
      onWillPop: () {
        controller.selectedCategory.value = null;
        controller.itemList.clear();

        return Future.value(true);
      },
      child: Scaffold(
          //    drawer: const SideBar(),
          appBar: AppBar(
            title: const Text(
              'Stock Delivery - Items',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  await generateAndSavePdf();
                },
                child: const Text('Generate Report'),
              ),
            ],
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
          )),
    );
  }

  Widget productTable() {
    return Obx(() {
      return controller.isListLoading.value
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SfDataGrid(
              selectionMode: SelectionMode.single,
              controller: dgController,
              onSelectionChanged:
                  (List<DataGridRow> addedRows, List<DataGridRow> removedRows) {
                if (addedRows.isNotEmpty) {
                  //  final selectedRow = addedRows.first;
                  final rowIndex = dgController.selectedIndex;
                  print('Selected Row Data: $rowIndex');
                  // Retrieve the data from the selected row
                  //     final rowData = productDataSource.getRowData(rowIndex);
                  _onRowTap(controller.productList[rowIndex]);
                  // Perform the desired action with the selected row's data
                  //  print('Selected Row Data: $rowData');
                }
              },
              // onCellTap: (cell) {
              //   try {
              //     print('row ${cell.rowColumnIndex.rowIndex}');
              //     if (cell.rowColumnIndex.rowIndex > 0 &&
              //         cell.rowColumnIndex.rowIndex <
              //             controller.productList.length) {
              //       _onRowTap(controller
              //           .productList[cell.rowColumnIndex.rowIndex + 1]);
              //     }
              //   } catch (e) {}
              // },
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

  Future<void> generateAndSavePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Transaction #: ${delivery.id}',
                  style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text('Supplier Name #: ${delivery.supplier?.toUpperCase()}',
                  style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text('Delivery #: ${delivery.deliveryNumber}',
                  style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text(
                  'Delivery Date: ${DateFormat('MMMM dd, yyyy').format(delivery.deliveryDate)}',
                  style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Text(
                  'Items: ${controller.itemList.where((s) => s.id != 0).length}',
                  style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                context: context,
                headers: ['Item', 'Quantity', 'Unit', 'Price', 'Total Amount'],
                cellAlignments: {
                  0: pw.Alignment.centerLeft, // Item
                  1: pw.Alignment.centerRight, // Quantity
                  2: pw.Alignment.center, // Unit
                  3: pw.Alignment.centerRight, // Price
                  4: pw.Alignment.centerRight, // Total Amount
                },
                data: controller.itemList
                    .where((s) => s.id != 0)
                    .map((item) => [
                          '${item.productId} - ${item.name}',
                          NumberFormat('#,##0.00').format(item.quantity),
                          item.unit,
                          'P ${NumberFormat('#,##0.00').format(item.unitPrice)}',
                          'P ${NumberFormat('#,##0.00').format(item.quantity * item.unitPrice)}'
                        ])
                    .toList(),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Total Amount: P ${NumberFormat('#,##0.00').format(controller.itemList.where((s) => s.id != 0).fold(0.0, (sum, item) => sum + (item.quantity * item.unitPrice)))}',
                style:
                    pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
            ],
          );
        },
      ),
    );

    // Get the application documents directory
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/${delivery.id}.pdf');

    // Save the PDF document to a file
    await file.writeAsBytes(await pdf.save());

    print('PDF Saved: ${file.path}');
  }
}
