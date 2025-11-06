import 'package:cortex/feature/appointment/presentation/state/appointment_details_state.dart';
import 'package:cortex/feature/pharmacy/presentation/cubit/inventory_cubit.dart';
import 'package:cortex/feature/pharmacy/presentation/state/inventory_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/Inventory.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _selectedStatus = 'All';

  @override
  void initState() {
    super.initState();
    context.read<InventoryCubit>().getInventory();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: BlocConsumer<InventoryCubit, InventoryState>(
        builder: (context, state) {
          if (state is OnLoadingInventoryState) {
            return _buildLoadingState();
          } else if (state is OnLoadedInventoryState) {
            return _buildLoadedState(state);
          } else if (state is OnErrorInventoryState) {
            return _buildErrorState(state);
          } else {
            return _buildInitialState();
          }
        },
        listener: (BuildContext context, InventoryState state) {
          if (state is OnErrorInventoryState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          SizedBox(height: 16),
          Text(
            'Loading Inventory...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Inventory Data',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Inventory items will appear here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(OnErrorInventoryState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Unable to Load Inventory',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[800],
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<InventoryCubit>().getInventory();
              },
              icon: const Icon(Icons.refresh, size: 20),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedState(OnLoadedInventoryState state) {
    final filteredItems = state.InventoryList
        .where((item) =>
    (_selectedCategory == 'All' || item.category == _selectedCategory) &&
        (_selectedStatus == 'All' || item.status == _selectedStatus) &&
        (item.itemName.toLowerCase().contains(_searchController.text.toLowerCase()) ||
            item.description.toLowerCase().contains(_searchController.text.toLowerCase())))
        .toList();

    return Column(
      children: [
        // Header
        _buildHeader(state),
        // Filters
        _buildFilterSection(state),
        // Inventory List
        Expanded(
          child: filteredItems.isEmpty
              ? _buildEmptyState()
              : _buildInventoryList(filteredItems),
        ),
      ],
    );
  }

  Widget _buildHeader(OnLoadedInventoryState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button and title row
          Row(
            children: [
              // Back Button
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 18,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Title
              const Expanded(
                child: Text(
                  'Inventory',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              // Refresh Button with Badge
              Badge(
                backgroundColor: Colors.blue,
                label: Text(
                  state.InventoryList.length.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                child: IconButton(
                  onPressed: () {
                    context.read<InventoryCubit>().getInventory();
                  },
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.refresh,
                      color: Colors.blue[700],
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Search Bar
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search inventory...',
                hintStyle: TextStyle(color: Colors.grey[500]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(OnLoadedInventoryState state) {
    final categories = ['All', ...state.InventoryList.map((e) => e.category).toSet()];
    final statuses = ['All', ...state.InventoryList.map((e) => e.status).toSet()];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 40,
              child: DropdownButtonFormField<String>(
                value: _selectedCategory,
                onChanged: (value) => setState(() => _selectedCategory = value!),
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(
                      category,
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                }).toList(),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                isExpanded: true,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 40,
              child: DropdownButtonFormField<String>(
                value: _selectedStatus,
                onChanged: (value) => setState(() => _selectedStatus = value!),
                items: statuses.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(
                      status,
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                }).toList(),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                isExpanded: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryList(List<Inventory> items) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildInventoryCard(item);
      },
    );
  }

  Widget _buildInventoryCard(Inventory item) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item.itemName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _buildStatusChip(item),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              item.category,
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoItem('Stock', '${item.quantityInStock} ${item.unitOfMeasure}'),
                _buildInfoItem('Reorder', '${item.reorderLevel}'),
                _buildInfoItem('Price', '\$${item.unitPrice.toStringAsFixed(2)}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Supplier: ${item.supplier}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
                Text(
                  'Last Updated: ${_formatDate(item.lastUpdated)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(Inventory item) {
    Color backgroundColor;
    Color textColor;

    switch (item.status.toLowerCase()) {
      case 'in stock':
        backgroundColor = Colors.green[50]!;
        textColor = Colors.green[800]!;
        break;
      case 'low stock':
        backgroundColor = Colors.orange[50]!;
        textColor = Colors.orange[800]!;
        break;
      case 'out of stock':
        backgroundColor = Colors.red[50]!;
        textColor = Colors.red[800]!;
        break;
      default:
        backgroundColor = Colors.grey[50]!;
        textColor = Colors.grey[800]!;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        item.status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Items Found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}