import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/weather_model.dart';

// Dependency Injection via Riverpod
final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  return WeatherRepositoryImpl();
});

abstract class WeatherRepository {
  Future<WeatherModel> getWeather();
}

class WeatherRepositoryImpl implements WeatherRepository {
  final http.Client _client;

  WeatherRepositoryImpl({http.Client? client})
    : _client = client ?? http.Client();

  final Uri _url = Uri.parse(
    'https://api.open-meteo.com/v1/forecast?latitude=37.57&longitude=126.98&current_weather=true',
  );

  @override
  Future<WeatherModel> getWeather() async {
    try {
      final response = await _client.get(_url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonBody = jsonDecode(response.body);
        return WeatherModel.fromJson(jsonBody);
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching weather data: $e');
    }
  }
}
