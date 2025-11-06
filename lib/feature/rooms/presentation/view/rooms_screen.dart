import 'package:cortex/feature/rooms/presentation/cubit/room_cubit.dart';
import 'package:cortex/feature/rooms/presentation/state/room_state.dart';
import 'package:cortex/feature/rooms/presentation/view/widgets/room_card.dart';
import 'package:cortex/feature/rooms/presentation/view/widgets/room_filter_sheet.dart';
import 'package:cortex/feature/rooms/presentation/view/widgets/room_status_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/room_model.dart';

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({super.key});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {

  final List<String> _selectedTypes = [];
  final List<String> _selectedStatuses = [];
  String _selectedDepartment = 'All';
  double _maxRate = 1000;


  void initState() {
    super.initState();
    _loadRooms();

  }

  List<RoomModel> _filterRooms(List<RoomModel> rooms) {
    return rooms.where((room) {
      final typeMatch = _selectedTypes.isEmpty || _selectedTypes.contains(room.roomType);
      final statusMatch = _selectedStatuses.isEmpty || _selectedStatuses.contains(room.status);
      //final departmentMatch = _selectedDepartment == 'All' || room.department.departmentName == _selectedDepartment;
      final rateMatch = room.ratePerDay <= _maxRate;

      return typeMatch && statusMatch  && rateMatch;//&& departmentMatch
    }).toList();
  }

  void _showFilterSheet(List<RoomModel> rooms) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RoomFilterSheet(
        rooms: rooms,
        selectedTypes: _selectedTypes,
        selectedStatuses: _selectedStatuses,
        selectedDepartment: _selectedDepartment,
        maxRate: _maxRate,
        onFiltersChanged: (types, statuses, department, maxRate) {
          setState(() {
            _selectedTypes.clear();
            _selectedTypes.addAll(types);
            _selectedStatuses.clear();
            _selectedStatuses.addAll(statuses);
            _selectedDepartment = department;
            _maxRate = maxRate;
          });
        },
      ),
    );
  }
  void _showRoomDetails(RoomModel room) {
    showDialog(
      context: context,
      builder: (context) => _RoomDetailsDialog(room: room),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<RoomCubit, RoomState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                expandedHeight: 180,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'Hospital Rooms',
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
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                actions: [
                  /*IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: state is OnLoadedRoomState
                        ? () => _showFilterSheet(state.roomModel)
                        : null,
                  ),*/
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: (){
                      _loadRooms();
                    },
                  ),
                ],
              ),

              // Content based on state
              if (state is OnInitialRoomState || state is OnLoadingRoomState)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (state is OnErrorRoomState)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Failed to load rooms',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          (state as OnErrorRoomState).errorMessage,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: (){},
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              else if (state is OnLoadedRoomState)
                  _buildRoomList(state.roomModel)
                else
                  const SliverFillRemaining(
                    child: Center(
                      child: Text('Unknown state'),
                    ),
                  ),
            ],
          );
        },
        listener: (context, state) {
          if (state is OnErrorRoomState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.errorMessage}'),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
      )
    );
  }

  Widget _buildRoomList(List<RoomModel> rooms) {
    final filteredRooms = _filterRooms(rooms);
    final stats = _calculateStats(rooms);

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          // Statistics Cards
          _buildStatistics(stats),
          const SizedBox(height: 16),

          // Filter Indicators
          if (_selectedTypes.isNotEmpty || _selectedStatuses.isNotEmpty || _selectedDepartment != 'All')
            _buildActiveFilters(filteredRooms.length),
          const SizedBox(height: 16),

          // Room List
          if (filteredRooms.isEmpty)
            _buildEmptyState()
          else
            ...filteredRooms.map((room) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: RoomCard(
                room: room,
                onTap: () => _showRoomDetails(room),
              ),
            )),
        ]),
      ),
    );
  }

  Widget _buildStatistics(Map<String, int> stats) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            count: stats['total'] ?? 0,
            label: 'Total',
            color: Theme.of(context).colorScheme.primary,
          ),
          _StatItem(
            count: stats['available'] ?? 0,
            label: 'Available',
            color: Colors.green,
          ),
          _StatItem(
            count: stats['occupied'] ?? 0,
            label: 'Occupied',
            color: Colors.orange,
          ),
          _StatItem(
            count: stats['maintenance'] ?? 0,
            label: 'Maintenance',
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilters(int filteredCount) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.filter_alt,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${filteredCount} rooms match your filters',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedTypes.clear();
                _selectedStatuses.clear();
                _selectedDepartment = 'All';
                _maxRate = 1000;
              });
            },
            child: Text(
              'Clear',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(
            Icons.meeting_room_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No rooms found',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters or check back later',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Map<String, int> _calculateStats(List<RoomModel> rooms) {
    return {
      'total': rooms.length,
      'available': rooms.where((room) => room.isAvailable).length,
      'occupied': rooms.where((room) => room.isOccupied).length,
      'maintenance': rooms.where((room) => room.isUnderMaintenance).length,
    };
  }

  void _loadRooms() {
    context.read<RoomCubit>().getRooms();
  }
}

class _StatItem extends StatelessWidget {
  final int count;
  final String label;
  final Color color;

  const _StatItem({
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Text(
            count.toString(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _RoomDetailsDialog extends StatelessWidget {
  final RoomModel room;

  const _RoomDetailsDialog({required this.room});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    room.roomNumber,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                RoomStatusChip(status: room.status),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              room.roomType,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            _DetailRow(
              icon: Icons.people_outline,
              label: 'Capacity',
              value: room.capacityText,
            ),
            _DetailRow(
              icon: Icons.attach_money_outlined,
              label: 'Rate',
              value: room.formattedRate,
            ),
            /*_DetailRow(
              icon: Icons.business_outlined,
              label: 'Department',
              value: room.department.departmentName,
            ),*/
            // _DetailRow(
            //   icon: Icons.location_on_outlined,
            //   label: 'Location',
            //   value: room.department.location,
            // ),
            /*if (room.department.description.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Description',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                room.department.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],*/
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
