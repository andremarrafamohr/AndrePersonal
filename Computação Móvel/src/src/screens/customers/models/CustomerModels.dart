class Customer {
  final String name;
  final String email;
  final String dob;
  final String contact;

  Customer({
    required this.name,
    required this.email,
    required this.dob,
    required this.contact,
  });

  factory Customer.fromMap(Map<String, String> map) {
    return Customer(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      dob: map['dob'] ?? '',
      contact: map['contact'] ?? '',
    );
  }

  Map<String, String> toMap() {
    return {
      'name': name,
      'email': email,
      'dob': dob,
      'contact': contact,
    };
  }
}
