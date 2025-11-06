import 'package:flutter/material.dart';

import '../../../data/room_model.dart';

class RoomFilterSheet extends StatefulWidget {
  final List<RoomModel> rooms;
  final List<String> selectedTypes;
  final List<String> selectedStatuses;
  final String selectedDepartment;
  final double maxRate;
  final Function(List<String>, List<String>, String, double) onFiltersChanged;

  const RoomFilterSheet({
    super.key,
    required this.rooms,
    required this.selectedTypes,
    required this.selectedStatuses,
    required this.selectedDepartment,
    required this.maxRate,
    required this.onFiltersChanged,
  });

  @override
  State<RoomFilterSheet> createState() => _RoomFilterSheetState();
}

class _RoomFilterSheetState extends State<RoomFilterSheet> {
  late List<String> _selectedTypes;
  late List<String> _selectedStatuses;
  late String _selectedDepartment;
  late double _maxRate;

  @override
  void initState() {
    super.initState();
    _selectedTypes = List.from(widget.selectedTypes);
    _selectedStatuses = List.from(widget.selectedStatuses);
    _selectedDepartment = widget.selectedDepartment;
    _maxRate = widget.maxRate;
  }

  void _applyFilters() {
    widget.onFiltersChanged(_selectedTypes, _selectedStatuses, _selectedDepartment, _maxRate);
    Navigator.pop(context);
  }

  void _resetFilters() {
    setState(() {
      _selectedTypes.clear();
      _selectedStatuses.clear();
      _selectedDepartment = 'All';
      _maxRate = 1000;
    });
  }

  @override
  Widget build(BuildContext context) {
    final roomTypes = widget.rooms.map((room) => room.roomType).toSet().toList();
    //final departments = widget.rooms.map((room) => room.department.departmentName).toSet().toList();
    final maxRoomRate = widget.rooms.map((room) => room.ratePerDay).reduce((a, b) => a > b ? a : b);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Filter Rooms',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Room Types
                  Text(
                    'Room Type',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: roomTypes.map((type) {
                      final isSelected = _selectedTypes.contains(type);
                      return FilterChip(
                        label: Text(type),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedTypes.add(type);
                            } else {
                              _selectedTypes.remove(type);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Status
                  Text(
                    'Status',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['Available', 'Occupied', 'Maintenance'].map((status) {
                      final isSelected = _selectedStatuses.contains(status);
                      return FilterChip(
                        label: Text(status),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedStatuses.add(status);
                            } else {
                              _selectedStatuses.remove(status);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Department
                  Text(
                    'Department',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedDepartment,
                    items: [
                      const DropdownMenuItem(value: 'All', child: Text('All Departments')),
                      //...departments.map((dept) => DropdownMenuItem(value: dept, child: Text(dept))),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedDepartment = value ?? 'All';
                      });
                    },
                    isExpanded: true,
                  ),
                  const SizedBox(height: 24),

                  // Rate Filter
                  Text(
                    'Maximum Rate: \$${_maxRate.toInt()}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: _maxRate,
                    min: 0,
                    max: maxRoomRate,
                    divisions: 20,
                    label: '\$${_maxRate.toInt()}',
                    onChanged: (value) {
                      setState(() {
                        _maxRate = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _resetFilters,
                  child: const Text('Reset'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: _applyFilters,
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}