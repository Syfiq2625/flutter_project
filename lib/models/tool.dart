class Tool {
  final int id;
  final String name;
  final String inventoryCode;
  final String category;
  final int totalQty;
  final int availableQty;
  final String condition;
  final String status;

  Tool({
    required this.id,
    required this.name,
    required this.inventoryCode,
    required this.category,
    required this.totalQty,
    required this.availableQty,
    required this.condition,
    required this.status,
  });

  factory Tool.fromJson(Map<String, dynamic> json) {
    return Tool(
      // Parsing sesuai key JSON dari tools.php
      id: json['id'],
      name: json['name'],
      inventoryCode: json['inventory_code'],
      category: json['category'],
      totalQty: json['total_qty'],
      availableQty: json['available_qty'],
      condition: json['condition'],
      status: json['status'],
    );
  }
}