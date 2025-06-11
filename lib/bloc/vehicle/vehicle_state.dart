import 'package:zopmedia_assignment/models/vehicle.dart';


enum VehicleStatus { initial, loading, success, failure }

class VehicleState {
  final VehicleStatus status;
  final List<Vehicle> vehicles;
  final String? errorMessage;

  VehicleState({
    required this.status,
    required this.vehicles,
    this.errorMessage,
  });

  factory VehicleState.initial() => VehicleState(
        status: VehicleStatus.initial,
        vehicles: [],
        errorMessage: null,
      );

  VehicleState copyWith({
    VehicleStatus? status,
    List<Vehicle>? vehicles,
    String? errorMessage,
  }) {
    return VehicleState(
      status: status ?? this.status,
      vehicles: vehicles ?? this.vehicles,
      errorMessage: errorMessage,
    );
  }
}
