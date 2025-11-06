import 'dart:convert';

import 'package:cortex/feature/rooms/data/room_model.dart';
import 'package:cortex/feature/rooms/presentation/state/room_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../../../core/const/api_const.dart';
import '../../../../core/utils/PrintCont.dart';

class RoomCubit extends Cubit<RoomState> {

  List<RoomModel> response_body = []; // Initialize as empty list, not nullable

  RoomCubit() : super(OnInitialRoomState());



  Future<void> getRooms() async {
    emit(OnInitialRoomState());
    print('Fetching from: ${ApiConst.get_rooms}');

    try {
      Uri uri = Uri.parse('${ApiConst.get_rooms}');
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List<dynamic> result =
        decoded is List ? decoded : (decoded['data'] ?? []);

        PrintCont.success('Raw response received (${result.length} items)');

        final List<RoomModel> appointments = [];

        for (var item in result) {
          if (item == null) continue;
          /*if (item['rooms'] == null) {
            PrintCont.warning('Skipping rooms without room: ${item['roomId']}');
            continue;
          }*/
          try {
            final model = RoomModel.fromJson(item);
            appointments.add(model);
          } catch (e) {
            PrintCont.error('Error parsing appointment: $e');
          }
        }

        response_body = appointments;
        PrintCont.success('Total appointments loaded: ${response_body.length}');
        emit(OnLoadedRoomState(roomModel: response_body));
      } else {
        PrintCont.error('HTTP Error: ${response.statusCode}');
        emit(OnErrorRoomState('HTTP ${response.statusCode}'));
      }
    } catch (e) {
      PrintCont.error('Exception: $e');
      emit(OnErrorRoomState(e.toString()));
    }
  }
}
