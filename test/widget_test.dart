import 'package:flutter_test/flutter_test.dart';
import 'package:skycast/core/utils/weather_code_helper.dart';
import 'package:skycast/core/utils/date_formatter.dart';
import 'package:skycast/data/models/location_model.dart';
import 'package:skycast/data/models/weather_model.dart';

void main() {
  group('WeatherCodeHelper Tests', () {
    test('Translates WMO codes accurately', () {
      final clear = WeatherCodeHelper.getInfo(0);
      expect(clear.descriptionId, 'Cerah');
      expect(clear.descriptionEn, 'Clear Sky');

      final rain = WeatherCodeHelper.getInfo(63);
      expect(rain.descriptionId, 'Hujan Sedang');

      final storm = WeatherCodeHelper.getInfo(95);
      expect(storm.descriptionId, 'Badai Petir');

      final unknown = WeatherCodeHelper.getInfo(999);
      expect(unknown.descriptionId, 'Cuaca Tidak Diketahui');
    });
  });

  group('DateFormatter Tests', () {
    test('Formats date and forecast day correctly', () {
      expect(DateFormatter.formatForecastDay('2026-11-25', isToday: true), 'Hari Ini');
      final formatted = DateFormatter.formatForecastDay('2026-11-26');
      expect(formatted, contains('Kam'));
    });
  });

  group('Data Models Tests', () {
    test('LocationModel parsing and serialization', () {
      final json = {
        'id': 1642911,
        'name': 'Jakarta',
        'latitude': -6.21462,
        'longitude': 106.84513,
        'country': 'Indonesia',
        'admin1': 'Jakarta',
      };

      final location = LocationModel.fromJson(json);
      expect(location.id, 1642911);
      expect(location.name, 'Jakarta');
      expect(location.latitude, -6.21462);
      expect(location.longitude, 106.84513);
      expect(location.formattedSubtitle, 'Indonesia');

      final serialized = location.toJson();
      expect(serialized['name'], 'Jakarta');
    });

    test('WeatherModel and HourlyForecastModel parsing', () {
      final json = {
        'latitude': -6.2,
        'longitude': 106.8,
        'timezone': 'Asia/Jakarta',
        'current': {
          'temperature_2m': 29.5,
          'relative_humidity_2m': 78,
          'apparent_temperature': 33.2,
          'precipitation': 1.5,
          'weather_code': 61,
          'wind_speed_10m': 12.4,
          'time': '2026-11-25T14:00',
        },
        'hourly': {
          'time': ['2026-11-25T14:00', '2026-11-25T15:00'],
          'temperature_2m': [29.5, 30.0],
          'relative_humidity_2m': [78, 75],
          'precipitation_probability': [60, 20],
          'weather_code': [61, 2],
          'wind_speed_10m': [12.4, 10.5],
        },
        'daily': {
          'time': ['2026-11-25', '2026-11-26'],
          'weather_code': [61, 0],
          'temperature_2m_max': [32.0, 33.0],
          'temperature_2m_min': [24.0, 25.0],
          'precipitation_probability_max': [80, 20],
        },
      };

      final weather = WeatherModel.fromJson(json);
      expect(weather.current.temperature, 29.5);
      expect(weather.current.relativeHumidity, 78);
      expect(weather.current.apparentTemperature, 33.2);
      expect(weather.current.precipitation, 1.5);
      expect(weather.current.weatherCode, 61);
      expect(weather.current.windSpeed, 12.4);

      expect(weather.hourly.length, 2);
      expect(weather.hourly[0].temperature, 29.5);
      expect(weather.hourly[0].precipitationProbability, 60);

      expect(weather.daily.length, 2);
      expect(weather.daily[0].tempMax, 32.0);
      expect(weather.daily[0].precipitationProbabilityMax, 80);
      expect(weather.daily[1].weatherCode, 0);
    });
  });
}
