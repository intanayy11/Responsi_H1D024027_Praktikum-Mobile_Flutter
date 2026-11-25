import '../models/location_model.dart';
import '../services/geocoding_service.dart';
import '../services/storage_service.dart';

class LocationRepository {
  final GeocodingService _geocodingService;
  final StorageService _storageService;

  LocationRepository({
    GeocodingService? geocodingService,
    StorageService? storageService,
  })  : _geocodingService = geocodingService ?? GeocodingService(),
        _storageService = storageService ?? StorageService();

  Future<List<LocationModel>> search(String query) {
    return _geocodingService.searchLocations(query);
  }

  Future<List<LocationModel>> getFavorites() {
    return _storageService.getFavorites();
  }

  Future<void> saveFavorites(List<LocationModel> favorites) {
    return _storageService.saveFavorites(favorites);
  }

  Future<LocationModel?> getLastLocation() {
    return _storageService.getLastLocation();
  }

  Future<void> saveLastLocation(LocationModel location) {
    return _storageService.saveLastLocation(location);
  }
}
