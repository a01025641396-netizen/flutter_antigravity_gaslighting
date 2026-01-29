class WeatherModel {
  final double latitude;
  final double longitude;
  final CurrentWeather currentWeather;

  const WeatherModel({
    required this.latitude,
    required this.longitude,
    required this.currentWeather,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      currentWeather: CurrentWeather.fromJson(
        json['current_weather'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'current_weather': currentWeather.toJson(),
    };
  }

  WeatherModel copyWith({
    double? latitude,
    double? longitude,
    CurrentWeather? currentWeather,
  }) {
    return WeatherModel(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      currentWeather: currentWeather ?? this.currentWeather,
    );
  }
}

class CurrentWeather {
  final double temperature;
  final double windspeed;
  final int winddirection;
  final int weathercode;
  final int isDay;
  final String time;

  const CurrentWeather({
    required this.temperature,
    required this.windspeed,
    required this.winddirection,
    required this.weathercode,
    required this.isDay,
    required this.time,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature: (json['temperature'] as num).toDouble(),
      windspeed: (json['windspeed'] as num).toDouble(),
      winddirection: (json['winddirection'] as num).toInt(),
      weathercode: (json['weathercode'] as num).toInt(),
      isDay: (json['is_day'] as num).toInt(),
      time: json['time'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'windspeed': windspeed,
      'winddirection': winddirection,
      'weathercode': weathercode,
      'is_day': isDay,
      'time': time,
    };
  }

  CurrentWeather copyWith({
    double? temperature,
    double? windspeed,
    int? winddirection,
    int? weathercode,
    int? isDay,
    String? time,
  }) {
    return CurrentWeather(
      temperature: temperature ?? this.temperature,
      windspeed: windspeed ?? this.windspeed,
      winddirection: winddirection ?? this.winddirection,
      weathercode: weathercode ?? this.weathercode,
      isDay: isDay ?? this.isDay,
      time: time ?? this.time,
    );
  }
}
