import 'dart:isolate';

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
    //  testConnection();
    categoryList.value = await Category.categories();
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

  updateProduct(Product product) async {
    MySqlConnection? conn;
    isLoading(true);
    try {
      conn = await MySqlConnection.connect(settings);

      var result = await conn.query(
          "Update db_stocks.tbl_products set  name = '${product.name}', unit = '${product.unit}', category_id = '${product.categoryId}' where id = '${product.id}'");

      // var result = await conn.query(
      //     "UPDATE db_stocks.tbl_products SET name = ?, unit = ?, category_id = ? WHERE id = ?",
      //     [product.name, product.unit, product.categoryId, product.id]);

      print('Updated row id: ${result}');
      hasError = false;
      resultMessage = 'Product updated successfully.';
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

  deleteProduct(String code) async {
    MySqlConnection? conn;
    isLoading(true);
    try {
      conn = await MySqlConnection.connect(settings);

      var result = await conn.query(
        "Delete from db_stocks.tbl_products where id = $code",
      );
      print('Inserted row id: ${result}');

      hasError = false;
      resultMessage = 'Product deleted successfully.';
    } on MySqlException catch (e) {
      if (e.errorNumber == 1062) {
        // Handle duplicate entry error
        print('Duplicate entry error: ${e.message}');
        resultMessage = 'SQL error: ${e.message}';
      } else {
        // Handle other MySQL errors
        print('MySQL Error: ${e.message}');
        resultMessage = 'SQL Error: ${e.message}';
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

  var isListLoading = false.obs;
  loadProducts() async {
    isListLoading(true);
    final receivePort = ReceivePort();
    await Isolate.spawn(isolateLoadProducts, receivePort.sendPort);
    await for (var msg in receivePort) {
      if (msg is List<Product>) {
        productList.clear();
        productList.addAll(msg);
        productList.refresh();
      } else {
        print('loadProducts Error: $msg');
      }

      isListLoading(false);
    }
    receivePort.close();
  }

  static void isolateLoadProducts(SendPort sendPort) async {
    // final port = ReceivePort();
    //sendPort.send(port.sendPort);

    try {
      MySqlConnection conn = await MySqlConnection.connect(settings);
      List<Product> data = <Product>[];
      String sql =
          'SELECT p.id, p.name, p.unit,p.category_id, c.category, p.is_deleted FROM db_stocks.tbl_products p left join tbl_category c on c.id = p.category_id where p.is_deleted = 0';
      final query1 = await conn.query(sql);
      final query = await conn.query(sql);

      for (var row in query) {
        Product value = Product(
            id: row[0],
            name: row[1],
            unit: row[2],
            categoryId: row[3],
            category: row[4]);
        data.add(value);
      }

      await conn.close();
      sendPort.send(data);
    } catch (e) {
      print('Error querying database: $e');
      sendPort.send([]);
    }
  }
}
