import 'package:apapp/pages/weather/weather_model.dart';
import 'package:apapp/pages/weather/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  final _weatherService = WeatherService('5d8e2e857907a3e5e2d7388e615609ad');
  Weather? _weather;

  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }

    catch (e) {
      print(e);
    }
  }

  // weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'snow':
        return 'assets/snow.json';
      case 'mist':
      case 'fog':
        return 'assets/mist.json';
      case 'haze':
      case 'clouds':
      case 'smoke':
      case 'dust':
        return 'assets/windy.json';
      case 'partly cloudy':
        return 'assets/partly_cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rainy_day.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'moon':
        return 'assets/moon.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  //init state
  @override
  void initState() {
    super.initState();

    //fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _weather == null ? const Center(
        child: Text("Loading..."),
      )
      : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //city name
            Text(_weather?.cityName ?? "loading city.."),
            //animation
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
            //temperature
            Text('${_weather?.temperature.round()}*C'),
            //wind
            Text('${_weather?.windSpeed.round()} m/s, ${_weather?.windDegree.round()}*'),
          ],
        ),
      ),
    );
  }
}