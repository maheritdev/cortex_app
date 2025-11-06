class ProfileModel {
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

  ProfileModel(
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
        this.status});

  ProfileModel.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
