import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zopmedia_assignment/models/vehicle.dart';
import 'package:zopmedia_assignment/repository/vehicle.dart';
import 'package:zopmedia_assignment/service/vehicle_database.dart';
import 'vehicle_event.dart';
import 'vehicle_state.dart';
import 'package:http/http.dart' as http;

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
 VehicleBloc()
    : super(
        VehicleState(
          status: VehicleStatus.loading,
          vehicles: [],
        ),
      ) {
  on<FetchVehicles>(_onFetchVehicles);
}


  Future<void> _onFetchVehicles(FetchVehicles event, Emitter<VehicleState> emit) async {
    emit(state.copyWith(status: VehicleStatus.loading));

    try {
      final response = await http.get(Uri.parse('https://zopmedia-assignment-backend.onrender.com/api/vehicles'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final vehicles = data.map((e) => Vehicle.fromJson(e)).toList();

        // Save to local DB
        await VehicleDatabase.instance.clearVehicles();
        await VehicleDatabase.instance.insertVehicles(vehicles);

        emit(state.copyWith(status: VehicleStatus.success, vehicles: vehicles));
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      // Try to load from DB on failure
      final vehicles = await VehicleDatabase.instance.getAllVehicles();
      if (vehicles.isNotEmpty) {
        emit(state.copyWith(status: VehicleStatus.success, vehicles: vehicles));
      } else {
        emit(state.copyWith(status: VehicleStatus.failure, errorMessage: e.toString()));
      }
    }
  }
}