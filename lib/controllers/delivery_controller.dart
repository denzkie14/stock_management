import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mysql1/mysql1.dart';
import 'package:stock_management/models/model_category.dart';
import 'package:stock_management/models/model_delivery.dart';
import 'package:stock_management/models/model_item.dart';
import 'package:stock_management/models/model_product.dart';
import 'package:stock_management/models/model_supplier.dart';

import '../constants/sql_connection.dart';

class DeliveryController extends GetxController {
  var transactionNumber = ''.obs;

  var deliveryList = <Delivery>[].obs;
  var supplierList = <Supplier>[].obs;

  var categoryList = <Category>[].obs;
  var productList = <Product>[].obs;
  var itemList = <Item>[].obs;

  final selectedCategory = Rxn<Category>();
  final selectedSupplier = Rxn<Supplier>();

  final id = TextEditingController();
  final supplier = TextEditingController();
  final deliveryNumber = TextEditingController();
  final deliveryDate = TextEditingController();

  String resultMessage = '';
  bool hasError = false;

  var isListLoading = false.obs;
  @override
  onInit() async {
    super.onInit();
    loadRecord();
    loadProducts();

    categoryList.clear();
    categoryList.addAll(await Category.categories());
    categoryList.refresh();
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
        "INSERT INTO db_stocks.tbl_deliveries (id, supplier_id, delivery_number, date_delivered, is_cancelled, created_by) VALUES('${id.text}','${selectedSupplier.value?.id}','${deliveryNumber.text}','${deliveryDate.text}',0, 'denzkie')",
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
      loadRecord();
    }
  }

  generateTransactionCode() async {
    transactionNumber.value = await Delivery.generateCode();
  }

  updateRecord(Delivery item) async {
    MySqlConnection? conn;
    isLoading(true);
    try {
      conn = await MySqlConnection.connect(settings);

      var result = await conn.query(
        "Update db_stocks.tbl_deliveries set supplier_id = ${selectedSupplier.value?.id}, delivery_number = '${item.deliveryNumber}', date_delivered = '${item.deliveryDate.year}-${item.deliveryDate.month}-${item.deliveryDate.day}' where id  = '${item.id}'",
      );

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

      loadRecord();
    }
  }

  deleteRecord(String code) async {
    MySqlConnection? conn;
    isLoading(true);
    try {
      conn = await MySqlConnection.connect(settings);

      var result = await conn.query(
        "Update db_stocks.tbl_deliveries set is_cancelled = 1 where id = '$code'",
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

      loadRecord();
    }
  }

  loadRecord() async {
    try {
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
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  static void isolateLoadDelivery(SendPort sendPort) async {
    try {
      MySqlConnection conn = await MySqlConnection.connect(settings);
      List<Delivery> data = <Delivery>[];
      String sql =
          'SELECT d.id, d.supplier_id, s.name as supplier, d.delivery_number,  d.date_delivered, d.is_cancelled FROM db_stocks.tbl_deliveries d left join tbl_supplier s on s.id = d.supplier_id where d.is_cancelled = 0';
      final query1 = await conn.query(sql);
      final query = await conn.query(sql);

      for (var row in query) {
        Delivery value = Delivery(
            id: row[0],
            supplierId: row[1],
            supplier: row[2],
            deliveryNumber: row[3],
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

  var isProductListLoading = false.obs;
  loadProducts() async {
    isProductListLoading(true);
    final receivePort = ReceivePort();

    int _catId =
        selectedCategory.value == null ? 0 : selectedCategory.value!.id;
    await Isolate.spawn(
      (SendPort sendport) => isolateLoadProducts(sendport, _catId),
      receivePort.sendPort,
    );

    await for (var msg in receivePort) {
      if (msg is List<Product>) {
        productList.clear();
        productList.addAll(msg);
        productList.sort((a, b) => a.id.compareTo(b.name));
        productList.refresh();
      } else {
        print('loadProducts Error: $msg');
      }

      isProductListLoading(false);
    }
    receivePort.close();
  }

  static void isolateLoadProducts(SendPort sendPort, int id) async {
    // final port = ReceivePort();
    //sendPort.send(port.sendPort);

    try {
      MySqlConnection conn = await MySqlConnection.connect(settings);
      List<Product> data = <Product>[];
      String sql =
          "SELECT p.id, p.name, p.unit,p.category_id, c.category, p.is_deleted FROM db_stocks.tbl_products p left join tbl_category c on c.id = p.category_id where p.is_deleted = 0 and ${id == 0 ? true : 'p.category_id = $id'} ";
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

  insertItems(Delivery delivery) async {
    MySqlConnection? conn;
    //  isLoading(true);
    try {
      conn = await MySqlConnection.connect(settings);

      for (Item i in itemList) {
        if (i.id == 0) {
          var result = await conn.query(
            "INSERT INTO db_stocks.tbl_items (delivery_id, product_id, quantity, base_price, is_deleted) VALUES('${delivery.id}','${i.productId}',${i.quantity},${i.unitPrice},0)",
          );
          print('Inserted row id: ${result}');
        } else {
          var result = await conn.query(
            "Update  db_stocks.tbl_items set quantity = ${i.quantity}, base_price = ${i.unitPrice} where id=${i.id}",
          );
          print('Inserted row id: ${result}');
        }
      }

      hasError = false;
      resultMessage = 'Items added successfully.';
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
      //   isLoading(false);
    }
  }

  delteItem(Delivery delivery, Item item) async {
    MySqlConnection? conn;
    //  isLoading(true);
    try {
      conn = await MySqlConnection.connect(settings);

      var result = await conn.query(
        "Update  db_stocks.tbl_items set is_deleted = 1 where id=${item.id}",
      );

      print('Deleted row id: ${result}');

      hasError = false;
      resultMessage = 'Item Deleted successfully.';
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
      //   isLoading(false);
    }
  }

  void loadItems(Delivery delivery) async {
    // final port = ReceivePort();
    //sendPort.send(port.sendPort);

    try {
      MySqlConnection conn = await MySqlConnection.connect(settings);
      List<Item> data = <Item>[];
      String sql =
          "SELECT i.id, i.delivery_id, i.product_id, i.quantity, i.base_price, p.name, p.unit, p.category_id, c.category FROM db_stocks.tbl_items i left join db_stocks.tbl_products p on p.id=i.product_id	left join db_stocks.tbl_category c on c.id=p.category_id where delivery_id = '${delivery.id}' and i.is_deleted = 0";

      final query1 = await conn.query(sql);
      final query = await conn.query(sql);

      for (var row in query) {
        Item value = Item(
          id: row[0],
          deliveryId: row[1],
          productId: row[2],
          quantity: row[3],
          unitPrice: row[4],
          name: row[5],
          unit: row[6],
          expirationDate: DateTime.now(),
          stockOnHand: 0,
        );
        data.add(value);
      }

      await conn.close();

      itemList.clear();
      itemList.addAll(data);
      itemList.refresh();
      //  sendPort.send(data);
    } catch (e) {
      print('Error querying database: $e');
      // sendPort.send([]);
    }
  }
}
