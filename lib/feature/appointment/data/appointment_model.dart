class AppointmentModel {
  final int appointmentId;
  final int patientId;
  final int doctorId;
  final DateTime appointmentDate;
  final String reason;
  final String status;
  final String notes;
  final DateTime createdDate;
  final int createdBy;
  final Doctor doctor;
  final DateTime startTime;
  final DateTime endTime;

  AppointmentModel({
    required this.appointmentId,
    required this.patientId,
    required this.doctorId,
    required this.appointmentDate,
    required this.reason,
    required this.status,
    required this.notes,
    required this.createdDate,
    required this.createdBy,
    required this.doctor,
    required this.startTime,
    required this.endTime,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      appointmentId: json['appointmentId'] as int,
      patientId: json['patientId'] as int,
      doctorId: json['doctorId'] as int,
      appointmentDate: DateTime.parse(json['appointmentDate'] as String),
      reason: json['reason'] as String,
      status: json['status'] as String,
      notes: json['notes'] as String,
      createdDate: DateTime.parse(json['createdDate'] as String),
      createdBy: json['createdBy'] as int,
      doctor: Doctor.fromJson(json['doctor'] as Map<String, dynamic>),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointmentId': appointmentId,
      'patientId': patientId,
      'doctorId': doctorId,
      'appointmentDate': appointmentDate.toIso8601String(),
      'reason': reason,
      'status': status,
      'notes': notes,
      'createdDate': createdDate.toIso8601String(),
      'createdBy': createdBy,
      'doctor': doctor.toJson(),
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'AppointmentModel(appointmentId: $appointmentId, patientId: $patientId, doctorId: $doctorId, appointmentDate: $appointmentDate, reason: $reason, status: $status, startTime: $startTime, endTime: $endTime)';
  }
}

class Doctor {
  final int staffID;
  final String firstName;
  final String lastName;
  final String gender;
  final DateTime dateOfBirth;
  final String contactNumber;
  final String email;
  final String address;
  final int departmentId;
  final String position;
  final String specialization;
  final String qualification;
  final DateTime hireDate;
  final double salary;
  final String status;
  final String username;
  final String passwordHash;
  final String role;
  final List<dynamic> admissions;
  final List<dynamic> appointmentCreatedByNavigations;
  final List<dynamic> appointmentDoctors;
  final List<dynamic> auditLogs;
  final List<dynamic> billings;
  final List<dynamic> departments;
  final List<dynamic> inventoryTransactions;
  final List<dynamic> labOrderDetailPerformedByNavigations;
  final List<dynamic> labOrderDetailVerifiedByNavigations;
  final List<dynamic> labOrders;
  final List<dynamic> medicalRecordDoctors;
  final List<dynamic> medicalRecordRecordedByNavigations;
  final List<dynamic> payments;
  final List<dynamic> prescriptions;
  final List<dynamic> user;

  Doctor({
    required this.staffID,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.dateOfBirth,
    required this.contactNumber,
    required this.email,
    required this.address,
    required this.departmentId,
    required this.position,
    required this.specialization,
    required this.qualification,
    required this.hireDate,
    required this.salary,
    required this.status,
    required this.username,
    required this.passwordHash,
    required this.role,
    required this.admissions,
    required this.appointmentCreatedByNavigations,
    required this.appointmentDoctors,
    required this.auditLogs,
    required this.billings,
    required this.departments,
    required this.inventoryTransactions,
    required this.labOrderDetailPerformedByNavigations,
    required this.labOrderDetailVerifiedByNavigations,
    required this.labOrders,
    required this.medicalRecordDoctors,
    required this.medicalRecordRecordedByNavigations,
    required this.payments,
    required this.prescriptions,
    required this.user,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      staffID: json['staffID'] as int,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      gender: json['gender'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      contactNumber: json['contactNumber'] as String,
      email: json['email'] as String,
      address: json['address'] as String,
      departmentId: json['departmentId'] as int,
      position: json['position'] as String,
      specialization: json['specialization'] as String,
      qualification: json['qualification'] as String,
      hireDate: DateTime.parse(json['hireDate'] as String),
      salary: json['salary'] as double,
      status: json['status'] as String,
      username: json['username'] as String,
      passwordHash: json['passwordHash'] as String,
      role: json['role'] as String,
      admissions: json['admissions'] as List<dynamic>,
      appointmentCreatedByNavigations: json['appointmentCreatedByNavigations'] as List<dynamic>,
      appointmentDoctors: json['appointmentDoctors'] as List<dynamic>,
      auditLogs: json['auditLogs'] as List<dynamic>,
      billings: json['billings'] as List<dynamic>,
      departments: json['departments'] as List<dynamic>,
      inventoryTransactions: json['inventoryTransactions'] as List<dynamic>,
      labOrderDetailPerformedByNavigations: json['labOrderDetailPerformedByNavigations'] as List<dynamic>,
      labOrderDetailVerifiedByNavigations: json['labOrderDetailVerifiedByNavigations'] as List<dynamic>,
      labOrders: json['labOrders'] as List<dynamic>,
      medicalRecordDoctors: json['medicalRecordDoctors'] as List<dynamic>,
      medicalRecordRecordedByNavigations: json['medicalRecordRecordedByNavigations'] as List<dynamic>,
      payments: json['payments'] as List<dynamic>,
      prescriptions: json['prescriptions'] as List<dynamic>,
      user: json['user'] as List<dynamic>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'staffID': staffID,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'contactNumber': contactNumber,
      'email': email,
      'address': address,
      'departmentId': departmentId,
      'position': position,
      'specialization': specialization,
      'qualification': qualification,
      'hireDate': hireDate.toIso8601String(),
      'salary': salary,
      'status': status,
      'username': username,
      'passwordHash': passwordHash,
      'role': role,
      'admissions': admissions,
      'appointmentCreatedByNavigations': appointmentCreatedByNavigations,
      'appointmentDoctors': appointmentDoctors,
      'auditLogs': auditLogs,
      'billings': billings,
      'departments': departments,
      'inventoryTransactions': inventoryTransactions,
      'labOrderDetailPerformedByNavigations': labOrderDetailPerformedByNavigations,
      'labOrderDetailVerifiedByNavigations': labOrderDetailVerifiedByNavigations,
      'labOrders': labOrders,
      'medicalRecordDoctors': medicalRecordDoctors,
      'medicalRecordRecordedByNavigations': medicalRecordRecordedByNavigations,
      'payments': payments,
      'prescriptions': prescriptions,
      'user': user,
    };
  }

  String get fullName => '$firstName $lastName';

  @override
  String toString() {
    return 'Doctor(staffID: $staffID, name: $fullName, position: $position, specialization: $specialization)';
  }
}

// Helper function to parse a list of appointments
List<AppointmentModel> parseAppointments(List<dynamic> jsonList) {
  return jsonList.map((json) => AppointmentModel.fromJson(json as Map<String, dynamic>)).toList();
}