import 'current_weather_model.dart';
import 'daily_forecast_model.dart';
import 'hourly_forecast_model.dart';

class WeatherModel {
  final double latitude;
  final double longitude;
  final String timezone;
  final CurrentWeatherModel current;
  final List<HourlyForecastModel> hourly;
  final List<DailyForecastModel> daily;
  final Map<String, dynamic>? currentUnits;

  const WeatherModel({
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.current,
    required this.hourly,
    required this.daily,
    this.currentUnits,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      timezone: json['timezone'] as String? ?? 'UTC',
      current: CurrentWeatherModel.fromJson(
        json['current'] as Map<String, dynamic>? ?? {},
      ),
      hourly: HourlyForecastModel.listFromJson(
        json['hourly'] as Map<String, dynamic>?,
      ),
      daily: DailyForecastModel.listFromJson(
        json['daily'] as Map<String, dynamic>?,
      ),
      currentUnits: json['current_units'] as Map<String, dynamic>?,
    );
  }
}
