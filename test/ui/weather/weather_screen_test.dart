import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_gaslighting/ui/weather/weather_screen.dart';
import 'package:flutter_gaslighting/data/repository/weather_repository.dart';
import 'package:flutter_gaslighting/data/model/weather_model.dart';
import 'dart:async';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  late MockWeatherRepository mockRepository;

  setUp(() {
    mockRepository = MockWeatherRepository();
  });

  const mockWeather = WeatherModel(
    latitude: 37.57,
    longitude: 126.98,
    currentWeather: CurrentWeather(
      temperature: 25.0,
      windspeed: 10.0,
      winddirection: 180,
      weathercode: 1,
      isDay: 1,
      time: "2023-10-27T12:00",
    ),
  );

  Widget createSubject() {
    return ProviderScope(
      overrides: [weatherRepositoryProvider.overrideWithValue(mockRepository)],
      child: const MaterialApp(home: WeatherScreen()),
    );
  }

  testWidgets('WeatherScreen shows loading initially', (
    WidgetTester tester,
  ) async {
    // Arrange: Complete with delay to simulate network
    when(() => mockRepository.getWeather()).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 1));
      return mockWeather;
    });

    // Act
    await tester.pumpWidget(createSubject());

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Finish the timer
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('WeatherScreen shows data when loaded', (
    WidgetTester tester,
  ) async {
    // Arrange
    when(
      () => mockRepository.getWeather(),
    ).thenAnswer((_) async => mockWeather);

    // Act
    await tester.pumpWidget(createSubject());
    await tester.pump(); // Run builders

    // Assert
    expect(find.text('25.0°C'), findsOneWidget);
    expect(find.text('Wind Speed: 10.0 km/h'), findsOneWidget);
  });

  testWidgets('WeatherScreen shows error on failure', (
    WidgetTester tester,
  ) async {
    // Arrange
    const errorMsg = 'Network Error';
    when(
      () => mockRepository.getWeather(),
    ).thenAnswer((_) => Future.error(Exception(errorMsg)));

    // Act
    await tester.pumpWidget(createSubject());
    await tester.pumpAndSettle(); // Run builders

    // Assert
    expect(find.byIcon(Icons.error_outline), findsOneWidget);
    expect(find.textContaining(errorMsg), findsOneWidget);
  });

  testWidgets('Refresh button triggers reload', (WidgetTester tester) async {
    // Arrange
    // Return data first time
    when(
      () => mockRepository.getWeather(),
    ).thenAnswer((_) async => mockWeather);

    // Act
    await tester.pumpWidget(createSubject());
    await tester.pump();

    // Tap refresh
    await tester.tap(find.byIcon(Icons.refresh));

    // Assert
    // Called once strictly for build, but refresh might trigger another one.
    // Ideally we verify called(2), but since build runs once and refresh runs once.
    verify(() => mockRepository.getWeather()).called(greaterThan(1));
  });
}
