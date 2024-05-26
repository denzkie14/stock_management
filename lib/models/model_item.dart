class Item {
  final int id;
  final num quantity;
  final num unitPrice;
  final num stockOnHand;
  final int deliveryId;
  final DateTime expirationDate;

  Item({
    required this.id,
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
      stockOnHand: map['stockOnHand'],
      deliveryId: map['deliveryId'],
      expirationDate: DateTime.parse(map['expirationDate']),
    );
  }

  // Method to convert an Item to a map (e.g., for JSON serialization)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'stockOnHand': stockOnHand,
      'deliveryId': deliveryId,
      'expirationDate': expirationDate.toIso8601String(),
    };
  }

  // Optionally, you can override the toString method for better readability
  @override
  String toString() {
    return 'Item{id: $id, quantity: $quantity, unitPrice: $unitPrice, stockOnHand: $stockOnHand, deliveryId: $deliveryId, expirationDate: $expirationDate}';
  }
}
