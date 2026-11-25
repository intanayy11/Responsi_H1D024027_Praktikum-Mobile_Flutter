import 'package:flutter_test/flutter_test.dart';
import 'package:skycast/data/services/geocoding_service.dart';
import 'package:skycast/data/services/weather_service.dart';

void main() {
  test('Live GeocodingService and WeatherService live call test', () async {
    final geocodingService = GeocodingService();
    final results = await geocodingService.searchLocations('Jakarta', count: 3);

    expect(results, isNotEmpty);
    final firstResult = results.first;
    expect(firstResult.name, isNotEmpty);
    expect(firstResult.latitude, isNotNull);
    expect(firstResult.longitude, isNotNull);

    final weatherService = WeatherService();
    final weather = await weatherService.getWeatherForecast(
      latitude: firstResult.latitude,
      longitude: firstResult.longitude,
    );

    expect(weather.current.temperature, isNotNull);
    expect(weather.current.relativeHumidity, isNotNull);
    expect(weather.current.apparentTemperature, isNotNull);
    expect(weather.current.precipitation, isNotNull);
    expect(weather.current.windSpeed, isNotNull);
    expect(weather.hourly, isNotEmpty);
    expect(weather.hourly.first.temperature, isNotNull);
    expect(weather.daily, isNotEmpty);
    expect(weather.daily.first.time, isNotEmpty);
    expect(weather.daily.first.tempMax, isNotNull);
    expect(weather.daily.first.tempMin, isNotNull);
  });
}
