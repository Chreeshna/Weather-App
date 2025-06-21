abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final String cityName;
  final String weatherDescription;
  final double temperature;
  final double humidity;
  final double windSpeed;
  final String sunsetTime;

  WeatherLoaded({
    required this.cityName,
    required this.weatherDescription,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.sunsetTime,
  });
}

class WeatherError extends WeatherState {
  final String errorMessage;

  WeatherError({required this.errorMessage});
}
