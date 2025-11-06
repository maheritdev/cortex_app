class AppointmentDetailsModel {
  int? appointmentId;
  int? patientId;
  int? doctorId;
  String? appointmentDate;
  String? reason;
  String? status;
  String? notes;
  String? createdDate;
  int? createdBy;
  Doctor? doctor;
  Patient? patient;
  String? startTime;
  String? endTime;

  AppointmentDetailsModel(
      {this.appointmentId,
        this.patientId,
        this.doctorId,
        this.appointmentDate,
        this.reason,
        this.status,
        this.notes,
        this.createdDate,
        this.createdBy,
        this.doctor,
        this.patient,
        this.startTime,
        this.endTime});

  AppointmentDetailsModel.fromJson(Map<String, dynamic> json) {
    appointmentId = json['appointmentId'];
    patientId = json['patientId'];
    doctorId = json['doctorId'];
    appointmentDate = json['appointmentDate'];
    reason = json['reason'];
    status = json['status'];
    notes = json['notes'];
    createdDate = json['createdDate'];
    createdBy = json['createdBy'];
    doctor =
    json['doctor'] != null ? new Doctor.fromJson(json['doctor']) : null;
    patient =
    json['patient'] != null ? new Patient.fromJson(json['patient']) : null;
    startTime = json['startTime'];
    endTime = json['endTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appointmentId'] = this.appointmentId;
    data['patientId'] = this.patientId;
    data['doctorId'] = this.doctorId;
    data['appointmentDate'] = this.appointmentDate;
    data['reason'] = this.reason;
    data['status'] = this.status;
    data['notes'] = this.notes;
    data['createdDate'] = this.createdDate;
    data['createdBy'] = this.createdBy;
    if (this.doctor != null) {
      data['doctor'] = this.doctor!.toJson();
    }
    if (this.patient != null) {
      data['patient'] = this.patient!.toJson();
    }
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    return data;
  }
}

class Doctor {
  int? staffID;
  String? firstName;
  String? lastName;
  String? gender;
  String? dateOfBirth;
  String? contactNumber;
  String? email;
  String? address;
  int? departmentId;
  String? position;
  String? specialization;
  String? qualification;
  String? hireDate;
  double? salary;
  String? status;
  String? username;
  String? passwordHash;
  String? role;

  Doctor(
      {this.staffID,
        this.firstName,
        this.lastName,
        this.gender,
        this.dateOfBirth,
        this.contactNumber,
        this.email,
        this.address,
        this.departmentId,
        this.position,
        this.specialization,
        this.qualification,
        this.hireDate,
        this.salary,
        this.status,
        this.username,
        this.passwordHash,
        this.role});

  Doctor.fromJson(Map<String, dynamic> json) {
    staffID = json['staffID'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    gender = json['gender'];
    dateOfBirth = json['dateOfBirth'];
    contactNumber = json['contactNumber'];
    email = json['email'];
    address = json['address'];
    departmentId = json['departmentId'];
    position = json['position'];
    specialization = json['specialization'];
    qualification = json['qualification'];
    hireDate = json['hireDate'];
    salary = json['salary'];
    status = json['status'];
    username = json['username'];
    passwordHash = json['passwordHash'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['staffID'] = this.staffID;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['gender'] = this.gender;
    data['dateOfBirth'] = this.dateOfBirth;
    data['contactNumber'] = this.contactNumber;
    data['email'] = this.email;
    data['address'] = this.address;
    data['departmentId'] = this.departmentId;
    data['position'] = this.position;
    data['specialization'] = this.specialization;
    data['qualification'] = this.qualification;
    data['hireDate'] = this.hireDate;
    data['salary'] = this.salary;
    data['status'] = this.status;
    data['username'] = this.username;
    data['passwordHash'] = this.passwordHash;
    data['role'] = this.role;
    return data;
  }
}

class Patient {
  int? patientId;
  String? firstName;
  String? lastName;
  String? gender;
  String? dateOfBirth;
  String? bloodType;
  String? contactNumber;
  String? alternateContact;
  String? email;
  String? address;
  String? city;
  String? state;
  String? zipCode;
  String? country;
  String? emergencyContactName;
  String? emergencyContactNumber;
  String? insuranceProvider;
  String? insurancePolicyNumber;
  String? registrationDate;
  String? lastVisitDate;
  String? medicalHistory;
  String? allergies;
  String? status;
  String? username;
  String? passwordHash;

  Patient(
      {this.patientId,
        this.firstName,
        this.lastName,
        this.gender,
        this.dateOfBirth,
        this.bloodType,
        this.contactNumber,
        this.alternateContact,
        this.email,
        this.address,
        this.city,
        this.state,
        this.zipCode,
        this.country,
        this.emergencyContactName,
        this.emergencyContactNumber,
        this.insuranceProvider,
        this.insurancePolicyNumber,
        this.registrationDate,
        this.lastVisitDate,
        this.medicalHistory,
        this.allergies,
        this.status,
        this.username,
        this.passwordHash});

  Patient.fromJson(Map<String, dynamic> json) {
    patientId = json['patientId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    gender = json['gender'];
    dateOfBirth = json['dateOfBirth'];
    bloodType = json['bloodType'];
    contactNumber = json['contactNumber'];
    alternateContact = json['alternateContact'];
    email = json['email'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    zipCode = json['zipCode'];
    country = json['country'];
    emergencyContactName = json['emergencyContactName'];
    emergencyContactNumber = json['emergencyContactNumber'];
    insuranceProvider = json['insuranceProvider'];
    insurancePolicyNumber = json['insurancePolicyNumber'];
    registrationDate = json['registrationDate'];
    lastVisitDate = json['lastVisitDate'];
    medicalHistory = json['medicalHistory'];
    allergies = json['allergies'];
    status = json['status'];
    username = json['username'];
    passwordHash = json['passwordHash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['patientId'] = this.patientId;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['gender'] = this.gender;
    data['dateOfBirth'] = this.dateOfBirth;
    data['bloodType'] = this.bloodType;
    data['contactNumber'] = this.contactNumber;
    data['alternateContact'] = this.alternateContact;
    data['email'] = this.email;
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['zipCode'] = this.zipCode;
    data['country'] = this.country;
    data['emergencyContactName'] = this.emergencyContactName;
    data['emergencyContactNumber'] = this.emergencyContactNumber;
    data['insuranceProvider'] = this.insuranceProvider;
    data['insurancePolicyNumber'] = this.insurancePolicyNumber;
    data['registrationDate'] = this.registrationDate;
    data['lastVisitDate'] = this.lastVisitDate;
    data['medicalHistory'] = this.medicalHistory;
    data['allergies'] = this.allergies;
    data['status'] = this.status;
    data['username'] = this.username;
    data['passwordHash'] = this.passwordHash;
    return data;
  }
}
