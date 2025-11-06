import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/shared_preferences_helper.dart';
import '../../data/profile_model.dart';
import '../cubit/profile_cubit.dart';
import '../state/profile_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    _initPref();
    context.read<ProfileCubit>().getPatientsProfile(
      SharedPreferencesHelper.getInt('patientID'),
    );
  }

  _initPref() {
    SharedPreferencesHelper.init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Scaffold(
          body: state is OnLoadingProfileState
              ? Center(child: CircularProgressIndicator())
              : state is OnLoadedProfileState
              ? CustomScrollView(
                  slivers: [
                    // Header Section
                    SliverAppBar(
                      expandedHeight: 220,
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
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Profile Avatar and Name
                                  Row(
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 3,
                                          ),
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.white.withOpacity(0.3),
                                              Colors.white.withOpacity(0.1),
                                            ],
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${state.profileModel?.firstName?[0] ?? ''}${state.profileModel?.lastName?[0] ?? ''}',
                                            style: TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${state.profileModel?.firstName ?? ''} ${state.profileModel?.lastName ?? ''}',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),

                                            SizedBox(height: 4),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(
                                                  0.2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                state.profileModel?.status
                                                        ?.toUpperCase() ??
                                                    'ACTIVE',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
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

                        // Personal Information Card
                        _buildPersonalInfoCard(state.profileModel!),

                        SizedBox(height: 16),

                        // Contact Information Card
                        _buildContactInfoCard(state.profileModel!),

                        SizedBox(height: 16),

                        // Medical Information Card
                        _buildMedicalInfoCard(state.profileModel!),

                        SizedBox(height: 16),

                        // Emergency Contact Card
                        _buildEmergencyContactCard(state.profileModel!),

                        SizedBox(height: 16),

                        // Insurance Information Card
                        if (state.profileModel?.insuranceProvider != null)
                          _buildInsuranceCard(state.profileModel!),

                        SizedBox(height: 20),
                      ]),
                    ),
                  ],
                )
              : Center(child: Text("No Data ")),
          // Edit Profile Button
        );
      },
      listener: (BuildContext context, ProfileState state) {
        if (state is OnErrorProfileState)
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Something went wrong")));
      },
    );
  }

  Widget _buildPersonalInfoCard(ProfileModel profile) {
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
                  Icon(
                    Icons.person_outline,
                    color: Color(0xFF5B2D98),
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Personal Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5B2D98),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              _buildInfoRow(
                icon: Icons.cake_outlined,
                label: 'Date of Birth',
                value: _formatDate(profile.dateOfBirth) ?? 'Not provided',
              ),
              SizedBox(height: 12),
              _buildInfoRow(
                icon: Icons.male_outlined,
                label: 'Gender',
                value: profile.gender ?? 'Not specified',
              ),
              SizedBox(height: 12),
              _buildInfoRow(
                icon: Icons.bloodtype_outlined,
                label: 'Blood Type',
                value: profile.bloodType ?? 'Not specified',
              ),
              SizedBox(height: 12),
              _buildInfoRow(
                icon: Icons.date_range_outlined,
                label: 'Registration Date',
                value: _formatDate(profile.registrationDate) ?? 'Not available',
              ),
              SizedBox(height: 12),
              _buildInfoRow(
                icon: Icons.medical_services_outlined,
                label: 'Last Visit',
                value: _formatDate(profile.lastVisitDate) ?? 'Never visited',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfoCard(ProfileModel profile) {
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
                  Icon(
                    Icons.contact_phone_outlined,
                    color: Color(0xFF5B2D98),
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Contact Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5B2D98),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              _buildContactRow(
                icon: Icons.phone_iphone_outlined,
                label: 'Primary Contact',
                value: profile.contactNumber ?? 'Not provided',
                isPrimary: true,
              ),
              SizedBox(height: 12),
              if (profile.alternateContact != null) ...[
                _buildContactRow(
                  icon: Icons.phone_outlined,
                  label: 'Alternate Contact',
                  value: profile.alternateContact!,
                  isPrimary: false,
                ),
                SizedBox(height: 12),
              ],
              _buildContactRow(
                icon: Icons.email_outlined,
                label: 'Email Address',
                value: profile.email ?? 'Not provided',
                isPrimary: false,
              ),
              SizedBox(height: 12),
              _buildAddressSection(profile),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMedicalInfoCard(ProfileModel profile) {
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
                  Icon(
                    Icons.medical_information_outlined,
                    color: Color(0xFF5B2D98),
                    size: 24,
                  ),
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
              if (profile.medicalHistory != null &&
                  profile.medicalHistory!.isNotEmpty) ...[
                _buildMedicalSection(
                  title: 'Medical History',
                  content: profile.medicalHistory!,
                ),
                SizedBox(height: 16),
              ],
              if (profile.allergies != null &&
                  profile.allergies!.isNotEmpty) ...[
                _buildMedicalSection(
                  title: 'Allergies',
                  content: profile.allergies!,
                ),
                SizedBox(height: 16),
              ],
              if ((profile.medicalHistory == null ||
                      profile.medicalHistory!.isEmpty) &&
                  (profile.allergies == null ||
                      profile.allergies!.isEmpty)) ...[
                Text(
                  'No medical information available',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencyContactCard(ProfileModel profile) {
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
                  Icon(
                    Icons.emergency_outlined,
                    color: Color(0xFF5B2D98),
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Emergency Contact',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5B2D98),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              if (profile.emergencyContactName != null ||
                  profile.emergencyContactNumber != null) ...[
                _buildEmergencyContactRow(profile),
              ] else ...[
                Text(
                  'No emergency contact information provided',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInsuranceCard(ProfileModel profile) {
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
                  Icon(
                    Icons.health_and_safety_outlined,
                    color: Color(0xFF5B2D98),
                    size: 24,
                  ),
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
              _buildInfoRow(
                icon: Icons.business_center_outlined,
                label: 'Insurance Provider',
                value: profile.insuranceProvider ?? 'Not provided',
              ),
              SizedBox(height: 12),
              _buildInfoRow(
                icon: Icons.credit_card_outlined,
                label: 'Policy Number',
                value: profile.insurancePolicyNumber ?? 'Not provided',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widgets
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
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
                label,
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

  Widget _buildContactRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isPrimary,
  }) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isPrimary
                ? Color(0xFFB983FB).withOpacity(0.2)
                : Color(0xFFB983FB).withOpacity(0.1),
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
                label,
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
        if (isPrimary)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Color(0xFF5B2D98).withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'PRIMARY',
              style: TextStyle(
                fontSize: 10,
                color: Color(0xFF5B2D98),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAddressSection(ProfileModel profile) {
    final addressParts = [
      profile.address,
      profile.city,
      profile.state,
      profile.zipCode,
      profile.country,
    ].where((part) => part != null && part != '').toList();

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
          child: Icon(
            Icons.location_on_outlined,
            size: 18,
            color: Color(0xFF5B2D98),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Address',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2),
              if (addressParts.isNotEmpty)
                Text(
                  addressParts.join(', '),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w600,
                  ),
                )
              else
                Text(
                  'Not provided',
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

  Widget _buildMedicalSection({
    required String title,
    required String content,
  }) {
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
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Text(
            content,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
          ),
        ),
      ],
    );
  }

  Widget _buildEmergencyContactRow(ProfileModel profile) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Color(0xFFFF6B6B).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(Icons.person_outline, size: 20, color: Color(0xFFFF6B6B)),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profile.emergencyContactName ?? 'Emergency Contact',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              SizedBox(height: 4),
              if (profile.emergencyContactNumber != null) ...[
                Row(
                  children: [
                    Icon(
                      Icons.phone_outlined,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    SizedBox(width: 4),
                    Text(
                      profile.emergencyContactNumber!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            // Handle emergency call
          },
          icon: Icon(Icons.phone, color: Color(0xFFFF6B6B)),
        ),
      ],
    );
  }

  // Helper Methods
  String? _formatDate(String? date) {
    if (date == null) return null;
    // Implement your date formatting logic
    return date;
  }
}
