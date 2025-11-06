import 'package:flutter/material.dart';

class RoomModel {
  final int roomId;
  final String roomNumber;
  final String roomType;
  final int departmentId;
  final int capacity;
  final String status;
  final double ratePerDay;
  final List<dynamic> admissions;
  //final DepartmentModel department;

  RoomModel({
    required this.roomId,
    required this.roomNumber,
    required this.roomType,
    required this.departmentId,
    required this.capacity,
    required this.status,
    required this.ratePerDay,
    required this.admissions,
    //required this.department,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      roomId: json['roomId'] as int,
      roomNumber: json['roomNumber'] as String,
      roomType: json['roomType'] as String,
      departmentId: json['departmentId'] as int,
      capacity: json['capacity'] as int,
      status: json['status'] as String,
      ratePerDay: (json['ratePerDay'] as num).toDouble(),
      admissions: json['admissions'] as List<dynamic>,
      //department: DepartmentModel.fromJson(json['department'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'roomNumber': roomNumber,
      'roomType': roomType,
      'departmentId': departmentId,
      'capacity': capacity,
      'status': status,
      'ratePerDay': ratePerDay,
      'admissions': admissions,
      //'department': department.toJson(),
    };
  }

  RoomModel copyWith({
    int? roomId,
    String? roomNumber,
    String? roomType,
    int? departmentId,
    int? capacity,
    String? status,
    double? ratePerDay,
    List<dynamic>? admissions,
    DepartmentModel? department,
  }) {
    return RoomModel(
      roomId: roomId ?? this.roomId,
      roomNumber: roomNumber ?? this.roomNumber,
      roomType: roomType ?? this.roomType,
      departmentId: departmentId ?? this.departmentId,
      capacity: capacity ?? this.capacity,
      status: status ?? this.status,
      ratePerDay: ratePerDay ?? this.ratePerDay,
      admissions: admissions ?? this.admissions,
      //department: department ?? this.department,
    );
  }

  @override
  String toString() {
    return 'RoomModel(roomId: $roomId, roomNumber: $roomNumber, roomType: $roomType, status: $status)';
  }

  // Helper methods
  bool get isAvailable => status == 'Available';
  bool get isOccupied => status == 'Occupied';
  bool get isUnderMaintenance => status == 'Maintenance';

  String get formattedRate => '\$$ratePerDay/day';

  String get capacityText {
    if (capacity == 1) return '$capacity person';
    return '$capacity people';
  }

  Color get statusColor {
    switch (status) {
      case 'Available':
        return Colors.green;
      case 'Occupied':
        return Colors.orange;
      case 'Maintenance':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData get statusIcon {
    switch (status) {
      case 'Available':
        return Icons.check_circle_outline;
      case 'Occupied':
        return Icons.person_outline;
      case 'Maintenance':
        return Icons.build_outlined;
      default:
        return Icons.help_outline;
    }
  }
}

class DepartmentModel {
  final int departmentId;
  final String departmentName;
  final String description;
  final String location;
  final String contactNumber;
  final List<RoomModel?> rooms;
  final List<dynamic> staff;

  DepartmentModel({
    required this.departmentId,
    required this.departmentName,
    required this.description,
    required this.location,
    required this.contactNumber,
    required this.rooms,
    required this.staff,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      departmentId: json['departmentId'] as int,
      departmentName: json['departmentName'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      contactNumber: json['contactNumber'] as String,
      rooms: (json['rooms'] as List)
          .map((room) => room != null ? RoomModel.fromJson(room as Map<String, dynamic>) : null)
          .toList(),
      staff: json['staff'] as List<dynamic>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'departmentId': departmentId,
      'departmentName': departmentName,
      'description': description,
      'location': location,
      'contactNumber': contactNumber,
      'rooms': rooms.map((room) => room?.toJson()).toList(),
      'staff': staff,
    };
  }

  // Helper methods
  int get availableRoomsCount => rooms.where((room) => room?.isAvailable == true).length;
  int get totalRoomsCount => rooms.where((room) => room != null).length;

  double get averageRoomRate {
    final validRooms = rooms.where((room) => room != null).cast<RoomModel>();
    if (validRooms.isEmpty) return 0.0;
    final total = validRooms.map((room) => room.ratePerDay).reduce((a, b) => a + b);
    return total / validRooms.length;
  }
}

// Helper functions for parsing lists
List<RoomModel> parseRooms(List<dynamic> jsonList) {
  return jsonList
      .map((room) => RoomModel.fromJson(room as Map<String, dynamic>))
      .toList();
}

List<DepartmentModel> parseDepartments(List<dynamic> jsonList) {
  return jsonList
      .map((dept) => DepartmentModel.fromJson(dept as Map<String, dynamic>))
      .toList();
}

// Extension for additional functionality
extension RoomListExtensions on List<RoomModel> {
  List<RoomModel> get availableRooms => where((room) => room.isAvailable).toList();
  List<RoomModel> get occupiedRooms => where((room) => room.isOccupied).toList();
  List<RoomModel> get maintenanceRooms => where((room) => room.isUnderMaintenance).toList();

  List<RoomModel> filterByType(String roomType) =>
      where((room) => room.roomType == roomType).toList();

  List<RoomModel> filterByDepartment(int departmentId) =>
      where((room) => room.departmentId == departmentId).toList();

  List<RoomModel> filterByCapacity(int minCapacity, [int? maxCapacity]) =>
      where((room) {
        if (maxCapacity != null) {
          return room.capacity >= minCapacity && room.capacity <= maxCapacity;
        }
        return room.capacity >= minCapacity;
      }).toList();

  List<RoomModel> filterByRate(double minRate, [double? maxRate]) =>
      where((room) {
        if (maxRate != null) {
          return room.ratePerDay >= minRate && room.ratePerDay <= maxRate;
        }
        return room.ratePerDay >= minRate;
      }).toList();

  Map<String, List<RoomModel>> groupByType() {
    final Map<String, List<RoomModel>> grouped = {};
    for (final room in this) {
      grouped.putIfAbsent(room.roomType, () => []).add(room);
    }
    return grouped;
  }

  Map<String, List<RoomModel>> groupByStatus() {
    final Map<String, List<RoomModel>> grouped = {};
    for (final room in this) {
      grouped.putIfAbsent(room.status, () => []).add(room);
    }
    return grouped;
  }

  Map<int, List<RoomModel>> groupByDepartment() {
    final Map<int, List<RoomModel>> grouped = {};
    for (final room in this) {
      grouped.putIfAbsent(room.departmentId, () => []).add(room);
    }
    return grouped;
  }
}

// Room type constants for better type safety
class RoomTypes {
  static const String private = 'Private Room';
  static const String semiPrivate = 'Semi-Private';
  static const String intensiveCare = 'Intensive Care';
  static const String pediatricPrivate = 'Pediatric Private';
  static const String pediatricShared = 'Pediatric Shared';
  static const String orthopedicPrivate = 'Orthopedic Private';
  static const String emergencyBay = 'Emergency Bay';
}

class RoomStatus {
  static const String available = 'Available';
  static const String occupied = 'Occupied';
  static const String maintenance = 'Maintenance';
}