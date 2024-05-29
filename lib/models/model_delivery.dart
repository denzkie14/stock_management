import 'model_item.dart';

class Delivery {
  final String id;
  final int supplierId;
  String? supplier;
  final String deliveryNumber;
  List<Item>? items;
  final DateTime deliveryDate;
  final String createdBy;
  final bool isDeleted;

  Delivery({
    required this.id,
    required this.supplierId,
    this.supplier,
    this.items,
    required this.deliveryDate,
    required this.deliveryNumber,
    required this.createdBy,
    required this.isDeleted,
  });

  // Factory method to create a Delivery from a map (e.g., from JSON)
  factory Delivery.fromMap(Map<String, dynamic> map) {
    return Delivery(
      id: map['id'],
      supplierId: map['supplier_id'],
      supplier: map['supplier'],
      items: List<Item>.from(map['items'].map((item) => Item.fromMap(item))),
      deliveryNumber: map['delivery_number'],
      deliveryDate: DateTime.parse(map['date_delivered']),
      createdBy: map['createdBy'],
      isDeleted: map['is_cancelled'],
    );
  }

  // Method to convert a Delivery to a map (e.g., for JSON serialization)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'supplier_id': supplierId,
      'supplier': supplier,
      'items': items?.map((item) => item.toMap()).toList(),
      'date_delivered': deliveryDate.toIso8601String(),
      'delivery_number': deliveryNumber,
      'createdBy': createdBy,
      'is_cancelled': isDeleted,
    };
  }

  // Optionally, you can override the toString method for better readability
  @override
  String toString() {
    return 'Delivery{id: $id, supplierId: $supplierId, items: $items, deliveryDate: $deliveryDate, createdBy: $createdBy, isDeleted: $isDeleted}';
  }
}
