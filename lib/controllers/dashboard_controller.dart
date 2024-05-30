import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mysql1/mysql1.dart';
import 'package:stock_management/models/model_supplier.dart';

import '../constants/sql_connection.dart';

class DashboardController extends GetxController {
  DateTime from = DateTime.now();
  DateTime to = DateTime.now();

  var list = <Supplier>[].obs;
  final selectedSelectedReocrd = Rxn<Supplier>();

  final id = TextEditingController();
  final name = TextEditingController();
  final contactNumber = TextEditingController();
  final address = TextEditingController();

  String resultMessage = '';
  bool hasError = false;

  var totalProducts = 0.obs;
  var totalCategories = 0.obs;
  var totalSuppliers = 0.obs;
  var totalDeliveries = 0.obs;

  @override
  onInit() async {
    super.onInit();
    getTotalProducts();
  }

  var isLoading = false.obs;

  getTotalProducts() async {
    MySqlConnection? conn;
    isLoading(true);
    try {
      conn = await MySqlConnection.connect(settings);

      var result = await conn.query(
        "Select count(*)  from db_stocks.tbl_products where is_deleted = 0",
      );

      totalProducts.value = result.first[0];
      hasError = false;
    } catch (e) {
      print('Error: $e');
      resultMessage = 'Error: ${e.toString()}';
      hasError = true;
    } finally {
      // Ensure the connection is closed
      await conn?.close();
      isLoading(false);
    }
  }
}
