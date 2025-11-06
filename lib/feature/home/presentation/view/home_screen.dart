 import 'package:cortex/core/const/colors.dart';
import 'package:cortex/feature/appointment/presentation/view/appointment_screen.dart';
import 'package:cortex/feature/billing/presentation/view/billing_screen.dart';
import 'package:cortex/feature/laborders/presentation/view/lab_orders_screen.dart';
import 'package:cortex/feature/medicalrecord/presentation/view/medecal_records_screen.dart';
import 'package:cortex/feature/pharmacy/presentation/view/inventory_screen.dart';
import 'package:cortex/feature/rooms/presentation/view/rooms_screen.dart';
import 'package:flutter/material.dart';

import '../../data/management_item_model.dart';

class HomeScreen extends StatelessWidget {
   HomeScreen({super.key});

   List<ManagementItem> managementItems = ManagementItem.managementItems;

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       body: ListView.builder(
         itemCount: managementItems.length,
         itemBuilder: (context, index) {
           final item = managementItems[index];
           return Container(
             margin: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
             decoration: BoxDecoration(
               gradient: LinearGradient(
                 colors: [
                   item.color.withOpacity(0.05),
                   item.color.withOpacity(0.1),
                 ],
                 begin: Alignment.centerLeft,
                 end: Alignment.centerRight,
               ),
               borderRadius: BorderRadius.circular(15),
               border: Border.all(color: item.color.withOpacity(0.2), width: 1),
             ),
             child: ListTile(
               contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
               leading: CircleAvatar(
                 backgroundColor: item.color.withOpacity(0.1),
                 radius: 25,
                 child: Icon(
                   item.icon,
                   color: item.color,
                   size: 24,
                 ),
               ),
               title: Text(
                 item.title,
                 style: TextStyle(
                   fontSize: 17,
                   fontWeight: FontWeight.w600,
                   color: Colors.grey[800],
                 ),
               ),
               subtitle: Padding(
                 padding: EdgeInsets.only(top: 4),
                 child: Text(
                   item.description,
                   style: TextStyle(
                     fontSize: 14,
                     color: Colors.grey[600],
                   ),
                 ),
               ),
               trailing: Container(
                 padding: EdgeInsets.all(8),
                 decoration: BoxDecoration(
                   color: item.color.withOpacity(0.1),
                   shape: BoxShape.circle,
                 ),
                 child: Icon(
                   Icons.arrow_forward,
                   size: 16,
                   color: item.color,
                 ),
               ),
               onTap: () {
                 switch (item.title) {
                   case 'Appointments':
                     Navigator.of(context).push(
                       MaterialPageRoute<void>(
                         builder: (context) =>  AppointmentScreen(),
                       ),
                     );
                     case 'Billing':
                     Navigator.of(context).push(
                       MaterialPageRoute<void>(
                         builder: (context) =>  BillingScreen(),
                       ),
                     );
                     case 'Medical Records':
                     Navigator.of(context).push(
                       MaterialPageRoute<void>(
                         builder: (context) =>  MedecalRecordsScreen(),
                       ),
                     );
                     case 'Pharmacy':
                     Navigator.of(context).push(
                       MaterialPageRoute<void>(
                         builder: (context) =>  InventoryScreen(),
                       ),
                     );
                     case 'Laboratory':
                     Navigator.of(context).push(
                       MaterialPageRoute<void>(
                         builder: (context) =>  LabOrdersScreen(),
                       ),
                     );
                     case 'Room Management':
                     Navigator.of(context).push(
                       MaterialPageRoute<void>(
                         builder: (context) =>  RoomsScreen(),
                       ),
                     );
                 }
                 print('Navigating to ${item.title}');
               },
             ),
           );
         },
       )
     );
   }
}
