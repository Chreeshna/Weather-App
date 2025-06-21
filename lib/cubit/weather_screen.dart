import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/cubit/theme_cubit.dart';
import 'package:weather_app/cubit/weather_cubit.dart';
import 'package:weather_app/cubit/weather_state.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  WeatherScreenState createState() => WeatherScreenState();
}

class WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();

  IconData _getWeatherIcon(String weather) {
    switch (weather.toLowerCase()) {
      case 'rainy':
        return Icons.cloud;
      case 'foggy':
        return Icons.filter_drama;
      case 'sunny':
      default:
        return Icons.wb_sunny;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
          ),
        ],
      ),
      body: BlocBuilder<WeatherCubit, WeatherState>(
        builder: (context, state) {
          String weather = 'sunny';
          double? temperature;

          if (state is WeatherLoaded) {
            weather = state.weatherDescription;
            temperature = state.temperature;
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: TextField(
                        controller: _cityController,
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter city name',
                          hintStyle: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white54
                                    : Colors.black54,
                          ),
                          filled: true,
                          fillColor:
                              Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey[800]
                                  : Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 12,
                          ),
                        ),
                        cursorColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                      )),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<WeatherCubit>()
                              .getWeather(_cityController.text);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Icon(Icons.search),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Center(
                      child: state is WeatherLoading
                          ? const CircularProgressIndicator()
                          : state is WeatherError
                              ? Center(
                                  child: Text(
                                    state.errorMessage,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                )
                              : state is WeatherLoaded
                                  ? Container(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            _getWeatherIcon(weather),
                                            size: 100,
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            state.cityName,
                                            style: const TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            '${temperature?.toStringAsFixed(1)}° C',
                                            style: const TextStyle(
                                              fontSize: 48,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                              state.weatherDescription[0]
                                                      .toUpperCase() +
                                                  state.weatherDescription
                                                      .substring(1),
                                              style: const TextStyle(
                                                fontSize: 20,
                                              )),
                                        ],
                                      ),
                                    )
                                  : const Text(
                                      'Enter a city to check the weather',
                                      style: TextStyle(fontSize: 18),
                                    ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
