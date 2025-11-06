import '../../data/Inventory.dart';

class InventoryState {}

class OnInitialInventoryState extends InventoryState {}

class OnLoadingInventoryState extends InventoryState {}

class OnLoadedInventoryState extends InventoryState {
  final List<Inventory> InventoryList;
  OnLoadedInventoryState({required this.InventoryList});
}

class OnErrorInventoryState extends InventoryState {
  final String errorMessage;
  OnErrorInventoryState(this.errorMessage);
}