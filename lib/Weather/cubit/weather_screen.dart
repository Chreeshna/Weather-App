import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:weather_app/Weather/cubit/theme_cubit.dart';
import 'package:weather_app/Weather/cubit/weather_cubit.dart';
import 'package:weather_app/Weather/cubit/weather_state.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  WeatherScreenState createState() => WeatherScreenState();
}

class WeatherScreenState extends State<WeatherScreen> {
  File? _capturedImage;
  final TextEditingController _cityController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

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

  Future<void> _takeWeatherPhoto() async {
    final image = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 800,
      imageQuality: 85,
    );
    if (image != null) {
      setState(() {
        _capturedImage = File(image.path);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Weather photo captured!')),
      );
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
            icon: const Icon(Icons.camera_alt),
            onPressed: _takeWeatherPhoto,
          ),
          // Theme switcher with animation
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
                key: ValueKey<bool>(isDarkMode),
              ),
            ),
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
          ),
        ],
      ),
      body: BlocBuilder<WeatherCubit, WeatherState>(
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Search bar
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _cityController,
                          decoration: InputDecoration(
                            hintText: 'Enter city name',
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          if (_cityController.text.isNotEmpty) {
                            context
                                .read<WeatherCubit>()
                                .getWeather(_cityController.text);
                          }
                        },
                        child: const Icon(Icons.search),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Weather display with captured image
                  Expanded(
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: _buildWeatherContent(state),
                      ),
                    ),
                  ),

                  // Display captured image if exists
                  if (_capturedImage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _capturedImage!,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
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

  Widget _buildWeatherContent(WeatherState state) {
    if (state is WeatherLoading) {
      return const CircularProgressIndicator(key: ValueKey('loading'));
    } else if (state is WeatherError) {
      return Text(
        state.errorMessage,
        key: const ValueKey('error'),
        style: const TextStyle(fontSize: 18),
      );
    } else if (state is WeatherLoaded) {
      return Column(
        key: ValueKey(state.temperature),
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getWeatherIcon(state.weatherDescription),
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
            '${state.temperature.toStringAsFixed(1)}° C',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            state.weatherDescription[0].toUpperCase() +
                state.weatherDescription.substring(1),
            style: const TextStyle(fontSize: 20),
          ),
        ],
      );
    } else {
      return const Text(
        'Enter a city to check the weather',
        key: ValueKey('empty'),
        style: TextStyle(fontSize: 18),
      );
    }
  }
}
