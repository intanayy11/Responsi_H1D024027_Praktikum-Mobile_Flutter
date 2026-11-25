class DailyForecastModel {
  final String time;
  final int weatherCode;
  final double tempMax;
  final double tempMin;
  final int precipitationProbabilityMax;

  const DailyForecastModel({
    required this.time,
    required this.weatherCode,
    required this.tempMax,
    required this.tempMin,
    required this.precipitationProbabilityMax,
  });

  factory DailyForecastModel.fromDailyJson({
    required Map<String, dynamic> dailyJson,
    required int index,
  }) {
    final times = dailyJson['time'] as List<dynamic>? ?? [];
    final codes = dailyJson['weather_code'] as List<dynamic>? ?? [];
    final maxTemps = dailyJson['temperature_2m_max'] as List<dynamic>? ?? [];
    final minTemps = dailyJson['temperature_2m_min'] as List<dynamic>? ?? [];
    final precipProbs = dailyJson['precipitation_probability_max'] as List<dynamic>? ?? [];

    return DailyForecastModel(
      time: index < times.length ? times[index].toString() : '',
      weatherCode: index < codes.length ? (codes[index] as num).toInt() : 0,
      tempMax: index < maxTemps.length ? (maxTemps[index] as num).toDouble() : 0.0,
      tempMin: index < minTemps.length ? (minTemps[index] as num).toDouble() : 0.0,
      precipitationProbabilityMax: index < precipProbs.length
          ? (precipProbs[index] as num?)?.round() ?? 0
          : 0,
    );
  }

  static List<DailyForecastModel> listFromJson(Map<String, dynamic>? dailyJson) {
    if (dailyJson == null) return [];
    final times = dailyJson['time'] as List<dynamic>? ?? [];
    final list = <DailyForecastModel>[];
    for (int i = 0; i < times.length; i++) {
      list.add(DailyForecastModel.fromDailyJson(dailyJson: dailyJson, index: i));
    }
    return list;
  }
}
