import 'package:mysql1/mysql1.dart';

import '../constants/sql_connection.dart';

class Category {
  final int id;
  final String description;

  Category({
    required this.id,
    required this.description,
  });

  // Factory method to create an Item from a map (e.g., from JSON)
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(id: map['id'], description: map['description']);
  }

  // Method to convert an Item to a map (e.g., for JSON serialization)
  Map<String, dynamic> toMap() {
    return {'id': id, 'description': description};
  }

  // Optionally, you can override the toString method for better readability
  @override
  String toString() {
    return 'Item{id: $id, description: $description}';
  }

  static Future<List<Category>> categories() async {
    String query = 'SELECT * FROM db_Stocks.tbl_category';
    List<Category> list = [];

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
        Category category = Category(id: row[0], description: row[1]);
        list.add(category);
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
