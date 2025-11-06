class LabOrders {
  final int orderId;
  final int patientId;
  final int doctorId;
  final DateTime orderDate;
  final String status;
  final String notes;
  final List<dynamic> labOrderDetails;

  LabOrders({
    required this.orderId,
    required this.patientId,
    required this.doctorId,
    required this.orderDate,
    required this.status,
    required this.notes,
    required this.labOrderDetails,
  });

  factory LabOrders.fromJson(Map<String, dynamic> json) {
    return LabOrders(
      orderId: json['orderId'] as int,
      patientId: json['patientId'] as int,
      doctorId: json['doctorId'] as int,
      orderDate: DateTime.parse(json['orderDate'] as String),
      status: json['status'] as String,
      notes: json['notes'] as String,
      labOrderDetails: json['labOrderDetails'] as List<dynamic>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'patientId': patientId,
      'doctorId': doctorId,
      'orderDate': orderDate.toIso8601String(),
      'status': status,
      'notes': notes,
      'labOrderDetails': labOrderDetails,
    };
  }

  @override
  String toString() {
    return 'LabOrders(orderId: $orderId, patientId: $patientId, doctorId: $doctorId, orderDate: $orderDate, status: $status, notes: $notes, labOrderDetails: $labOrderDetails)';
  }
}