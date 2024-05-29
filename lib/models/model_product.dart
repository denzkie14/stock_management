class Product {
  final String id;
//  final String code;
  final String name;
  final String unit;
  final int categoryId;
  String? category;
  Product({
    required this.id,
    //  required this.code,
    required this.name,
    required this.unit,
    required this.categoryId,
    this.category,
  });

  // Factory method to create an Item from a map (e.g., from JSON)
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      //    code: map['code'],
      name: map['name'],
      unit: map['unit'],
      categoryId: map['categoryId'],
      category: map['category'],
    );
  }

  // Method to convert an Item to a map (e.g., for JSON serialization)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      //  'code': code,
      'name': name,
      'unit': unit,
      'categoryId': categoryId,
      'category': category
    };
  }

  // Optionally, you can override the toString method for better readability
  @override
  String toString() {
    return 'Item{id: $id, name: $name, unit: $unit, categoryId: $categoryId, category: $category}';
  }
}
