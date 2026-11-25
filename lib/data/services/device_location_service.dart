import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../models/location_model.dart';

class DeviceLocationService {
  /// Mendapatkan lokasi perangkat saat ini dan mengonversinya ke LocationModel
  Future<LocationModel?> getCurrentDeviceLocation() async {
    try {
      // 1. Periksa apakah GPS / Location Service aktif di perangkat
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      // 2. Periksa dan minta izin akses lokasi
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      // 3. Ambil koordinat GPS perangkat
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
        ),
      );

      // 4. Reverse Geocoding via Nominatim (OpenStreetMap) HTTP API
      //    Tidak membutuhkan package geocoding, cukup dengan package http yang sudah ada
      String cityName = 'Current Location';
      String? countryName;
      String? adminArea;

      try {
        final uri = Uri.parse(
          'https://nominatim.openstreetmap.org/reverse'
          '?lat=${position.latitude}&lon=${position.longitude}'
          '&format=json&accept-language=id',
        );

        final response = await http.get(
          uri,
          headers: {'User-Agent': 'SkyCast-WeatherApp/1.0'},
        ).timeout(const Duration(seconds: 8));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          final address = data['address'] as Map<String, dynamic>?;

          if (address != null) {
            // Prioritaskan: city > town > village > county > state
            cityName = address['city'] as String? ??
                address['town'] as String? ??
                address['village'] as String? ??
                address['county'] as String? ??
                address['state'] as String? ??
                'Current Location';

            countryName = address['country'] as String?;
            adminArea = address['state'] as String?;
          }
        }
      } catch (_) {
        // Jika reverse geocoding gagal, gunakan nama default
      }

      return LocationModel(
        name: cityName,
        latitude: position.latitude,
        longitude: position.longitude,
        country: countryName,
        admin1: adminArea,
      );
    } catch (_) {
      return null;
    }
  }
}
