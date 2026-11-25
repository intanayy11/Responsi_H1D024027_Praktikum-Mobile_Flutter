import 'package:flutter/foundation.dart';
import '../../../core/constants/view_state.dart';
import '../../../data/models/current_weather_model.dart';
import '../../../data/models/daily_forecast_model.dart';
import '../../../data/models/location_model.dart';
import '../../../data/repositories/location_repository.dart';
import '../../../data/repositories/weather_repository.dart';

class SavedLocationsViewModel extends ChangeNotifier {
  final LocationRepository _locationRepository;
  final WeatherRepository _weatherRepository;

  SavedLocationsViewModel({
    LocationRepository? locationRepository,
    WeatherRepository? weatherRepository,
  })  : _locationRepository = locationRepository ?? LocationRepository(),
        _weatherRepository = weatherRepository ?? WeatherRepository();

  ViewState _state = ViewState.initial;
  List<LocationModel> _savedLocations = [];
  final Map<String, CurrentWeatherModel> _weatherCache = {};
  final Map<String, DailyForecastModel> _dailyCache = {};
  String? _errorMessage;

  ViewState get state => _state;
  List<LocationModel> get savedLocations => _savedLocations;
  Map<String, CurrentWeatherModel> get weatherCache => _weatherCache;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _state == ViewState.loading;
  bool get isEmpty => _state == ViewState.empty || _savedLocations.isEmpty;
  bool get hasLocations => _savedLocations.isNotEmpty;

  String _getLocationKey(LocationModel location) {
    return '${location.name}_${location.latitude.toStringAsFixed(2)}_${location.longitude.toStringAsFixed(2)}';
  }

  CurrentWeatherModel? getWeatherForLocation(LocationModel location) {
    return _weatherCache[_getLocationKey(location)];
  }

  DailyForecastModel? getDailyForLocation(LocationModel location) {
    return _dailyCache[_getLocationKey(location)];
  }

  /// Memuat daftar lokasi yang tersimpan di SharedPreferences
  Future<void> loadSavedLocations() async {
    _state = ViewState.loading;
    notifyListeners();

    try {
      _savedLocations = await _locationRepository.getFavorites();
      if (_savedLocations.isEmpty) {
        _state = ViewState.empty;
      } else {
        _state = ViewState.success;
        // Ambil cuaca singkat untuk setiap lokasi tersimpan secara asinkron
        _fetchWeatherForSavedLocations();
      }
    } catch (e) {
      _state = ViewState.error;
      _errorMessage = 'Gagal memuat lokasi tersimpan: $e';
    } finally {
      notifyListeners();
    }
  }

  Future<void> _fetchWeatherForSavedLocations() async {
    for (final loc in _savedLocations) {
      final key = _getLocationKey(loc);
      if (!_weatherCache.containsKey(key)) {
        try {
          final weather = await _weatherRepository.getWeather(
            latitude: loc.latitude,
            longitude: loc.longitude,
          );
          _weatherCache[key] = weather.current;
          if (weather.daily.isNotEmpty) {
            _dailyCache[key] = weather.daily.first;
          }
          notifyListeners();
        } catch (_) {}
      }
    }
  }

  /// Memeriksa apakah lokasi sudah tersimpan
  bool isSaved(LocationModel location) {
    return _savedLocations.any((item) =>
        (item.id != null && item.id == location.id) ||
        (item.name.toLowerCase() == location.name.toLowerCase() &&
            (item.latitude - location.latitude).abs() < 0.01 &&
            (item.longitude - location.longitude).abs() < 0.01));
  }

  /// Menyimpan lokasi baru ke daftar lokasi tersimpan dengan data cuaca langsung
  Future<bool> saveLocationWithWeather(
    LocationModel location, {
    CurrentWeatherModel? current,
    DailyForecastModel? todayDaily,
  }) async {
    final key = _getLocationKey(location);
    if (current != null) {
      _weatherCache[key] = current;
    }
    if (todayDaily != null) {
      _dailyCache[key] = todayDaily;
    }

    if (!isSaved(location)) {
      _savedLocations.insert(0, location);
      _state = ViewState.success;
      await _locationRepository.saveFavorites(_savedLocations);
    }

    notifyListeners();

    // Jika belum ada cuaca di cache, fetch di background
    if (current == null) {
      try {
        final weather = await _weatherRepository.getWeather(
          latitude: location.latitude,
          longitude: location.longitude,
        );
        _weatherCache[key] = weather.current;
        if (weather.daily.isNotEmpty) {
          _dailyCache[key] = weather.daily.first;
        }
        notifyListeners();
      } catch (_) {}
    }

    return true;
  }

  /// Menyimpan lokasi baru ke daftar lokasi tersimpan
  Future<bool> saveLocation(LocationModel location) async {
    return saveLocationWithWeather(location);
  }

  /// Menghapus lokasi dari daftar lokasi tersimpan
  Future<void> removeLocation(LocationModel location) async {
    _savedLocations.removeWhere((item) =>
        (item.id != null && item.id == location.id) ||
        (item.name.toLowerCase() == location.name.toLowerCase() &&
            (item.latitude - location.latitude).abs() < 0.01 &&
            (item.longitude - location.longitude).abs() < 0.01));

    if (_savedLocations.isEmpty) {
      _state = ViewState.empty;
    } else {
      _state = ViewState.success;
    }

    await _locationRepository.saveFavorites(_savedLocations);
    notifyListeners();
  }
}
