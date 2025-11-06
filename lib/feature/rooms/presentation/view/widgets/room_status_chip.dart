import 'package:flutter/material.dart';

class RoomStatusChip extends StatelessWidget {
  final String status;

  const RoomStatusChip({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final (color, icon) = _getStatusProperties(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            status,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  (Color, IconData) _getStatusProperties(String status) {
    switch (status) {
      case 'Available':
        return (Colors.green, Icons.check_circle_outline);
      case 'Occupied':
        return (Colors.orange, Icons.person_outline);
      case 'Maintenance':
        return (Colors.red, Icons.build_outlined);
      default:
        return (Colors.grey, Icons.help_outline);
    }
  }
}