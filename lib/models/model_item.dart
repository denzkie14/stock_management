class Item {
  final int id;
  final String productId;
  final String name;

  num quantity;
  num unitPrice;
  final String unit;
  final num stockOnHand;
  final String deliveryId;
  final DateTime expirationDate;

  Item({
    required this.productId,
    required this.name,
    required this.id,
    required this.unit,
    required this.quantity,
    required this.unitPrice,
    required this.stockOnHand,
    required this.deliveryId,
    required this.expirationDate,
  });

  // Factory method to create an Item from a map (e.g., from JSON)
  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      quantity: map['quantity'],
      unitPrice: map['unitPrice'],
      unit: map['unit'],
      stockOnHand: map['stockOnHand'],
      deliveryId: map['deliveryId'],
      expirationDate: DateTime.parse(map['expirationDate']),
      productId: map['product_id'],
      name: map['name'],
    );
  }

  // Method to convert an Item to a map (e.g., for JSON serialization)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'unit': unit,
      'stockOnHand': stockOnHand,
      'deliveryId': deliveryId,
      'product_id': productId,
      'name': name,
      'expirationDate': expirationDate.toIso8601String(),
    };
  }

  // Optionally, you can override the toString method for better readability
  @override
  String toString() {
    return 'Item{id: $id, quantity: $quantity,   unit: $unit, unitPrice: $unitPrice, stockOnHand: $stockOnHand, deliveryId: $deliveryId, expirationDate: $expirationDate}';
  }
}
