import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'data/repositories/location_repository.dart';
import 'data/repositories/weather_repository.dart';
import 'data/services/geocoding_service.dart';
import 'data/services/storage_service.dart';
import 'data/services/weather_service.dart';
import 'features/search/viewmodels/saved_locations_viewmodel.dart';
import 'features/search/viewmodels/search_viewmodel.dart';
import 'features/weather/viewmodels/weather_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Services dan Repositories
  final geocodingService = GeocodingService();
  final weatherService = WeatherService();
  final storageService = StorageService();

  final locationRepository = LocationRepository(
    geocodingService: geocodingService,
    storageService: storageService,
  );

  final weatherRepository = WeatherRepository(
    weatherService: weatherService,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SavedLocationsViewModel>(
          create: (_) => SavedLocationsViewModel(
            locationRepository: locationRepository,
            weatherRepository: weatherRepository,
          )..loadSavedLocations(),
        ),
        ChangeNotifierProvider<WeatherViewModel>(
          create: (_) => WeatherViewModel(
            weatherRepository: weatherRepository,
            locationRepository: locationRepository,
          )..init(),
        ),
        ChangeNotifierProvider<SearchViewModel>(
          create: (_) => SearchViewModel(
            locationRepository: locationRepository,
          ),
        ),
      ],
      child: const SkyCastApp(),
    ),
  );
}
