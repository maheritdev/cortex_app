class Inventory {
  final int inventoryId;
  final String itemName;
  final String category;
  final String description;
  final int quantityInStock;
  final String unitOfMeasure;
  final int reorderLevel;
  final double unitPrice;
  final String supplier;
  final DateTime lastRestockedDate;
  final String status;
  final List<dynamic> inventoryTransactions;
  final DateTime lastUpdated;

  Inventory({
    required this.inventoryId,
    required this.itemName,
    required this.category,
    required this.description,
    required this.quantityInStock,
    required this.unitOfMeasure,
    required this.reorderLevel,
    required this.unitPrice,
    required this.supplier,
    required this.lastRestockedDate,
    required this.status,
    required this.inventoryTransactions,
    required this.lastUpdated,
  });

  factory Inventory.fromJson(Map<String, dynamic> json) {
    return Inventory(
      inventoryId: json['inventoryId'] as int,
      itemName: json['itemName'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      quantityInStock: json['quantityInStock'] as int,
      unitOfMeasure: json['unitOfMeasure'] as String,
      reorderLevel: json['reorderLevel'] as int,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      supplier: json['supplier'] as String,
      lastRestockedDate: DateTime.parse(json['lastRestockedDate'] as String),
      status: json['status'] as String,
      inventoryTransactions: json['inventoryTransactions'] as List<dynamic>,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'inventoryId': inventoryId,
      'itemName': itemName,
      'category': category,
      'description': description,
      'quantityInStock': quantityInStock,
      'unitOfMeasure': unitOfMeasure,
      'reorderLevel': reorderLevel,
      'unitPrice': unitPrice,
      'supplier': supplier,
      'lastRestockedDate': lastRestockedDate.toIso8601String(),
      'status': status,
      'inventoryTransactions': inventoryTransactions,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  // Helper method to check if item needs reordering
  bool get needsReorder {
    return quantityInStock <= reorderLevel;
  }

  // Helper method to get stock status with color
  String get stockStatus {
    if (quantityInStock == 0) {
      return 'Out of Stock';
    } else if (needsReorder) {
      return 'Low Stock';
    } else {
      return 'In Stock';
    }
  }

  // Helper method to get status color
  int get statusColor {
    if (quantityInStock == 0) {
      return 0xFFFF0000; // Red
    } else if (needsReorder) {
      return 0xFFFFA500; // Orange
    } else {
      return 0xFF4CAF50; // Green
    }
  }

  // Helper method to calculate total value
  double get totalValue {
    return quantityInStock * unitPrice;
  }

  @override
  String toString() {
    return 'Inventory(inventoryId: $inventoryId, itemName: $itemName, category: $category, quantityInStock: $quantityInStock, status: $status)';
  }

  // Copy with method for easy updates
  Inventory copyWith({
    int? inventoryId,
    String? itemName,
    String? category,
    String? description,
    int? quantityInStock,
    String? unitOfMeasure,
    int? reorderLevel,
    double? unitPrice,
    String? supplier,
    DateTime? lastRestockedDate,
    String? status,
    List<dynamic>? inventoryTransactions,
    DateTime? lastUpdated,
  }) {
    return Inventory(
      inventoryId: inventoryId ?? this.inventoryId,
      itemName: itemName ?? this.itemName,
      category: category ?? this.category,
      description: description ?? this.description,
      quantityInStock: quantityInStock ?? this.quantityInStock,
      unitOfMeasure: unitOfMeasure ?? this.unitOfMeasure,
      reorderLevel: reorderLevel ?? this.reorderLevel,
      unitPrice: unitPrice ?? this.unitPrice,
      supplier: supplier ?? this.supplier,
      lastRestockedDate: lastRestockedDate ?? this.lastRestockedDate,
      status: status ?? this.status,
      inventoryTransactions: inventoryTransactions ?? this.inventoryTransactions,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

// Extension for list operations
extension InventoryListExtensions on List<Inventory> {
  List<Inventory> get lowStockItems {
    return where((item) => item.needsReorder).toList();
  }

  List<Inventory> get outOfStockItems {
    return where((item) => item.quantityInStock == 0).toList();
  }

  List<Inventory> getByCategory(String category) {
    return where((item) => item.category == category).toList();
  }

  List<String> get uniqueCategories {
    return map((item) => item.category).toSet().toList();
  }

  double get totalInventoryValue {
    return fold(0.0, (sum, item) => sum + item.totalValue);
  }

  List<Inventory> search(String query) {
    if (query.isEmpty) return this;
    final lowercaseQuery = query.toLowerCase();
    return where((item) =>
    item.itemName.toLowerCase().contains(lowercaseQuery) ||
        item.category.toLowerCase().contains(lowercaseQuery) ||
        item.description.toLowerCase().contains(lowercaseQuery) ||
        item.supplier.toLowerCase().contains(lowercaseQuery)).toList();
  }
}