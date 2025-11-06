import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/const/colors.dart';
import '../../../../core/utils/shared_preferences_helper.dart';
import '../cubit/appointment_cubit.dart';
import '../state/appointment_state.dart';
import 'details/appointment_details_screen.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  @override
  void initState() {
    super.initState();
    _initPref();
    context.read<AppointmentCubit>().getAppointments(SharedPreferencesHelper.getInt('patientID'));
  }
  _initPref(){
    SharedPreferencesHelper.init();
  }
// Helper function to format date time
  String _formatDateTime(String dateTimeString) {
    try {
      DateTime dateTime = DateTime.parse(dateTimeString);
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTimeString;
    }
  }

  // Helper function to format time only
  String _formatTime(String dateTimeString) {
    try {
      DateTime dateTime = DateTime.parse(dateTimeString);
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTimeString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppointmentCubit, AppointmentState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Appointments", style: TextStyle(color: Colors.white)),
            centerTitle: true,
            backgroundColor: COLORs.TopBGColor,
          ),
          backgroundColor: Colors.white,
          body: state is OnLoadingAppointmentState
              ? Center(child: CircularProgressIndicator())
              : state is OnLoadedAppointmentState
              ? ListView.builder(
            itemCount: state.appointmentModel?.length ?? 0,
            itemBuilder: (context, index) {
              final appointment = state.appointmentModel![index];
              final doctor = appointment.doctor;

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white,
                          Color(0xFFB983FB).withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Color(0xFFB983FB).withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header with ID and Status
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFF5B2D98), Color(0xFFB983FB)],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '#${appointment?.appointmentId}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: _getStatusGradient(appointment?.status),
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _getStatusColor(appointment?.status).withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  appointment?.status ?? 'Unknown',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 16),

                          // Doctor Information with brand colors
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF5B2D98).withOpacity(0.05),
                                  Color(0xFFB983FB).withOpacity(0.08),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Color(0xFFB983FB).withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [Color(0xFF5B2D98), Color(0xFFB983FB)],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFFB983FB).withOpacity(0.4),
                                        blurRadius: 8,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${doctor.firstName[0]}${doctor.lastName[0]}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Dr. ${doctor.firstName} ${doctor.lastName}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF5B2D98),
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        doctor.specialization ?? 'General Practitioner',
                                        style: TextStyle(
                                          color: Color(0xFF5B2D98).withOpacity(0.7),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(Icons.star, color: Colors.amber, size: 16),
                                          SizedBox(width: 4),
                                          Text(
                                            '4.8',
                                            style: TextStyle(
                                              color: Color(0xFF5B2D98).withOpacity(0.8),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 16),

                          // Appointment Details with brand-colored icons
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Color(0xFFB983FB).withOpacity(0.2),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFFB983FB).withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                _buildDetailRow(
                                  icon: Icons.calendar_month_rounded,
                                  title: 'Date',
                                  value: _formatDateTime(appointment?.appointmentDate.toString() ?? ''),
                                  iconColor: Color(0xFF5B2D98),
                                ),
                                SizedBox(height: 12),
                                _buildDetailRow(
                                  icon: Icons.access_time_filled_rounded,
                                  title: 'Time',
                                  value: '${_formatTime(appointment?.startTime.toString() ?? '')} - ${_formatTime(appointment?.endTime.toString() ?? '')}',
                                  iconColor: Color(0xFFB983FB),
                                ),
                                SizedBox(height: 12),
                                _buildDetailRow(
                                  icon: Icons.medical_services_rounded,
                                  title: 'Reason',
                                  value: appointment?.reason ?? 'No reason provided',
                                  iconColor: Color(0xFF5B2D98),
                                ),
                                if (appointment?.notes != null && appointment?.notes?.isNotEmpty == true) ...[
                                  SizedBox(height: 12),
                                  _buildDetailRow(
                                    icon: Icons.note_alt_rounded,
                                    title: 'Notes',
                                    value: appointment?.notes ?? '',
                                    iconColor: Color(0xFFB983FB),
                                  ),
                                ],
                              ],
                            ),
                          ),

                          SizedBox(height: 20),

                          // Action Buttons with brand gradient
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Color(0xFFB983FB),
                                      width: 1.5,
                                    ),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.white,
                                        Colors.white,
                                      ],
                                    ),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      // Handle reschedule action
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: Color(0xFF5B2D98),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.schedule_rounded, size: 18),
                                        SizedBox(width: 6),
                                        Text(
                                          'Reschedule',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Container(
                                  height: 45,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Color(0xFF5B2D98), Color(0xFFB983FB)],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFFB983FB).withOpacity(0.4),
                                        blurRadius: 8,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute<void>(
                                          builder: (context) =>  AppointmentDetailsScreen(id: appointment.appointmentId,name: appointment.reason,),
                                        ),
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.visibility_rounded, size: 18),
                                        SizedBox(width: 6),
                                        Text(
                                          'Details',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          )
              : Center(child: Text("No Data ")),
        );
      },
      listener: (context, state) {
        if (state is OnErrorAppointmentState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
      },
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: iconColor),
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
                  color: Color(0xFF5B2D98).withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF5B2D98),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Color> _getStatusGradient(String? status) {
    switch (status?.toLowerCase()) {
      case 'confirmed':
        return [Color(0xFF4CAF50), Color(0xFF2E7D32)]; // Green shades
      case 'pending':
        return [Color(0xFFFF9800), Color(0xFFEF6C00)]; // Orange shades
      case 'cancelled':
        return [Color(0xFFF44336), Color(0xFFC62828)]; // Red shades
      default:
        return [Color(0xFF5B2D98), Color(0xFFB983FB)]; // Your brand colors
    }
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'confirmed':
        return Color(0xFF4CAF50);
      case 'pending':
        return Color(0xFFFF9800);
      case 'cancelled':
        return Color(0xFFF44336);
      default:
        return Color(0xFF5B2D98);
    }
  }
}
