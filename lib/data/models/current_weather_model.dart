class CurrentWeatherModel {
  final double temperature;
  final int relativeHumidity;
  final double apparentTemperature;
  final double precipitation;
  final int weatherCode;
  final double windSpeed;
  final String time;

  const CurrentWeatherModel({
    required this.temperature,
    required this.relativeHumidity,
    required this.apparentTemperature,
    required this.precipitation,
    required this.weatherCode,
    required this.windSpeed,
    required this.time,
  });

  factory CurrentWeatherModel.fromJson(Map<String, dynamic> json) {
    return CurrentWeatherModel(
      temperature: (json['temperature_2m'] as num?)?.toDouble() ?? 0.0,
      relativeHumidity: (json['relative_humidity_2m'] as num?)?.round() ?? 0,
      apparentTemperature: (json['apparent_temperature'] as num?)?.toDouble() ?? 0.0,
      precipitation: (json['precipitation'] as num?)?.toDouble() ?? 0.0,
      weatherCode: (json['weather_code'] as num?)?.toInt() ?? 0,
      windSpeed: (json['wind_speed_10m'] as num?)?.toDouble() ?? 0.0,
      time: json['time'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temperature_2m': temperature,
      'relative_humidity_2m': relativeHumidity,
      'apparent_temperature': apparentTemperature,
      'precipitation': precipitation,
      'weather_code': weatherCode,
      'wind_speed_10m': windSpeed,
      'time': time,
    };
  }
}
