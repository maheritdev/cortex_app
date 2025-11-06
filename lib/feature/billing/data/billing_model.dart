class BillingModel {
  final int billId;
  final int patientId;
  final DateTime billDate;
  final DateTime dueDate;
  final double totalAmount;
  final double paidAmount;
  final double balance;
  final bool isPaid;
  final String status;
  final double insuranceClaimAmount;
  final String notes;
  final int createdBy;
  final List<BillingDetail> billingDetails;
  final List<dynamic> payments;

  BillingModel({
    required this.billId,
    required this.patientId,
    required this.billDate,
    required this.dueDate,
    required this.totalAmount,
    required this.paidAmount,
    required this.balance,
    required this.isPaid,
    required this.status,
    required this.insuranceClaimAmount,
    required this.notes,
    required this.createdBy,
    required this.billingDetails,
    required this.payments,
  });

  factory BillingModel.fromJson(Map<String, dynamic> json) {
    return BillingModel(
      billId: json['billId'] as int,
      patientId: json['patientId'] as int,
      billDate: DateTime.parse(json['billDate'] as String),
      dueDate: DateTime.parse(json['dueDate'] as String),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      paidAmount: (json['paidAmount'] as num).toDouble(),
      balance: (json['balance'] as num).toDouble(),
      isPaid: json['isPaid'] as bool,
      status: json['status'] as String,
      insuranceClaimAmount: (json['insuranceClaimAmount'] as num).toDouble(),
      notes: json['notes'] as String,
      createdBy: json['createdBy'] as int,
      billingDetails: (json['billingDetails'] as List)
          .map((detail) => BillingDetail.fromJson(detail))
          .toList(),
      payments: json['payments'] as List<dynamic>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'billId': billId,
      'patientId': patientId,
      'billDate': billDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'totalAmount': totalAmount,
      'paidAmount': paidAmount,
      'balance': balance,
      'isPaid': isPaid,
      'status': status,
      'insuranceClaimAmount': insuranceClaimAmount,
      'notes': notes,
      'createdBy': createdBy,
      'billingDetails': billingDetails.map((detail) => detail.toJson()).toList(),
      'payments': payments,
    };
  }

  BillingModel copyWith({
    int? billId,
    int? patientId,
    DateTime? billDate,
    DateTime? dueDate,
    double? totalAmount,
    double? paidAmount,
    double? balance,
    bool? isPaid,
    String? status,
    double? insuranceClaimAmount,
    String? notes,
    int? createdBy,
    List<BillingDetail>? billingDetails,
    List<dynamic>? payments,
  }) {
    return BillingModel(
      billId: billId ?? this.billId,
      patientId: patientId ?? this.patientId,
      billDate: billDate ?? this.billDate,
      dueDate: dueDate ?? this.dueDate,
      totalAmount: totalAmount ?? this.totalAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      balance: balance ?? this.balance,
      isPaid: isPaid ?? this.isPaid,
      status: status ?? this.status,
      insuranceClaimAmount: insuranceClaimAmount ?? this.insuranceClaimAmount,
      notes: notes ?? this.notes,
      createdBy: createdBy ?? this.createdBy,
      billingDetails: billingDetails ?? this.billingDetails,
      payments: payments ?? this.payments,
    );
  }

  @override
  String toString() {
    return 'BillingModel(billId: $billId, patientId: $patientId, billDate: $billDate, dueDate: $dueDate, totalAmount: $totalAmount, paidAmount: $paidAmount, balance: $balance, isPaid: $isPaid, status: $status, insuranceClaimAmount: $insuranceClaimAmount, notes: $notes, createdBy: $createdBy, billingDetails: $billingDetails, payments: $payments)';
  }
}

class BillingDetail {
  final int billingDetailId;
  final int billId;
  final String itemType;
  final int itemId;
  final String description;
  final int quantity;
  final double unitPrice;
  final double amount;
  final double discount;
  final double taxAmount;

  BillingDetail({
    required this.billingDetailId,
    required this.billId,
    required this.itemType,
    required this.itemId,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.amount,
    required this.discount,
    required this.taxAmount,
  });

  factory BillingDetail.fromJson(Map<String, dynamic> json) {
    return BillingDetail(
      billingDetailId: json['billingDetailId'] as int,
      billId: json['billId'] as int,
      itemType: json['itemType'] as String,
      itemId: json['itemId'] as int,
      description: json['description'] as String,
      quantity: json['quantity'] as int,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      amount: (json['amount'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      taxAmount: (json['taxAmount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'billingDetailId': billingDetailId,
      'billId': billId,
      'itemType': itemType,
      'itemId': itemId,
      'description': description,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'amount': amount,
      'discount': discount,
      'taxAmount': taxAmount,
    };
  }

  BillingDetail copyWith({
    int? billingDetailId,
    int? billId,
    String? itemType,
    int? itemId,
    String? description,
    int? quantity,
    double? unitPrice,
    double? amount,
    double? discount,
    double? taxAmount,
  }) {
    return BillingDetail(
      billingDetailId: billingDetailId ?? this.billingDetailId,
      billId: billId ?? this.billId,
      itemType: itemType ?? this.itemType,
      itemId: itemId ?? this.itemId,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      amount: amount ?? this.amount,
      discount: discount ?? this.discount,
      taxAmount: taxAmount ?? this.taxAmount,
    );
  }

  @override
  String toString() {
    return 'BillingDetail(billingDetailId: $billingDetailId, billId: $billId, itemType: $itemType, itemId: $itemId, description: $description, quantity: $quantity, unitPrice: $unitPrice, amount: $amount, discount: $discount, taxAmount: $taxAmount)';
  }
}