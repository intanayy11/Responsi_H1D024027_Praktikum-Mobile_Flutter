import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/view_state.dart';
import '../../../data/models/location_model.dart';
import '../../../data/models/weather_model.dart';
import '../../../data/repositories/location_repository.dart';
import '../../../data/repositories/weather_repository.dart';
import '../../../data/services/device_location_service.dart';

class WeatherViewModel extends ChangeNotifier {
  final WeatherRepository _weatherRepository;
  final LocationRepository _locationRepository;
  final DeviceLocationService _deviceLocationService;

  WeatherViewModel({
    WeatherRepository? weatherRepository,
    LocationRepository? locationRepository,
    DeviceLocationService? deviceLocationService,
  })  : _weatherRepository = weatherRepository ?? WeatherRepository(),
        _locationRepository = locationRepository ?? LocationRepository(),
        _deviceLocationService = deviceLocationService ?? DeviceLocationService();

  ViewState _state = ViewState.initial;
  LocationModel? _currentLocation;
  WeatherModel? _weather;
  String? _errorMessage;
  DateTime? _lastUpdated;

  // GPS state tracking
  bool _isLocatingGPS = false;
  String? _gpsErrorMessage;

  ViewState get state => _state;
  LocationModel? get currentLocation => _currentLocation;
  WeatherModel? get weather => _weather;
  String? get errorMessage => _errorMessage;
  DateTime? get lastUpdated => _lastUpdated;
  bool get isLocatingGPS => _isLocatingGPS;
  String? get gpsErrorMessage => _gpsErrorMessage;

  bool get isLoading => _state == ViewState.loading;
  bool get hasData => _state == ViewState.success && _weather != null;
  bool get hasError => _state == ViewState.error;

  /// Inisialisasi lokasi awal: coba GPS dulu, fallback ke lastLocation atau Jakarta
  Future<void> init() async {
    // Coba ambil lokasi GPS secara diam-diam (silent)
    final gpsLocation = await _deviceLocationService.getCurrentDeviceLocation();

    if (gpsLocation != null) {
      _currentLocation = gpsLocation;
      await _locationRepository.saveLastLocation(gpsLocation);
    } else {
      // Fallback: lokasi terakhir dari SharedPreferences atau default Jakarta
      final lastLocation = await _locationRepository.getLastLocation();
      _currentLocation = lastLocation ??
          const LocationModel(
            name: ApiConstants.defaultCityName,
            country: ApiConstants.defaultCountry,
            admin1: ApiConstants.defaultAdmin1,
            latitude: ApiConstants.defaultLatitude,
            longitude: ApiConstants.defaultLongitude,
          );
    }

    await fetchWeather();
  }

  /// Memperbarui lokasi GPS secara manual (dipanggil dari UI / tombol refresh)
  Future<void> refreshCurrentLocation() async {
    _isLocatingGPS = true;
    _gpsErrorMessage = null;
    notifyListeners();

    try {
      final gpsLocation = await _deviceLocationService.getCurrentDeviceLocation();

      if (gpsLocation != null) {
        _currentLocation = gpsLocation;
        await _locationRepository.saveLastLocation(gpsLocation);
        _gpsErrorMessage = null;
        // Langsung ambil cuaca setelah lokasi diperbarui
        await fetchWeather();
      } else {
        _gpsErrorMessage = 'Could not get GPS location. Please enable Location Services and grant permission.';
        notifyListeners();
      }
    } catch (_) {
      _gpsErrorMessage = 'GPS error. Please try again.';
      notifyListeners();
    } finally {
      _isLocatingGPS = false;
      notifyListeners();
    }
  }

  /// Memilih lokasi baru dan langsung mengambil data cuaca
  Future<void> selectLocation(LocationModel location) async {
    _currentLocation = location;
    await _locationRepository.saveLastLocation(location);
    notifyListeners();
    await fetchWeather();
  }

  /// Mengambil data cuaca terkini dan prakiraan harian dari API Open-Meteo
  Future<void> fetchWeather({bool isRefresh = false}) async {
    if (_currentLocation == null) return;

    if (!isRefresh) {
      _state = ViewState.loading;
      _errorMessage = null;
      notifyListeners();
    }

    try {
      final result = await _weatherRepository.getWeather(
        latitude: _currentLocation!.latitude,
        longitude: _currentLocation!.longitude,
      );

      _weather = result;
      _lastUpdated = DateTime.now();
      _state = ViewState.success;
      _errorMessage = null;
    } on SocketException {
      _state = ViewState.error;
      _errorMessage = AppStrings.errorNetwork;
    } on TimeoutException {
      _state = ViewState.error;
      _errorMessage = AppStrings.errorTimeout;
    } on HttpException catch (e) {
      _state = ViewState.error;
      _errorMessage = e.message;
    } catch (e) {
      _state = ViewState.error;
      _errorMessage = '${AppStrings.errorGeneral} (${e.toString()})';
    } finally {
      notifyListeners();
    }
  }

  /// Memuat ulang data cuaca saat pull-to-refresh
  Future<void> refresh() async {
    await fetchWeather(isRefresh: true);
  }
}
