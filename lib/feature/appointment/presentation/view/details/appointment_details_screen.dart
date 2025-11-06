import 'package:cortex/feature/appointment/data/appointment_details_model.dart';
import 'package:cortex/feature/appointment/presentation/cubit/appointment_details_cubit.dart';
import 'package:cortex/feature/appointment/presentation/state/appointment_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/const/colors.dart';
import '../../../../../core/utils/shared_preferences_helper.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  int id;
  String name;
   AppointmentDetailsScreen({super.key, required this.id, required this.name});

  @override
  State<AppointmentDetailsScreen> createState() => _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initPref();
    context.read<AppointmentDetailsCubit>().getAppointmentDetails(widget.id);
  }
  _initPref(){
    SharedPreferencesHelper.init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppointmentDetailsCubit,AppointmentDetailsState>(
        builder: (context,state){
          return Scaffold(
              backgroundColor: Colors.white,
              body: state is OnLoadingAppointmentDetailsState
              ? Center(child: CircularProgressIndicator())
              : state is OnLoadedAppointmentDetailsState
              ? state.appointmentDetailsModel != null
              ? CustomScrollView(
          slivers: [
            // Header Section
            SliverAppBar(
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF5B2D98), Color(0xFFB983FB)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Appointment Details',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Content Section
          SliverList(
          delegate: SliverChildListDelegate([
          SizedBox(height: 20),

          // Status Card
          _buildStatusCard(state.appointmentDetailsModel!),

          SizedBox(height: 20),

          // Doctor & Patient Info
          Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
          children: [
          Expanded(child: _buildDoctorCard(state.appointmentDetailsModel!)),
          SizedBox(width: 12),
          Expanded(child: _buildPatientCard(state.appointmentDetailsModel!)),
          ],
          ),
          ),

          SizedBox(height: 20),

          // Appointment Details
          _buildDetailsCard(state.appointmentDetailsModel!),

          SizedBox(height: 20),

          // Medical Information
          if (state.appointmentDetailsModel?.patient?.medicalHistory != null ||
          state.appointmentDetailsModel?.patient?.allergies != null)
          _buildMedicalInfoCard(state.appointmentDetailsModel!),

          SizedBox(height: 20),

          // Insurance Information
          if (state.appointmentDetailsModel?.patient?.insuranceProvider != null)
          _buildInsuranceCard(state.appointmentDetailsModel),

          SizedBox(height: 40),
          ]),
          ),
          ],
          )
              : Center(child: Text("No Data "))
              : Center(child: Text("No Data "))
          );
        },
        listener: (BuildContext context, AppointmentDetailsState state) {

        }
    );
  }

  Widget _buildStatusCard(AppointmentDetailsModel appointment) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _getStatusGradient(appointment.status),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.calendar_today, color: Colors.white, size: 20),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Appointment Status',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      appointment.status?.toUpperCase() ?? 'UNKNOWN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _formatDate(appointment.appointmentDate ?? ''),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorCard(AppointmentDetailsModel appointment) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Color(0xFFB983FB).withOpacity(0.2), width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF5B2D98), Color(0xFFB983FB)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${appointment.doctor?.firstName?[0] ?? 'D'}${appointment.doctor?.lastName?[0] ?? 'R'}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dr. ${appointment.doctor?.firstName ?? ''} ${appointment.doctor?.lastName ?? ''}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5B2D98),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        appointment.doctor?.specialization ?? 'General Practitioner',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            _buildInfoRow(Icons.email_outlined, appointment.doctor?.email ?? 'Not provided'),
            SizedBox(height: 8),
            _buildInfoRow(Icons.phone_outlined, appointment.doctor?.contactNumber ?? 'Not provided'),
            SizedBox(height: 8),
            _buildInfoRow(Icons.work_outline, appointment.doctor?.position ?? 'Not specified'),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientCard(AppointmentDetailsModel appointment) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Color(0xFFB983FB).withOpacity(0.2), width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF5B2D98), Color(0xFFB983FB)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(Icons.person_outline, color: Colors.white, size: 20),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${appointment.patient?.firstName ?? ''} ${appointment.patient?.lastName ?? ''}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5B2D98),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Patient',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            _buildInfoRow(Icons.phone_outlined, appointment.patient?.contactNumber ?? 'Not provided'),
            SizedBox(height: 8),
            _buildInfoRow(Icons.cake_outlined,
                _calculateAge(appointment.patient?.dateOfBirth) ?? 'Not provided'),
            SizedBox(height: 8),
            _buildInfoRow(Icons.bloodtype_outlined,
                appointment.patient?.bloodType ?? 'Not specified'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard(AppointmentDetailsModel appointment) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.event_note, color: Color(0xFF5B2D98), size: 24),
                  SizedBox(width: 12),
                  Text(
                    'Appointment Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5B2D98),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              _buildDetailItem(
                icon: Icons.access_time_filled,
                title: 'Time Slot',
                value: '${_formatTime(appointment.startTime ?? '')} - ${_formatTime(appointment.endTime ?? '')}',
              ),
              SizedBox(height: 12),
              _buildDetailItem(
                icon: Icons.medical_services,
                title: 'Reason for Visit',
                value: appointment.reason ?? 'Not specified',
              ),
              if (appointment.notes != null && appointment.notes!.isNotEmpty) ...[
                SizedBox(height: 12),
                _buildDetailItem(
                  icon: Icons.note_alt,
                  title: 'Additional Notes',
                  value: appointment.notes!,
                ),
              ],
              SizedBox(height: 12),
              _buildDetailItem(
                icon: Icons.date_range,
                title: 'Created Date',
                value: _formatDateTime(appointment.createdDate ?? ''),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMedicalInfoCard(AppointmentDetailsModel appointment) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.medical_information, color: Color(0xFF5B2D98), size: 24),
                  SizedBox(width: 12),
                  Text(
                    'Medical Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5B2D98),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              if (appointment.patient?.medicalHistory != null) ...[
                _buildMedicalItem('Medical History', appointment.patient!.medicalHistory!),
                SizedBox(height: 12),
              ],
              if (appointment.patient?.allergies != null) ...[
                _buildMedicalItem('Allergies', appointment.patient!.allergies!),
                SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInsuranceCard(AppointmentDetailsModel? appointment) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.health_and_safety, color: Color(0xFF5B2D98), size: 24),
                  SizedBox(width: 12),
                  Text(
                    'Insurance Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5B2D98),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              _buildDetailItem(
                icon: Icons.business,
                title: 'Provider',
                value: appointment?.patient!.insuranceProvider! ??  'Not provided',
              ),
              SizedBox(height: 12),
              _buildDetailItem(
                icon: Icons.credit_card,
                title: 'Policy Number',
                value: appointment?.patient!.insurancePolicyNumber ?? 'Not provided',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                // Handle reschedule
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Color(0xFF5B2D98),
                side: BorderSide(color: Color(0xFF5B2D98)),
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.schedule, size: 20),
                  SizedBox(width: 8),
                  Text('Reschedule'),
                ],
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // Handle primary action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF5B2D98),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat, size: 20),
                  SizedBox(width: 8),
                  Text('Contact'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widgets
  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Color(0xFFB983FB)),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem({required IconData icon, required String title, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Color(0xFFB983FB).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: Color(0xFF5B2D98)),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMedicalItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF5B2D98),
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  // Helper Methods
  List<Color> _getStatusGradient(String? status) {
    switch (status?.toLowerCase()) {
      case 'confirmed':
        return [Color(0xFF4CAF50), Color(0xFF2E7D32)];
      case 'pending':
        return [Color(0xFFFF9800), Color(0xFFEF6C00)];
      case 'cancelled':
        return [Color(0xFFF44336), Color(0xFFC62828)];
      default:
        return [Color(0xFF5B2D98), Color(0xFFB983FB)];
    }
  }

  String _formatDate(String date) {
    // Implement your date formatting
    return date;
  }

  String _formatTime(String time) {
    // Implement your time formatting
    return time;
  }

  String _formatDateTime(String dateTime) {
    // Implement your date-time formatting
    return dateTime;
  }

  String? _calculateAge(String? dateOfBirth) {
    if (dateOfBirth == null) return null;
    // Implement age calculation
    return 'Unknown';
  }
}
/**
 *
 *
 * BlocConsumer<AppointmentDetailsCubit, AppointmentDetailsState>(
    builder: (context, state) {
    return Scaffold(
    appBar: AppBar(
    title: Text("Appointments", style: TextStyle(color: Colors.white)),
    centerTitle: true,
    backgroundColor: COLORs.TopBGColor,
    ),
    body: state is OnLoadingAppointmentState
    )
    , listener: (BuildContext context, AppointmentDetailsState state) {  });
 */