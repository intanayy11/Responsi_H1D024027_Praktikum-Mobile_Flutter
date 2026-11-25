import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/view_state.dart';
import '../../../core/utils/debounce.dart';
import '../../../data/models/location_model.dart';
import '../../../data/repositories/location_repository.dart';

class SearchViewModel extends ChangeNotifier {
  final LocationRepository _locationRepository;
  final Debouncer _debouncer = Debouncer(delay: const Duration(milliseconds: 500));

  SearchViewModel({LocationRepository? locationRepository})
      : _locationRepository = locationRepository ?? LocationRepository();

  ViewState _state = ViewState.initial;
  List<LocationModel> _searchResults = [];
  String? _errorMessage;
  String _currentQuery = '';

  ViewState get state => _state;
  List<LocationModel> get searchResults => _searchResults;
  String? get errorMessage => _errorMessage;
  String get currentQuery => _currentQuery;

  bool get isLoading => _state == ViewState.loading;
  bool get isEmpty => _state == ViewState.empty;
  bool get hasResults => _state == ViewState.success && _searchResults.isNotEmpty;

  /// Dipanggil setiap teks input pencarian berubah dengan debounce
  void onQueryChanged(String query) {
    _currentQuery = query;
    if (query.trim().isEmpty) {
      _debouncer.cancel();
      _searchResults = [];
      _state = ViewState.initial;
      _errorMessage = null;
      notifyListeners();
      return;
    }

    _state = ViewState.loading;
    notifyListeners();

    _debouncer.run(() {
      search(query);
    });
  }

  /// Eksekusi pencarian lokasi via Geocoding API
  Future<void> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      _searchResults = [];
      _state = ViewState.initial;
      notifyListeners();
      return;
    }

    _state = ViewState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await _locationRepository.search(trimmed);
      _searchResults = results;

      if (results.isEmpty) {
        _state = ViewState.empty;
      } else {
        _state = ViewState.success;
      }
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

  /// Menghapus kata kunci pencarian dan membersihkan daftar hasil
  void clearSearch() {
    _debouncer.cancel();
    _currentQuery = '';
    _searchResults = [];
    _state = ViewState.initial;
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _debouncer.cancel();
    super.dispose();
  }
}
