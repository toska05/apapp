class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final double windSpeed;
  final double windDegree;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.windSpeed,
    required this.windDegree,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
      windSpeed: json['wind']['speed'].toDouble(),
      windDegree: json['wind']['deg'].toDouble(),
    );
  }
}