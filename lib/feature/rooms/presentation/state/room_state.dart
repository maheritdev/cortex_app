import 'package:cortex/feature/rooms/data/room_model.dart';

class RoomState {}

class OnInitialRoomState extends RoomState {}

class OnLoadingRoomState extends RoomState {}

class OnLoadedRoomState extends RoomState {
  final List<RoomModel> roomModel ; // Remove nullable operator
  OnLoadedRoomState({required this.roomModel});
}

class OnErrorRoomState extends RoomState {
  final String errorMessage;
  OnErrorRoomState(this.errorMessage);
}