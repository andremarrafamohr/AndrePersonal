class SalesAnalysis {
  final DateTime period;
  final double totalSales;
  final int totalOrders;

  SalesAnalysis({
    required this.period,
    required this.totalSales,
    required this.totalOrders,
  });

  factory SalesAnalysis.fromMap(Map<String, dynamic> map) {
    return SalesAnalysis(
      period: DateTime.parse(map['period']),
      totalSales: map['totalSales']?.toDouble() ?? 0.0,
      totalOrders: map['totalOrders'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'period': period.toIso8601String(),
      'totalSales': totalSales,
      'totalOrders': totalOrders,
    };
  }
}
