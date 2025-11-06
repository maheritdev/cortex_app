import 'package:cortex/feature/laborders/data/lab_orders.dart';

class LabOrdersState {}


class OnInitialLabOrdersState extends LabOrdersState {}

class OnLoadingLabOrdersState extends LabOrdersState {}

class OnLoadedLabOrdersState extends LabOrdersState {
  final List<LabOrders> labOrders ; // Remove nullable operator
  OnLoadedLabOrdersState({required this.labOrders});
}

class OnErrorLabOrdersState extends LabOrdersState {
  final String errorMessage;
  OnErrorLabOrdersState(this.errorMessage);
}