class PatientModel {
  final String token;
  final DateTime expiresAt;
  final Patient patient;
  final String userType;

  PatientModel({
    required this.token,
    required this.expiresAt,
    required this.patient,
    required this.userType,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      token: json['token'],
      expiresAt: DateTime.parse(json['expiresAt']),
      patient: Patient.fromJson(json['patient']),
      userType: json['userType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'expiresAt': expiresAt.toIso8601String(),
      'patient': patient.toJson(),
      'userType': userType,
    };
  }
}

class Patient {
  final int patientID;
  final String firstName;
  final String lastName;
  final String contactNumber;
  final String email;
  final String address;
  final String medicalHistory;
  final List<dynamic> admissions;
  final List<dynamic> appointments;
  final List<dynamic> billings;
  final List<dynamic> labOrders;
  final List<dynamic> medicalRecords;
  final List<dynamic> payments;
  final List<dynamic> prescriptions;
  final List<dynamic> user;

  Patient({
    required this.patientID,
    required this.firstName,
    required this.lastName,
    required this.contactNumber,
    required this.email,
    required this.address,
    required this.medicalHistory,
    required this.admissions,
    required this.appointments,
    required this.billings,
    required this.labOrders,
    required this.medicalRecords,
    required this.payments,
    required this.prescriptions,
    required this.user,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      patientID: json['patientID'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      contactNumber: json['contactNumber'],
      email: json['email'],
      address: json['address'],
      medicalHistory: json['medicalHistory'],
      admissions: List<dynamic>.from(json['admissions']),
      appointments: List<dynamic>.from(json['appointments']),
      billings: List<dynamic>.from(json['billings']),
      labOrders: List<dynamic>.from(json['labOrders']),
      medicalRecords: List<dynamic>.from(json['medicalRecords']),
      payments: List<dynamic>.from(json['payments']),
      prescriptions: List<dynamic>.from(json['prescriptions']),
      user: List<dynamic>.from(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patientID': patientID,
      'firstName': firstName,
      'lastName': lastName,
      'contactNumber': contactNumber,
      'email': email,
      'address': address,
      'medicalHistory': medicalHistory,
      'admissions': admissions,
      'appointments': appointments,
      'billings': billings,
      'labOrders': labOrders,
      'medicalRecords': medicalRecords,
      'payments': payments,
      'prescriptions': prescriptions,
      'user': user,
    };
  }
}