import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mysql1/mysql1.dart';
import 'package:stock_management/models/model_category.dart';
import 'package:stock_management/models/model_product.dart';

import '../constants/sql_connection.dart';

class ProductController extends GetxController {
  var productList = <Product>[].obs;
  var categoryList = <Category>[].obs;
  final selectedCategory = Rxn<Category>();
  final code = TextEditingController();
  final name = TextEditingController();
  final unit = TextEditingController();
  final categoryId = TextEditingController();
  String resultMessage = '';
  bool hasError = false;
  @override
  onInit() async {
    super.onInit();
    loadProducts();
    testConnection();
    categoryList.value = await Category.categories();
  }

  testConnection() async {
    MySqlConnection? conn;

    try {
      // Create a connection
      conn = await MySqlConnection.connect(settings);
      print('Database connection success...');
      // Perform a query
      var results = await conn.query('SELECT * FROM your_table_name');
      for (var row in results) {
        print('Row: ${row[0]}, ${row[1]}, ${row[2]}');
      }

      // // Insert a row
      // var result = await conn.query(
      //   'INSERT INTO your_table_name (column1, column2) VALUES (?, ?)',
      //   ['value1', 'value2'],
      // );
      // print('Inserted row id: ${result.insertId}');

      // // Update a row
      // await conn.query(
      //   'UPDATE your_table_name SET column1 = ? WHERE column2 = ?',
      //   ['new_value', 'value2'],
      // );
      // print('Updated row.');

      // // Delete a row
      // await conn.query(
      //   'DELETE FROM your_table_name WHERE column2 = ?',
      //   ['value2'],
      // );
      // print('Deleted row.');
    } catch (e) {
      print('Error: $e');
    } finally {
      // Ensure the connection is closed
      await conn?.close();
    }
  }

  var isLoading = false.obs;
  insertProduct() async {
    MySqlConnection? conn;
    isLoading(true);
    try {
      conn = await MySqlConnection.connect(settings);

      var result = await conn.query(
        "INSERT INTO db_stocks.tbl_products (id, name, unit, category_id, is_deleted) VALUES('${code.text}','${name.text}','${unit.text}','${selectedCategory.value?.id}',0)",
      );
      print('Inserted row id: ${result}');

      hasError = false;
      resultMessage = 'Product added successfully.';
    } on MySqlException catch (e) {
      if (e.errorNumber == 1062) {
        // Handle duplicate entry error
        print('Duplicate entry error: ${e.message}');
        resultMessage = 'Duplicate entry error: ${e.message}';
      } else {
        // Handle other MySQL errors
        print('MySQL Error: ${e.message}');
        resultMessage = 'MySQL Error: ${e.message}';
      }
      hasError = true;
    } catch (e) {
      print('Error: $e');
      resultMessage = 'Error: ${e.toString()}';
      hasError = true;
    } finally {
      // Ensure the connection is closed
      await conn?.close();
      isLoading(false);

      loadProducts();
    }
  }

  loadProducts() {
    productList.clear();
    productList.addAll(Product.getList());
  }
}
