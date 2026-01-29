import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_gaslighting/data/model/weather_model.dart';
import 'package:flutter_gaslighting/data/repository/weather_repository.dart';
import 'package:flutter_gaslighting/ui/weather/weather_view_model.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  late MockWeatherRepository mockWeatherRepository;
  late ProviderContainer container;

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    container = ProviderContainer(
      overrides: [
        weatherRepositoryProvider.overrideWithValue(mockWeatherRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

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

  test('WeatherViewModel header build fetches weather', () async {
    // Arrange
    when(
      () => mockWeatherRepository.getWeather(),
    ).thenAnswer((_) async => mockWeather);

    // Act
    // Reading the provider triggers build()
    final subscription = container.listen(
      weatherViewModelProvider,
      (previous, next) {},
    );

    // Wait for the async build to complete
    await container.read(weatherViewModelProvider.future);

    // Assert
    final state = container.read(weatherViewModelProvider);

    expect(state, const AsyncData(mockWeather));
    verify(() => mockWeatherRepository.getWeather()).called(1);

    subscription.close();
  });

  test('WeatherViewModel refresh re-fetches weather', () async {
    // Arrange
    when(
      () => mockWeatherRepository.getWeather(),
    ).thenAnswer((_) async => mockWeather);

    // Act
    // Initial load
    final subscription = container.listen(
      weatherViewModelProvider,
      (previous, next) {},
    );
    await container.read(weatherViewModelProvider.future);

    // Refresh
    await container.read(weatherViewModelProvider.notifier).refresh();

    // Assert
    final state = container.read(weatherViewModelProvider);
    expect(state, const AsyncData(mockWeather));
    verify(
      () => mockWeatherRepository.getWeather(),
    ).called(2); // Called twice: build + refresh

    subscription.close();
  });
}
