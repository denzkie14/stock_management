import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mysql1/mysql1.dart';
import 'package:stock_management/models/model_category.dart';
import 'package:stock_management/models/model_delivery.dart';
import 'package:stock_management/models/model_product.dart';
import 'package:stock_management/models/model_supplier.dart';

import '../constants/sql_connection.dart';

class DeliveryController extends GetxController {
  var deliveryList = <Delivery>[].obs;
  var supplierList = <Supplier>[].obs;
  final selectedSupplier = Rxn<Supplier>();

  final id = TextEditingController();
  final supplier = TextEditingController();
  final deliveryNumber = TextEditingController();
  final deliveryDate = TextEditingController();

  //final categoryId = TextEditingController();
  String resultMessage = '';
  bool hasError = false;
  @override
  onInit() async {
    super.onInit();
    loadRecord();
    supplierList.value = await Supplier.suppliers();
    // loadProducts();
    //  testConnection();
    // categoryList.value = await Category.categories();
  }

  var isLoading = false.obs;
  insertRecord() async {
    MySqlConnection? conn;
    isLoading(true);
    try {
      conn = await MySqlConnection.connect(settings);

      var result = await conn.query(
        "INSERT INTO db_stocks.tbl_deliveries (id, supplier_id, delivery_number, date_delivered, is_cancelled) VALUES('${id.text}','${selectedSupplier.value?.id}','${deliveryNumber.text}','${deliveryDate.text}',0)",
      );
      print('Inserted row id: ${result}');

      hasError = false;
      resultMessage = 'Delivery added successfully.';
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

  updateRecord(Delivery item) async {
    MySqlConnection? conn;
    isLoading(true);
    try {
      conn = await MySqlConnection.connect(settings);

      var result = await conn.query(
          "Update db_stocks.tbl_deliveries set supplier_id = '${item.supplierId}', delivery_number = '${item.deliveryNumber}', date_delivered = '${item.deliveryNumber}' where id = '${item.id}'");

      // var result = await conn.query(
      //     "UPDATE db_stocks.tbl_products SET name = ?, unit = ?, category_id = ? WHERE id = ?",
      //     [product.name, product.unit, product.categoryId, product.id]);

      print('Updated row id: ${result}');
      hasError = false;
      resultMessage = 'Delivery updated successfully.';
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

  deleteRecord(String code) async {
    MySqlConnection? conn;
    isLoading(true);
    try {
      conn = await MySqlConnection.connect(settings);

      var result = await conn.query(
        "Update from db_stocks.tbl_deliveries set is_cancelled = 1 where id = $code",
      );
      print('Inserted row id: ${result}');

      hasError = false;
      resultMessage = 'Delivery deleted successfully.';
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
  loadRecord() async {
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
