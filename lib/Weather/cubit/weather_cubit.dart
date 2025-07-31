import 'package:bloc/bloc.dart';
import 'package:weather_app/Weather/Widget/weather_api.dart';
import 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit() : super(WeatherInitial());

  Future<void> getWeather(String city) async {
    if (city.isEmpty) {
      emit(WeatherError(errorMessage: 'Please enter a city name.'));
      return;
    }

    emit(WeatherLoading());

    try {
      final weatherData = await WeatherApi().fetchWeather(city);
      final sunsetUnix = weatherData['sys']['sunset'];
      DateTime sunset = DateTime.fromMillisecondsSinceEpoch(sunsetUnix * 1000);
      final sunsetFormatted =
          '${sunset.hour.toString().padLeft(2, '0')}:${sunset.minute.toString().padLeft(2, '0')}';

      emit(WeatherLoaded(
        cityName: weatherData['name'],
        weatherDescription: weatherData['weather'][0]['description'],
        temperature: weatherData['main']['temp'],
        humidity: weatherData['main']['humidity'],
        windSpeed: weatherData['wind']['speed'],
        sunsetTime: sunsetFormatted,
      ));
    } catch (e) {
      emit(WeatherError(
        errorMessage: 'Failed to fetch data. Please check your connection.',
      ));
    }
  }
}
