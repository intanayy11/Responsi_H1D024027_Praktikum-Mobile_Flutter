import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/view_state.dart';
import '../../../core/utils/weather_code_helper.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../data/models/location_model.dart';
import '../../weather/viewmodels/weather_viewmodel.dart';
import '../viewmodels/saved_locations_viewmodel.dart';
import '../viewmodels/search_viewmodel.dart';
import 'location_preview_screen.dart';

class SearchAndSaveScreen extends StatefulWidget {
  final ValueChanged<LocationModel> onLocationSelected;

  const SearchAndSaveScreen({
    super.key,
    required this.onLocationSelected,
  });

  @override
  State<SearchAndSaveScreen> createState() => _SearchAndSaveScreenState();
}

class _SearchAndSaveScreenState extends State<SearchAndSaveScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchVm = context.watch<SearchViewModel>();
    final savedVm = context.watch<SavedLocationsViewModel>();
    final weatherVm = context.watch<WeatherViewModel>();

    final isSearching = _searchController.text.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFF0C1628),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar: Back Button
              Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              const Text(
                'Manage cities',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 18),

              // Search Bar "Enter location"
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF162540).withAlpha(220),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: Colors.white.withAlpha(20),
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  onChanged: (val) {
                    setState(() {}); // Trigger rebuild to update isSearching
                    searchVm.onQueryChanged(val);
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter location',
                    hintStyle: TextStyle(
                      color: Colors.white.withAlpha(140),
                      fontSize: 15,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: Colors.white.withAlpha(160),
                      size: 22,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close_rounded, color: Colors.white70),
                            onPressed: () {
                              _searchController.clear();
                              searchVm.clearSearch();
                              setState(() {});
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Dynamic Body: Search Results or Manage Cities list
              Expanded(
                child: isSearching
                    ? _buildSearchResults(context, searchVm, savedVm)
                    : _buildManageCitiesList(context, weatherVm, savedVm),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 1. Tampilan Hasil Pencarian (Ketika pengguna sedang mengetik)
  Widget _buildSearchResults(
    BuildContext context,
    SearchViewModel searchVm,
    SavedLocationsViewModel savedVm,
  ) {
    if (searchVm.isLoading) {
      return const LoadingWidget(message: 'Searching locations...');
    }

    if (searchVm.state == ViewState.error) {
      return ErrorStateWidget(
        message: searchVm.errorMessage ?? 'Search failed',
        onRetry: () => searchVm.search(_searchController.text),
      );
    }

    if (searchVm.state == ViewState.empty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_off_rounded,
              size: 56,
              color: Colors.white.withAlpha(120),
            ),
            const SizedBox(height: 14),
            const Text(
              'No locations found',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Please try with another city name.',
              style: TextStyle(
                color: Colors.white.withAlpha(160),
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }

    if (searchVm.hasResults) {
      final results = searchVm.searchResults;
      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: results.length,
        itemBuilder: (context, index) {
          final loc = results[index];
          final alreadySaved = savedVm.isSaved(loc);

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF13233F).withAlpha(190),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withAlpha(15)),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.skyBlue.withAlpha(20),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.location_city_rounded,
                  color: AppColors.skyBlue,
                  size: 20,
                ),
              ),
              title: Text(
                loc.country != null && loc.country!.isNotEmpty
                    ? '${loc.name}, ${loc.country}'
                    : loc.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                loc.admin1 ?? loc.country ?? '',
                style: TextStyle(
                  color: Colors.white.withAlpha(160),
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: alreadySaved
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.green.withAlpha(40),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Saved',
                        style: TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : const Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white54,
                    ),
              onTap: () async {
                // Alur: Buka LocationPreviewScreen dengan Cancel dan Save button
                final saved = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LocationPreviewScreen(location: loc),
                  ),
                );

                if (!context.mounted) return;
                if (saved == true) {
                  // Jika pengguna menekan Save: tetap di Manage Cities
                  // agar mereka bisa melihat kota baru muncul di Added Locations
                  _searchController.clear();
                  searchVm.clearSearch();
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${loc.name} saved to your locations!',
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: const Color(0xFF1E3A5F),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
          );
        },
      );
    }

    return const SizedBox.shrink();
  }

  // 2. Tampilan Default Manage Cities (Current Location + Added Locations)
  Widget _buildManageCitiesList(
    BuildContext context,
    WeatherViewModel weatherVm,
    SavedLocationsViewModel savedVm,
  ) {
    final currentLoc = weatherVm.currentLocation;
    final currentWeather = weatherVm.weather;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section: Current Location
          if (currentLoc != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Current location',
                  style: TextStyle(
                    color: Colors.white.withAlpha(160),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // GPS Refresh Button
                GestureDetector(
                  onTap: weatherVm.isLocatingGPS
                      ? null
                      : () async {
                          await weatherVm.refreshCurrentLocation();
                          if (context.mounted && weatherVm.gpsErrorMessage != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  weatherVm.gpsErrorMessage!,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor: const Color(0xFF7F1D1D),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          }
                        },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.skyBlue.withAlpha(30),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        weatherVm.isLocatingGPS
                            ? const SizedBox(
                                width: 12,
                                height: 12,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.skyBlue,
                                ),
                              )
                            : const Icon(
                                Icons.my_location_rounded,
                                color: AppColors.skyBlue,
                                size: 13,
                              ),
                        const SizedBox(width: 5),
                        Text(
                          weatherVm.isLocatingGPS ? 'Locating...' : 'Update GPS',
                          style: const TextStyle(
                            color: AppColors.skyBlue,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            _buildCityCard(
              location: currentLoc,
              isCurrent: true,
              weather: currentWeather?.current,
              highTemp: currentWeather?.daily.isNotEmpty == true ? currentWeather?.daily.first.tempMax : null,
              lowTemp: currentWeather?.daily.isNotEmpty == true ? currentWeather?.daily.first.tempMin : null,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 24),
          ],

          // Section: Added Locations
          Text(
            'Added locations',
            style: TextStyle(
              color: Colors.white.withAlpha(160),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),

          if (savedVm.isEmpty)
            _buildEmptyAddedLocations()
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: savedVm.savedLocations.length,
              itemBuilder: (context, index) {
                final loc = savedVm.savedLocations[index];
                final weather = savedVm.getWeatherForLocation(loc);
                final daily = savedVm.getDailyForLocation(loc);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: _buildCityCard(
                    location: loc,
                    isCurrent: false,
                    weather: weather,
                    highTemp: daily?.tempMax,
                    lowTemp: daily?.tempMin,
                    onTap: () async {
                      // Pilih lokasi ini sebagai lokasi aktif dan kembali ke Home
                      await weatherVm.selectLocation(loc);
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    onDelete: () => _confirmDeleteLocation(context, savedVm, loc),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  // City Card matching MIUI / Xiaomi Weather Manage Cities style
  Widget _buildCityCard({
    required LocationModel location,
    required bool isCurrent,
    dynamic weather,
    double? highTemp,
    double? lowTemp,
    required VoidCallback onTap,
    VoidCallback? onDelete,
  }) {
    String conditionName = 'Loading...';
    double temp = 0;
    bool hasWeather = false;

    if (weather != null) {
      temp = weather.temperature;
      final info = WeatherCodeHelper.getInfo(weather.weatherCode);
      conditionName = info.descriptionEn;
      hasWeather = true;
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF13233F).withAlpha(220),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withAlpha(25),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left: City Name + Pin Icon, Condition
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              location.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.2,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isCurrent) ...[
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 16,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        conditionName,
                        style: TextStyle(
                          color: Colors.white.withAlpha(160),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                // Right: Temperature, High/Low, and Optional Delete icon
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          hasWeather ? '${temp.round()}°' : '--°',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w300,
                            height: 1.0,
                          ),
                        ),
                        if (highTemp != null && lowTemp != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            '${highTemp.round()}° / ${lowTemp.round()}°',
                            style: TextStyle(
                              color: Colors.white.withAlpha(140),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (onDelete != null) ...[
                      const SizedBox(width: 12),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          color: Color(0xFFF87171),
                          size: 20,
                        ),
                        tooltip: 'Remove',
                        onPressed: onDelete,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyAddedLocations() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      decoration: BoxDecoration(
        color: const Color(0xFF13233F).withAlpha(140),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withAlpha(15),
        ),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.cloud_outlined,
                size: 48,
                color: Colors.white.withAlpha(60),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Icon(
                  Icons.wb_sunny_outlined,
                  size: 24,
                  color: Colors.amber.withAlpha(160),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Search for a city and tap Save to add it here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDeleteLocation(
    BuildContext context,
    SavedLocationsViewModel savedVm,
    LocationModel location,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF13233F),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Remove City',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Remove "${location.name}" from your added locations?',
          style: TextStyle(color: Colors.white.withAlpha(200)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Remove', style: TextStyle(color: Color(0xFFF87171))),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await savedVm.removeLocation(location);
    }
  }
}
