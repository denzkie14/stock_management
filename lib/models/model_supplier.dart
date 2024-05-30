import 'package:mysql1/mysql1.dart';

import '../constants/sql_connection.dart';

class Supplier {
  final int id;
  final String name;
  String? contactNumber;
  String? address;

  Supplier({
    required this.id,
    required this.name,
    this.contactNumber,
    this.address,
  });

  // Factory method to create a Supplier from a map (e.g., from JSON)
  factory Supplier.fromMap(Map<String, dynamic> map) {
    return Supplier(
      id: map['id'],
      name: map['name'],
      contactNumber: map['contact'],
      address: map['address'],
    );
  }

  // Method to convert a Supplier to a map (e.g., for JSON serialization)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'contact': contactNumber,
      'address': address,
    };
  }

  // Optionally, you can override the toString method for better readability
  @override
  String toString() {
    return 'Supplier{id: $id, name: $name, contact: $contactNumber, address: $address}';
  }

  static Future<List<Supplier>> suppliers() async {
    String query = 'SELECT * FROM db_Stocks.tbl_supplier';
    List<Supplier> list = [];

    MySqlConnection? conn;

    try {
      // Create a connection
      conn = await MySqlConnection.connect(settings);
      print('Database connection success...');

      // Perform a query
      var results = await conn.query(query);
      print('Query executed successfully...');
      results = await conn.query(query);
      // Iterate through the results and create Category objects
      list.clear();
      for (var row in results) {
        Supplier value = Supplier(
            id: row[0], name: row[1], address: row[2], contactNumber: row[3]);
        list.add(value);
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      // Ensure the connection is closed
      await conn?.close();
    }

    return list;
  }
}
