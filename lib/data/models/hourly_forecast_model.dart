import 'package:intl/intl.dart';

class HourlyForecastModel {
  final String time;
  final double temperature;
  final int relativeHumidity;
  final int precipitationProbability;
  final int weatherCode;
  final double windSpeed;

  const HourlyForecastModel({
    required this.time,
    required this.temperature,
    required this.relativeHumidity,
    required this.precipitationProbability,
    required this.weatherCode,
    required this.windSpeed,
  });

  factory HourlyForecastModel.fromHourlyJson({
    required Map<String, dynamic> hourlyJson,
    required int index,
  }) {
    final times = hourlyJson['time'] as List<dynamic>? ?? [];
    final temps = hourlyJson['temperature_2m'] as List<dynamic>? ?? [];
    final humidities = hourlyJson['relative_humidity_2m'] as List<dynamic>? ?? [];
    final precipProbs = hourlyJson['precipitation_probability'] as List<dynamic>? ?? [];
    final codes = hourlyJson['weather_code'] as List<dynamic>? ?? [];
    final windSpeeds = hourlyJson['wind_speed_10m'] as List<dynamic>? ?? [];

    return HourlyForecastModel(
      time: index < times.length ? times[index].toString() : '',
      temperature: index < temps.length ? (temps[index] as num).toDouble() : 0.0,
      relativeHumidity: index < humidities.length ? (humidities[index] as num).round() : 0,
      precipitationProbability: index < precipProbs.length
          ? (precipProbs[index] as num?)?.round() ?? 0
          : 0,
      weatherCode: index < codes.length ? (codes[index] as num).toInt() : 0,
      windSpeed: index < windSpeeds.length ? (windSpeeds[index] as num).toDouble() : 0.0,
    );
  }

  static List<HourlyForecastModel> listFromJson(
    Map<String, dynamic>? hourlyJson, {
    int limit = 24,
  }) {
    if (hourlyJson == null) return [];
    final times = hourlyJson['time'] as List<dynamic>? ?? [];
    if (times.isEmpty) return [];

    final now = DateTime.now();
    // Cari index jam saat ini atau paling mendekati
    int startIndex = 0;
    for (int i = 0; i < times.length; i++) {
      try {
        final dt = DateTime.parse(times[i].toString());
        if (dt.isAfter(now.subtract(const Duration(minutes: 30)))) {
          startIndex = i;
          break;
        }
      } catch (_) {}
    }

    final list = <HourlyForecastModel>[];
    final endIndex = (startIndex + limit) > times.length ? times.length : (startIndex + limit);

    for (int i = startIndex; i < endIndex; i++) {
      list.add(HourlyForecastModel.fromHourlyJson(hourlyJson: hourlyJson, index: i));
    }
    return list;
  }

  String get formattedHour {
    try {
      final dt = DateTime.parse(time);
      final now = DateTime.now();
      if (dt.year == now.year &&
          dt.month == now.month &&
          dt.day == now.day &&
          dt.hour == now.hour) {
        return 'Now';
      }
      return DateFormat('HH:mm').format(dt);
    } catch (_) {
      return time;
    }
  }

  bool get isNow {
    try {
      final dt = DateTime.parse(time);
      final now = DateTime.now();
      return dt.year == now.year &&
          dt.month == now.month &&
          dt.day == now.day &&
          dt.hour == now.hour;
    } catch (_) {
      return false;
    }
  }
}
