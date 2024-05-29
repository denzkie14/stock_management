import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mysql1/mysql1.dart';

import '../constants/sql_connection.dart';
import '../models/model_category.dart';

class CategoryController extends GetxController {
  var list = <Category>[].obs;
  final selectedSelectedReocrd = Rxn<Category>();

  final id = TextEditingController();
  final name = TextEditingController();

  String resultMessage = '';
  bool hasError = false;

  @override
  onInit() async {
    super.onInit();
    loadRecords();
  }

  var isLoading = false.obs;
  insertRecord() async {
    MySqlConnection? conn;
    isLoading(true);
    try {
      conn = await MySqlConnection.connect(settings);

      var result = await conn.query(
        "INSERT INTO db_stocks.tbl_category (category, is_deleted) VALUES('${name.text}',0)",
      );
      print('Inserted row id: ${result}');

      hasError = false;
      resultMessage = 'Category added successfully.';
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

      loadRecords();
    }
  }

  updateRecord(Category record) async {
    MySqlConnection? conn;
    isLoading(true);
    try {
      conn = await MySqlConnection.connect(settings);

      var result = await conn.query(
          "Update db_stocks.tbl_category set  category = '${record.description}' where id = ${record.id}");

      print('Updated row id: ${result}');
      hasError = false;
      resultMessage = 'Category updated successfully.';
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

      loadRecords();
    }
  }

  deleteRecord(int id) async {
    MySqlConnection? conn;
    isLoading(true);
    try {
      conn = await MySqlConnection.connect(settings);

      var result = await conn.query(
        "Update  db_stocks.tbl_category set is_deleted = 1 where id = $id",
      );
      print('Inserted row id: ${result}');

      hasError = false;
      resultMessage = 'Category deleted successfully.';
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

      loadRecords();
    }
  }

  var isListLoading = false.obs;
  loadRecords() async {
    isListLoading(true);
    final receivePort = ReceivePort();
    await Isolate.spawn(isolateLoadRecords, receivePort.sendPort);
    await for (var msg in receivePort) {
      if (msg is List<Category>) {
        list.clear();
        list.addAll(msg);
        list.refresh();
      } else {
        print('loadRecords Error: $msg');
      }

      isListLoading(false);
    }
    receivePort.close();
  }

  static void isolateLoadRecords(SendPort sendPort) async {
    // final port = ReceivePort();
    //sendPort.send(port.sendPort);

    try {
      MySqlConnection conn = await MySqlConnection.connect(settings);
      List<Category> data = <Category>[];
      String sql = 'Select * from tbl_category where is_deleted = 0';
      final query1 = await conn.query(sql);
      final query = await conn.query(sql);

      for (var row in query) {
        Category value = Category(id: row[0], description: row[1]);
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
