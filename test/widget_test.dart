import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_gaslighting/main.dart';
import 'package:flutter_gaslighting/data/repository/weather_repository.dart';
import 'package:flutter_gaslighting/data/model/weather_model.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  testWidgets('App smoke test - verifies weather data loads', (
    WidgetTester tester,
  ) async {
    final mockRepository = MockWeatherRepository();
    const mockWeather = WeatherModel(
      latitude: 37.57,
      longitude: 126.98,
      currentWeather: CurrentWeather(
        temperature: 20.0,
        windspeed: 5.0,
        winddirection: 180,
        weathercode: 1,
        isDay: 1,
        time: "2023-10-27T12:00",
      ),
    );

    // Need to handle the future to ensure it completes
    when(
      () => mockRepository.getWeather(),
    ).thenAnswer((_) async => mockWeather);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          weatherRepositoryProvider.overrideWithValue(mockRepository),
        ],
        child: const MyApp(),
      ),
    );

    // Check for loading indicator
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for the future to complete
    await tester.pump();

    // Check for data
    expect(find.text('20.0°C'), findsOneWidget);
    expect(find.text('Weather App'), findsOneWidget);
  });
}
