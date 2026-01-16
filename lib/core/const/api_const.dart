class ApiConst {
  static final String BASE_URL = "http://10.0.2.2:5014";
  static final String Register = "$BASE_URL/api/Auth/login";
  static final String Login = "$BASE_URL/api/Auth/login";
  static final String get_appointments = "$BASE_URL/api/Appointments/patient/";
  static final String get_appointment_details = "$BASE_URL/api/Appointments/";
  static final String get_patients_profile = "$BASE_URL/api/Patients/";
  static final String get_patients_medical_records = "$BASE_URL/api/MedicalRecords/patient/";
  static final String get_patients_billing = "$BASE_URL/api/Billing/patient/";
  static final String get_patients_Lab_orders = "$BASE_URL/api/LabOrders/patient/";
  static final String get_inventory = "$BASE_URL/api/Inventory";
  static final String get_rooms = "$BASE_URL/api/Rooms";

}
