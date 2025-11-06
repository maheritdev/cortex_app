import 'package:cortex/feature/billing/data/billing_model.dart';

class BillingState {}

class MedicalRecordsState {}

class OnInitialBillingState extends BillingState {}

class OnLoadingBillingState extends BillingState {}

class OnLoadedBillingState extends BillingState {
  final List<BillingModel> billingsModel ; // Remove nullable operator
  OnLoadedBillingState({required this.billingsModel});
}

class OnErrorBillingState extends BillingState {
  final String errorMessage;
  OnErrorBillingState(this.errorMessage);
}