import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/location_model.dart';

class StorageService {
  static const String _favoritesKey = 'skycast_favorites_locations';
  static const String _lastLocationKey = 'skycast_last_selected_location';

  Future<List<LocationModel>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_favoritesKey);
    if (jsonList == null || jsonList.isEmpty) return [];

    return jsonList
        .map((str) => LocationModel.fromJson(jsonDecode(str) as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveFavorites(List<LocationModel> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = favorites.map((loc) => jsonEncode(loc.toJson())).toList();
    await prefs.setStringList(_favoritesKey, jsonList);
  }

  Future<LocationModel?> getLastLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_lastLocationKey);
    if (jsonStr == null || jsonStr.isEmpty) return null;

    try {
      return LocationModel.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveLastLocation(LocationModel location) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastLocationKey, jsonEncode(location.toJson()));
  }
}
