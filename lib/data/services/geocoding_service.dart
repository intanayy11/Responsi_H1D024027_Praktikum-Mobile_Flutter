import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/location_model.dart';

class GeocodingService {
  final http.Client _client;

  GeocodingService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<LocationModel>> searchLocations(
    String query, {
    int count = 10,
    String language = 'id',
  }) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return [];

    final uri = Uri.parse(ApiConstants.geocodingSearchEndpoint).replace(
      queryParameters: {
        'name': trimmed,
        'count': count.toString(),
        'language': language,
        'format': 'json',
      },
    );

    try {
      final response = await _client.get(uri).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data.containsKey('results') && data['results'] is List) {
          final results = data['results'] as List<dynamic>;
          return results
              .map((item) => LocationModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        return [];
      } else {
        throw HttpException(
          'Gagal mengambil data lokasi. Kode respon: ${response.statusCode}',
        );
      }
    } on SocketException {
      throw const SocketException(
        'Tidak dapat terhubung ke internet. Periksa koneksi Anda.',
      );
    } on TimeoutException {
      throw TimeoutException('Koneksi waktu habis saat mencari lokasi.');
    } catch (e) {
      if (e is SocketException || e is TimeoutException || e is HttpException) {
        rethrow;
      }
      throw Exception('Terjadi kesalahan saat memproses data lokasi: $e');
    }
  }
}
