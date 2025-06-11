import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zopmedia_assignment/models/vehicle.dart';


class VehicleRepository {
  Future<List<Vehicle>> fetchVehicles() async {
    final response = await http.get(
      Uri.parse('https://zopmedia-assignment-backend.onrender.com/api/vehicles'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Vehicle.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load vehicles');
    }
  }
}
