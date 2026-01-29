import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gaslighting/data/repository/weather_repository.dart';
import 'package:flutter_gaslighting/data/model/weather_model.dart';
import 'dart:convert';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late WeatherRepositoryImpl weatherRepository;
  late MockHttpClient mockHttpClient;
  final Uri testUrl = Uri.parse(
    'https://api.open-meteo.com/v1/forecast?latitude=37.57&longitude=126.98&current_weather=true',
  );

  setUp(() {
    mockHttpClient = MockHttpClient();
    weatherRepository = WeatherRepositoryImpl(client: mockHttpClient);
  });

  group('WeatherRepositoryImpl', () {
    test('getWeather returns WeatherModel on 200 success', () async {
      // Arrange
      final mockResponse = {
        "latitude": 37.57,
        "longitude": 126.98,
        "generationtime_ms": 1.23,
        "utc_offset_seconds": 32400, // KST (UTC+9)
        "timezone": "Asia/Seoul",
        "timezone_abbreviation": "KST",
        "elevation": 38.0,
        "current_weather": {
          "temperature": 15.0,
          "windspeed": 3.5,
          "winddirection": 180,
          "weathercode": 1,
          "is_day": 1,
          "time": "2023-10-27T12:00",
        },
      };

      when(
        () => mockHttpClient.get(testUrl),
      ).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

      // Act
      final result = await weatherRepository.getWeather();

      // Assert
      expect(result, isA<WeatherModel>());
      expect(result.latitude, 37.57);
      expect(result.currentWeather.temperature, 15.0);
      verify(() => mockHttpClient.get(testUrl)).called(1);
    });

    test('getWeather throws Exception on non-200 status code', () async {
      // Arrange
      when(
        () => mockHttpClient.get(testUrl),
      ).thenAnswer((_) async => http.Response('Not Found', 404));

      // Act & Assert
      expect(
        () async => await weatherRepository.getWeather(),
        throwsA(isA<Exception>()),
      );
    });

    test('getWeather throws Exception on network error', () async {
      // Arrange
      when(
        () => mockHttpClient.get(testUrl),
      ).thenThrow(Exception('Network Error'));

      // Act & Assert
      expect(
        () async => await weatherRepository.getWeather(),
        throwsA(isA<Exception>()),
      );
    });
  });
}
