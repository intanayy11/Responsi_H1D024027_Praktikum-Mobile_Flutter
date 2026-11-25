import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherRepository {
  final WeatherService _weatherService;

  WeatherRepository({WeatherService? weatherService})
      : _weatherService = weatherService ?? WeatherService();

  Future<WeatherModel> getWeather({
    required double latitude,
    required double longitude,
  }) {
    return _weatherService.getWeatherForecast(
      latitude: latitude,
      longitude: longitude,
    );
  }
}
