class Supplier {
  final int id;
  final String name;
  final String contactNumber;
  final String address;

  Supplier({
    required this.id,
    required this.name,
    required this.contactNumber,
    required this.address,
  });

  // Factory method to create a Supplier from a map (e.g., from JSON)
  factory Supplier.fromMap(Map<String, dynamic> map) {
    return Supplier(
      id: map['id'],
      name: map['name'],
      contactNumber: map['contactNumber'],
      address: map['address'],
    );
  }

  // Method to convert a Supplier to a map (e.g., for JSON serialization)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'contactNumber': contactNumber,
      'address': address,
    };
  }

  // Optionally, you can override the toString method for better readability
  @override
  String toString() {
    return 'Supplier{id: $id, name: $name, contactNumber: $contactNumber, address: $address}';
  }
}
