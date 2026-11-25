class ApiConstants {
  ApiConstants._();

  static const String geocodingBaseUrl = 'https://geocoding-api.open-meteo.com/v1';
  static const String weatherBaseUrl = 'https://api.open-meteo.com/v1';

  static const String geocodingSearchEndpoint = '$geocodingBaseUrl/search';
  static const String weatherForecastEndpoint = '$weatherBaseUrl/forecast';

  // Default parameters
  static const String currentFields =
      'temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m';
  static const String hourlyFields =
      'temperature_2m,relative_humidity_2m,precipitation_probability,weather_code,wind_speed_10m';
  static const String dailyFields =
      'weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max';
  static const String timezoneAuto = 'auto';

  // Default Location (Jakarta, Indonesia)
  static const String defaultCityName = 'Jakarta';
  static const String defaultCountry = 'Indonesia';
  static const String defaultAdmin1 = 'Jakarta';
  static const double defaultLatitude = -6.2088;
  static const double defaultLongitude = 106.8456;
}
