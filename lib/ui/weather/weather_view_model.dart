import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/model/weather_model.dart';
import '../../data/repository/weather_repository.dart';

final weatherViewModelProvider =
    AsyncNotifierProvider.autoDispose<WeatherViewModel, WeatherModel>(
      WeatherViewModel.new,
    );

class WeatherViewModel extends AsyncNotifier<WeatherModel> {
  @override
  Future<WeatherModel> build() async {
    // Initialize by fetching weather
    return fetchWeather();
  }

  Future<WeatherModel> fetchWeather() async {
    final repository = ref.read(weatherRepositoryProvider);
    // State is automatically handled by AsyncValue, but here we can force refresh if needed.
    // For build(), we just return the future.
    return repository.getWeather();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => fetchWeather());
  }
}
