import 'package:cortex/feature/medicalrecord/presentation/cubit/medical_records_cubit.dart';
import 'package:cortex/feature/medicalrecord/presentation/state/medical_records_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/shared_preferences_helper.dart';
import '../../../profile/presentation/view/widgets/medical_record_cars.dart';
import '../../../profile/presentation/view/widgets/record_detail_sheet.dart';
import '../../data/MedicalRecordModel.dart';

class MedecalRecordsScreen extends StatefulWidget {
  const MedecalRecordsScreen({super.key});

  @override
  State<MedecalRecordsScreen> createState() => _MedecalRecordsScreenState();
}

class _MedecalRecordsScreenState extends State<MedecalRecordsScreen> {
  @override

  void initState() {
    super.initState();
    _initPref();
    context.read<MedicalRecordsCubit>().getPatientMedicalRecords(
      SharedPreferencesHelper.getInt('patientID'),
    );
  }

  _initPref() {
    SharedPreferencesHelper.init();
  }
  Widget build(BuildContext context) {
    return BlocConsumer<MedicalRecordsCubit, MedicalRecordsState>(
        builder: (context, state) {
          return Scaffold(
              body: state is OnLoadingMedicalRecordsState
                  ? Center(child: CircularProgressIndicator())
                  : state is OnLoadedMedicalRecordsState
              ? CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 200,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        'Medical Records',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.primaryContainer,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Patient Medical History',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${state.medicalRecordModel.length} records found',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  state.medicalRecordModel.isEmpty
                      ? SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.medical_services_outlined,
                            size: 64,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No medical records found',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  )
                      : SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final record = state.medicalRecordModel[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: MedicalRecordCard(
                            record: record,
                            onTap: () => _showRecordDetails(record),
                          ),
                        );
                      },
                      childCount: state.medicalRecordModel.length,
                    ),
                  ),
                ],
              ) : SizedBox()
          );
        },
        listener: (context, state) {
          if(state is OnErrorMedicalRecordsState){}

    }
          );
  }

  void _showRecordDetails(MedicalRecordModel record) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RecordDetailSheet(record: record),
    );
  }

}
