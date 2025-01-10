import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:apapp/pages/weather/weather_model.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';

class WeatherService {
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http
      .get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));
    
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<String> getCurrentCity() async {

    //get permission from the user
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    //fetch the current location
    // LocationSettings locationSettings = LocationSettings(
    //   accuracy: LocationAccuracy.high,
    // );

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.medium,
      ),
    );

    //convert the location into a list of placemark objects
    List<Placemark> placemarks = 
      await placemarkFromCoordinates(position.latitude, position.longitude);
    
    String? city = placemarks[0].locality;

    return city ?? "Unknown city";
  }
}