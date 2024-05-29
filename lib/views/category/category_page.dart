import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_management/data/category_data_source.dart';
import 'package:stock_management/views/category/widgets/category_form_widget.dart';
import 'package:stock_management/widgets/sidebar.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/category_controller.dart';
import '../../models/model_category.dart';

class CategoryPage extends StatelessWidget {
  CategoryPage({super.key});
  final controller = Get.put(CategoryController());
  final CategoryDataSource dataSource = CategoryDataSource();

  void _showForm(context, {Category? item}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: CategoryForm(
            data: item,
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
          'Categories',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () => controller.loadRecords(),
              icon: const Icon(Icons.refresh)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.search))
        ],
      ),
      drawer: const SideBar(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Category',
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
                        'Category Name',
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
              );
      }),
    );
  }
}
