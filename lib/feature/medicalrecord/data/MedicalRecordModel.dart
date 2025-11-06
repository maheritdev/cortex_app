class MedicalRecordModel {
  final int recordId;
  final int patientId;
  final int doctorId;
  final DateTime visitDate;
  final String diagnosis;
  final String treatment;
  final String prescription;
  final String notes;
  final DateTime? followUpDate;
  final int recordedBy;
  final DateTime recordedDate;
  final DoctorModel doctor;
  final List<PrescriptionModel> prescriptions;
  final DoctorModel recordedByNavigation;
  final DateTime createdAt;

  MedicalRecordModel({
    required this.recordId,
    required this.patientId,
    required this.doctorId,
    required this.visitDate,
    required this.diagnosis,
    required this.treatment,
    required this.prescription,
    required this.notes,
    required this.followUpDate,
    required this.recordedBy,
    required this.recordedDate,
    required this.doctor,
    required this.prescriptions,
    required this.recordedByNavigation,
    required this.createdAt,
  });

  factory MedicalRecordModel.fromJson(Map<String, dynamic> json) {
    return MedicalRecordModel(
      recordId: json['recordId'] as int,
      patientId: json['patientId'] as int,
      doctorId: json['doctorId'] as int,
      visitDate: DateTime.parse(json['visitDate'] as String),
      diagnosis: json['diagnosis'] as String,
      treatment: json['treatment'] as String,
      prescription: json['prescription'] as String,
      notes: json['notes'] as String,
      followUpDate: json['followUpDate'] != null
          ? DateTime.parse(json['followUpDate'] as String)
          : null,
      recordedBy: json['recordedBy'] as int,
      recordedDate: DateTime.parse(json['recordedDate'] as String),
      doctor: DoctorModel.fromJson(json['doctor'] as Map<String, dynamic>),
      prescriptions: (json['prescriptions'] as List)
          .map((prescription) => PrescriptionModel.fromJson(prescription as Map<String, dynamic>))
          .toList(),
      recordedByNavigation: DoctorModel.fromJson(json['recordedByNavigation'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recordId': recordId,
      'patientId': patientId,
      'doctorId': doctorId,
      'visitDate': visitDate.toIso8601String(),
      'diagnosis': diagnosis,
      'treatment': treatment,
      'prescription': prescription,
      'notes': notes,
      'followUpDate': followUpDate?.toIso8601String(),
      'recordedBy': recordedBy,
      'recordedDate': recordedDate.toIso8601String(),
      'doctor': doctor.toJson(),
      'prescriptions': prescriptions.map((prescription) => prescription.toJson()).toList(),
      'recordedByNavigation': recordedByNavigation.toJson(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  MedicalRecordModel copyWith({
    int? recordId,
    int? patientId,
    int? doctorId,
    DateTime? visitDate,
    String? diagnosis,
    String? treatment,
    String? prescription,
    String? notes,
    DateTime? followUpDate,
    int? recordedBy,
    DateTime? recordedDate,
    DoctorModel? doctor,
    List<PrescriptionModel>? prescriptions,
    DoctorModel? recordedByNavigation,
    DateTime? createdAt,
  }) {
    return MedicalRecordModel(
      recordId: recordId ?? this.recordId,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      visitDate: visitDate ?? this.visitDate,
      diagnosis: diagnosis ?? this.diagnosis,
      treatment: treatment ?? this.treatment,
      prescription: prescription ?? this.prescription,
      notes: notes ?? this.notes,
      followUpDate: followUpDate ?? this.followUpDate,
      recordedBy: recordedBy ?? this.recordedBy,
      recordedDate: recordedDate ?? this.recordedDate,
      doctor: doctor ?? this.doctor,
      prescriptions: prescriptions ?? this.prescriptions,
      recordedByNavigation: recordedByNavigation ?? this.recordedByNavigation,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'MedicalRecordModel(recordId: $recordId, patientId: $patientId, diagnosis: $diagnosis, visitDate: $visitDate)';
  }
}

class DoctorModel {
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
  final String qualification;
  final DateTime hireDate;
  final double salary;
  final String status;
  final String username;
  final String passwordHash;
  final String role;

  DoctorModel({
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
    required this.qualification,
    required this.hireDate,
    required this.salary,
    required this.status,
    required this.username,
    required this.passwordHash,
    required this.role,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
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
      qualification: json['qualification'] as String,
      hireDate: DateTime.parse(json['hireDate'] as String),
      salary: (json['salary'] as num).toDouble(),
      status: json['status'] as String,
      username: json['username'] as String,
      passwordHash: json['passwordHash'] as String,
      role: json['role'] as String,
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
      'qualification': qualification,
      'hireDate': hireDate.toIso8601String(),
      'salary': salary,
      'status': status,
      'username': username,
      'passwordHash': passwordHash,
      'role': role,
    };
  }

  String get fullName => '$firstName $lastName';
}

class PrescriptionModel {
  final int prescriptionId;
  final int recordId;
  final int patientId;
  final int doctorId;
  final DateTime prescriptionDate;
  final String status;
  final String notes;
  final int quantity;
  final int medicationId;
  final List<dynamic> prescriptionDetails;
  final DateTime issuedAt;

  PrescriptionModel({
    required this.prescriptionId,
    required this.recordId,
    required this.patientId,
    required this.doctorId,
    required this.prescriptionDate,
    required this.status,
    required this.notes,
    required this.quantity,
    required this.medicationId,
    required this.prescriptionDetails,
    required this.issuedAt,
  });

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionModel(
      prescriptionId: json['prescriptionId'] as int,
      recordId: json['recordId'] as int,
      patientId: json['patientId'] as int,
      doctorId: json['doctorId'] as int,
      prescriptionDate: DateTime.parse(json['prescriptionDate'] as String),
      status: json['status'] as String,
      notes: json['notes'] as String,
      quantity: json['quantity'] as int,
      medicationId: json['medicationId'] as int,
      prescriptionDetails: json['prescriptionDetails'] as List<dynamic>,
      issuedAt: DateTime.parse(json['issuedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prescriptionId': prescriptionId,
      'recordId': recordId,
      'patientId': patientId,
      'doctorId': doctorId,
      'prescriptionDate': prescriptionDate.toIso8601String(),
      'status': status,
      'notes': notes,
      'quantity': quantity,
      'medicationId': medicationId,
      'prescriptionDetails': prescriptionDetails,
      'issuedAt': issuedAt.toIso8601String(),
    };
  }
}

// Helper function to parse list of medical records
List<MedicalRecordModel> parseMedicalRecords(List<dynamic> jsonList) {
  return jsonList
      .map((record) => MedicalRecordModel.fromJson(record as Map<String, dynamic>))
      .toList();
}