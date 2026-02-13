class Ad {
  final String title;
  final String description;

  Ad({
    required this.title,
    required this.description,
  });

  factory Ad.fromMap(Map<String, String> map) {
    return Ad(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
    );
  }

  Map<String, String> toMap() {
    return {
      'title': title,
      'description': description,
    };
  }
}
