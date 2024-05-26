import 'model_item.dart';

class Delivery {
  final int id;
  final int supplierId;
  final List<Item> items;
  final DateTime deliveryDate;
  final String createdBy;
  final bool isDeleted;

  Delivery({
    required this.id,
    required this.supplierId,
    required this.items,
    required this.deliveryDate,
    required this.createdBy,
    required this.isDeleted,
  });

  // Factory method to create a Delivery from a map (e.g., from JSON)
  factory Delivery.fromMap(Map<String, dynamic> map) {
    return Delivery(
      id: map['id'],
      supplierId: map['supplierId'],
      items: List<Item>.from(map['items'].map((item) => Item.fromMap(item))),
      deliveryDate: DateTime.parse(map['deliveryDate']),
      createdBy: map['createdBy'],
      isDeleted: map['isDeleted'],
    );
  }

  // Method to convert a Delivery to a map (e.g., for JSON serialization)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'supplierId': supplierId,
      'items': items.map((item) => item.toMap()).toList(),
      'deliveryDate': deliveryDate.toIso8601String(),
      'createdBy': createdBy,
      'isDeleted': isDeleted,
    };
  }

  // Optionally, you can override the toString method for better readability
  @override
  String toString() {
    return 'Delivery{id: $id, supplierId: $supplierId, items: $items, deliveryDate: $deliveryDate, createdBy: $createdBy, isDeleted: $isDeleted}';
  }
}
