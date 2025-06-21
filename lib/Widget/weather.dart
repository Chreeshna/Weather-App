// import 'package:flutter/material.dart';
// import 'package:weather_app/cubit/weather_cubit.dart';
// import 'package:weather_app/cubit/weather_state.dart';
// import 'package:weather_icons/weather_icons.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class WeatherApp extends StatefulWidget {
//   const WeatherApp({super.key, required this.toggleTheme});

//   final void Function() toggleTheme;

//   @override
//   WeatherAppState createState() => WeatherAppState();
// }

// class WeatherAppState extends State<WeatherApp> {
//   final TextEditingController _cityController = TextEditingController();

//   LinearGradient _getGradient(String weather) {
//     switch (weather) {
//       case 'rainy':
//         return LinearGradient(
//             colors: [Colors.blue.shade800, Colors.blue.shade200]);
//       case 'foggy':
//         return LinearGradient(
//             colors: [Colors.grey.shade700, Colors.grey.shade400]);
//       case 'sunny':
//       default:
//         return LinearGradient(
//             colors: [Colors.orange.shade700, Colors.yellow.shade600]);
//     }
//   }

//   IconData _getWeatherIcon(String weather) {
//     switch (weather) {
//       case 'rainy':
//         return WeatherIcons.rain;
//       case 'foggy':
//         return WeatherIcons.fog;
//       case 'sunny':
//       default:
//         return WeatherIcons.day_sunny;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Weather App'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.brightness_1),
//             onPressed: widget.toggleTheme,
//           ),
//         ],
//       ),
//       body: BlocBuilder<WeatherCubit, WeatherState>(
//         builder: (context, state) {
//           String weather = 'sunny';
//           double? temperature;

//           if (state is WeatherLoaded) {
//             weather = state.weatherDescription;
//             temperature = state.temperature;
//           }

//           return Container(
//             decoration: BoxDecoration(
//               gradient: _getGradient(weather),
//             ),
//             child: SafeArea(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         Expanded(
//                           child: TextField(
//                             controller: _cityController,
//                             decoration: InputDecoration(
//                               hintText: 'Enter city name',
//                               filled: true,
//                               fillColor: Colors.white.withOpacity(1.0),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                                 borderSide: BorderSide.none,
//                               ),
//                               contentPadding: const EdgeInsets.symmetric(
//                                   vertical: 10, horizontal: 12),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         ElevatedButton(
//                           onPressed: () {
//                             context.read<WeatherCubit>().getWeather(
//                                   _cityController.text,
//                                 );
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.white,
//                             foregroundColor: Colors.black,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                           child: const Icon(Icons.search),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//                     Expanded(
//                       child: Center(
//                         child: state is WeatherLoading
//                             ? const CircularProgressIndicator()
//                             : state is WeatherError
//                                 ? Center(
//                                     child: Text(
//                                       state.errorMessage,
//                                       style: const TextStyle(
//                                           fontSize: 18, color: Colors.white),
//                                     ),
//                                   )
//                                 : state is WeatherLoaded
//                                     ? Container(
//                                         padding: const EdgeInsets.all(20),
//                                         decoration: BoxDecoration(
//                                           color: Colors.white.withOpacity(0.9),
//                                           borderRadius:
//                                               BorderRadius.circular(20),
//                                         ),
//                                         child: Column(
//                                           mainAxisSize: MainAxisSize.min,
//                                           children: [
//                                             Icon(
//                                               _getWeatherIcon(weather),
//                                               size: 100,
//                                               color: Colors.black38,
//                                             ),
//                                             const SizedBox(height: 10),
//                                             Text(
//                                               state.cityName,
//                                               style: const TextStyle(
//                                                 fontSize: 28,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                             const SizedBox(height: 10),
//                                             Text(
//                                               '${temperature?.toStringAsFixed(1)}°C',
//                                               style: const TextStyle(
//                                                 fontSize: 48,
//                                                 fontWeight: FontWeight.w500,
//                                               ),
//                                             ),
//                                             const SizedBox(height: 10),
//                                             Text(
//                                               state.weatherDescription[0]
//                                                       .toUpperCase() +
//                                                   state.weatherDescription
//                                                       .substring(1),
//                                               style: const TextStyle(
//                                                 fontSize: 20,
//                                                 color: Colors.black54,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       )
//                                     : const Text(
//                                         'Enter a city to check the weather',
//                                         style: TextStyle(
//                                           fontSize: 18,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
