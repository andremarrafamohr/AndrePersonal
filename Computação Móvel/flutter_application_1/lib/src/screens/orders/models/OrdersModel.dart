class Order {
  final String customerName;
  final List<String> items;
  final String status;

  Order({
    required this.customerName,
    required this.items,
    required this.status,
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      customerName: map['customerName'] ?? '',
      items: List<String>.from(map['items'] ?? []),
      status: map['status'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customerName': customerName,
      'items': items,
      'status': status,
    };
  }
}
