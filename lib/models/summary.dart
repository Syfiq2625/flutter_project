class DashboardSummary {
  final int totalItems;
  final int totalBorrowed;
  final int totalBroken;

  DashboardSummary({
    required this.totalItems,
    required this.totalBorrowed,
    required this.totalBroken,
  });

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSummary(
      totalItems: json['total_items'],
      totalBorrowed: json['total_borrowed'],
      totalBroken: json['total_broken'],
    );
  }
}