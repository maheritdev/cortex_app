 import 'package:cortex/feature/laborders/presentation/cubit/lab_orders_cubit.dart';
import 'package:cortex/feature/laborders/presentation/state/lab_orders_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/shared_preferences_helper.dart';
import '../../data/lab_orders.dart';

class LabOrdersScreen extends StatefulWidget {
   const LabOrdersScreen({super.key});

   @override
   State<LabOrdersScreen> createState() => _LabOrdersScreenState();
 }

 class _LabOrdersScreenState extends State<LabOrdersScreen> {
   @override
   void initState() {
     super.initState();
     _initPref();
     context.read<LabOrdersCubit>().getLabOrders(
       SharedPreferencesHelper.getInt('patientID'),
     );
   }

   _initPref() {
     SharedPreferencesHelper.init();
   }

     @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: const Text('Lab Orders'),
         backgroundColor: Colors.blue,
         foregroundColor: Colors.white,
       ),
       body: BlocConsumer<LabOrdersCubit, LabOrdersState>(
         builder: (context, state) {
           if (state is OnLoadingLabOrdersState) {
             return const Center(
               child: CircularProgressIndicator(),
             );
           } else if (state is OnLoadedLabOrdersState) {
             return _buildLabOrdersList(state.labOrders);
           } else if (state is OnErrorLabOrdersState) {
             return _buildErrorState(state.errorMessage);
           } else {
             return _buildInitialState();
           }
         },
         listener: (BuildContext context, LabOrdersState state) {
           if (state is OnErrorLabOrdersState) {
             ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(
                 content: Text(state.errorMessage),
                 backgroundColor: Colors.red,
               ),
             );
           }
       
           // You can add more listeners for other state changes
           if (state is OnLoadedLabOrdersState) {
             // Optional: Show success message or perform other actions
             if (state.labOrders.isEmpty) {
               ScaffoldMessenger.of(context).showSnackBar(
                 const SnackBar(
                   content: Text('No lab orders found'),
                 ),
               );
             }
           }
         },
       ),
     );
     }

   Widget _buildInitialState() {
     return const Center(
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           Icon(Icons.medical_services, size: 64, color: Colors.grey),
           SizedBox(height: 16),
           Text(
             'No lab orders loaded',
             style: TextStyle(fontSize: 16, color: Colors.grey),
           ),
         ],
       ),
     );
   }

   Widget _buildErrorState(String message) {
     return Center(
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           const Icon(Icons.error_outline, size: 64, color: Colors.red),
           const SizedBox(height: 16),
           Text(
             'Error loading lab orders',
             style: TextStyle(fontSize: 16, color: Colors.red[700]),
           ),
           const SizedBox(height: 8),
           Text(
             message,
             textAlign: TextAlign.center,
             style: const TextStyle(fontSize: 14, color: Colors.grey),
           ),
         ],
       ),
     );
   }

   Widget _buildLabOrdersList(List<LabOrders> labOrders) {
     if (labOrders.isEmpty) {
       return const Center(
         child: Text(
           'No lab orders available',
           style: TextStyle(fontSize: 16, color: Colors.grey),
         ),
       );
     }

     return ListView.builder(
       itemCount: labOrders.length,
       padding: const EdgeInsets.all(16),
       itemBuilder: (context, index) {
         final order = labOrders[index];
         return _buildLabOrderCard(order);
       },
     );
   }

   Widget _buildLabOrderCard(LabOrders order) {
     return Card(
       elevation: 2,
       margin: const EdgeInsets.only(bottom: 12),
       child: Padding(
         padding: const EdgeInsets.all(16),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Text(
                   'Order #${order.orderId}',
                   style: const TextStyle(
                     fontSize: 16,
                     fontWeight: FontWeight.bold,
                     color: Colors.blue,
                   ),
                 ),
                 _buildStatusChip(order.status),
               ],
             ),
             const SizedBox(height: 8),
             _buildInfoRow('Patient ID:', order.patientId.toString()),
             _buildInfoRow('Doctor ID:', order.doctorId.toString()),
             _buildInfoRow('Order Date:', _formatDate(order.orderDate)),
             if (order.notes.isNotEmpty) ...[
               const SizedBox(height: 8),
               const Text(
                 'Notes:',
                 style: TextStyle(
                   fontWeight: FontWeight.bold,
                   fontSize: 14,
                 ),
               ),
               const SizedBox(height: 4),
               Text(
                 order.notes,
                 style: const TextStyle(fontSize: 14, color: Colors.grey),
               ),
             ],
             const SizedBox(height: 8),
             _buildDetailsSection(order.labOrderDetails),
           ],
         ),
       ),
     );
   }

   Widget _buildInfoRow(String label, String value) {
     return Padding(
       padding: const EdgeInsets.symmetric(vertical: 2),
       child: Row(
         children: [
           Text(
             label,
             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
           ),
           const SizedBox(width: 8),
           Text(
             value,
             style: const TextStyle(fontSize: 14),
           ),
         ],
       ),
     );
   }

   Widget _buildStatusChip(String status) {
     Color backgroundColor;
     Color textColor;

     switch (status.toLowerCase()) {
       case 'completed':
         backgroundColor = Colors.green;
         textColor = Colors.white;
         break;
       case 'in progress':
         backgroundColor = Colors.orange;
         textColor = Colors.white;
         break;
       case 'pending':
         backgroundColor = Colors.yellow;
         textColor = Colors.black;
         break;
       case 'cancelled':
         backgroundColor = Colors.red;
         textColor = Colors.white;
         break;
       default:
         backgroundColor = Colors.grey;
         textColor = Colors.white;
     }

     return Chip(
       label: Text(
         status,
         style: TextStyle(
           fontSize: 12,
           fontWeight: FontWeight.bold,
           color: textColor,
         ),
       ),
       backgroundColor: backgroundColor,
       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
       visualDensity: VisualDensity.compact,
     );
   }

   Widget _buildDetailsSection(List<dynamic> labOrderDetails) {
     if (labOrderDetails.isEmpty) {
       return const Row(
         children: [
           Icon(Icons.info_outline, size: 16, color: Colors.grey),
           SizedBox(width: 4),
           Text(
             'No lab order details',
             style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
           ),
         ],
       );
     }

     return Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         const Text(
           'Order Details:',
           style: TextStyle(
             fontWeight: FontWeight.bold,
             fontSize: 14,
           ),
         ),
         const SizedBox(height: 4),
         Text(
           '${labOrderDetails.length} item(s)',
           style: const TextStyle(fontSize: 12, color: Colors.grey),
         ),
       ],
     );
   }

   String _formatDate(DateTime date) {
     return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
   }
 }