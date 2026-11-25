import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/weather_model.dart';

class WeatherService {
  final http.Client _client;

  WeatherService({http.Client? client}) : _client = client ?? http.Client();

  Future<WeatherModel> getWeatherForecast({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.parse(ApiConstants.weatherForecastEndpoint).replace(
      queryParameters: {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'current': ApiConstants.currentFields,
        'hourly': ApiConstants.hourlyFields,
        'daily': ApiConstants.dailyFields,
        'timezone': ApiConstants.timezoneAuto,
      },
    );

    try {
      final response = await _client.get(uri).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return WeatherModel.fromJson(data);
      } else {
        throw HttpException(
          'Gagal mengambil data cuaca. Kode respon: ${response.statusCode}',
        );
      }
    } on SocketException {
      throw const SocketException(
        'Tidak dapat terhubung ke internet. Periksa koneksi Anda.',
      );
    } on TimeoutException {
      throw TimeoutException('Koneksi waktu habis saat memuat data cuaca.');
    } catch (e) {
      if (e is SocketException || e is TimeoutException || e is HttpException) {
        rethrow;
      }
      throw Exception('Terjadi kesalahan saat memproses data cuaca: $e');
    }
  }
}
