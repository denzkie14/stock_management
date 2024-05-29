import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mysql1/mysql1.dart';
import 'package:stock_management/models/model_category.dart';
import 'package:stock_management/models/model_delivery.dart';
import 'package:stock_management/models/model_product.dart';

import '../constants/sql_connection.dart';

class DeliveryController extends GetxController {
  var deliveryList = <Delivery>[].obs;
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
    loadDelivery();
    // loadProducts();
    //  testConnection();
    // categoryList.value = await Category.categories();
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

      // loadProducts();
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

      //  loadProducts();
    }
  }

  deleteProduct(String code) async {
    MySqlConnection? conn;
    isLoading(true);
    try {
      conn = await MySqlConnection.connect(settings);

      var result = await conn.query(
        "Update from db_stocks.tbl_products set is_deleted = 1 where id = $code",
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

      //loadProducts();
    }
  }

  var isListLoading = false.obs;
  loadDelivery() async {
    isListLoading(true);
    final receivePort = ReceivePort();
    await Isolate.spawn(isolateLoadDelivery, receivePort.sendPort);
    await for (var msg in receivePort) {
      if (msg is List<Delivery>) {
        deliveryList.clear();
        deliveryList.addAll(msg);
        deliveryList.refresh();
      } else {
        print('loadDelivery Error: $msg');
      }

      isListLoading(false);
    }
    receivePort.close();
  }

  static void isolateLoadDelivery(SendPort sendPort) async {
    try {
      MySqlConnection conn = await MySqlConnection.connect(settings);
      List<Delivery> data = <Delivery>[];
      String sql =
          'SELECT d.id, d.delivery_number, d.supplier_id, s.name as supplier, d.date_delivered, d.is_cancelled FROM db_stocks.tbl_deliveries d left join tbl_supplier s on s.id = d.supplier_id';
      final query1 = await conn.query(sql);
      final query = await conn.query(sql);

      for (var row in query) {
        Delivery value = Delivery(
            id: row[0],
            deliveryNumber: row[1],
            supplierId: row[2],
            supplier: row[3],
            deliveryDate: row[4],
            createdBy: '1',
            isDeleted: false);
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
