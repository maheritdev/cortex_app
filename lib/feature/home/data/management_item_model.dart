import 'package:flutter/material.dart';

class ManagementItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  ManagementItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  static List<ManagementItem> managementItems = [
    ManagementItem(
      title: 'Appointments',
      description: 'Schedule and manage patient appointments',
      icon: Icons.calendar_today,
      color: Colors.blue,
    ),
    ManagementItem(
      title: 'Billing',
      description: 'Manage billing, payments and financial records',
      icon: Icons.payment,
      color: Colors.green,
    ),
    ManagementItem(
      title: 'Pharmacy',
      description: 'Manage prescriptions and medications',
      icon: Icons.local_pharmacy,
      color: Colors.orange,
    ),
    ManagementItem(
      title: 'Laboratory',
      description: 'Manage lab tests and orders',
      icon: Icons.science,
      color: Colors.purple,
    ),
    ManagementItem(
      title: 'Room Management',
      description: 'Manage room allocation and availability',
      icon: Icons.meeting_room,
      color: Colors.red,
    ),
    ManagementItem(
      title: 'Medical Records',
      description: 'Manage medical records',
      icon: Icons.document_scanner,
      color: Colors.purpleAccent,
    ),
  ];
}
