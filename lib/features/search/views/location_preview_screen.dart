import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/view_state.dart';
import '../../../core/utils/weather_code_helper.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../data/models/location_model.dart';
import '../../../data/models/weather_model.dart';
import '../../../data/repositories/weather_repository.dart';
import '../../search/viewmodels/saved_locations_viewmodel.dart';
import '../../weather/widgets/hourly_forecast_card.dart';
import '../../weather/widgets/seven_day_forecast_card.dart';
import '../../weather/widgets/weather_metrics_grid.dart';

class LocationPreviewScreen extends StatefulWidget {
  final LocationModel location;

  const LocationPreviewScreen({
    super.key,
    required this.location,
  });

  @override
  State<LocationPreviewScreen> createState() => _LocationPreviewScreenState();
}

class _LocationPreviewScreenState extends State<LocationPreviewScreen> {
  WeatherModel? _weather;
  ViewState _state = ViewState.loading;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchPreviewWeather();
  }

  Future<void> _fetchPreviewWeather() async {
    setState(() {
      _state = ViewState.loading;
      _errorMessage = null;
    });

    try {
      final weatherRepo = WeatherRepository();
      final result = await weatherRepo.getWeather(
        latitude: widget.location.latitude,
        longitude: widget.location.longitude,
      );
      if (mounted) {
        setState(() {
          _weather = result;
          _state = ViewState.success;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _state = ViewState.error;
          _errorMessage = 'Gagal memuat data cuaca: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = _weather?.current;
    final bgColors = current != null
        ? WeatherCodeHelper.getBackgroundGradient(
            current.weatherCode,
            currentTimeIso: current.time,
          )
        : const [
            Color(0xFF0B1424),
            Color(0xFF13233F),
            Color(0xFF192F56),
          ];

    return Scaffold(
      backgroundColor: bgColors.first,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.45, 1.0],
            colors: bgColors,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Action Bar with Cancel & Save buttons (Matching Reference Preview Image)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Cancel Pill Button
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E2D4A).withAlpha(200),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.white.withAlpha(25)),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),

                    // Save / Add Pill Button
                    ElevatedButton(
                      onPressed: _state == ViewState.success && _weather != null
                          ? () async {
                              final savedVm = context.read<SavedLocationsViewModel>();
                              final current = _weather!.current;
                              final todayDaily = _weather!.daily.isNotEmpty
                                  ? _weather!.daily.first
                                  : null;

                              // 1. Simpan ke daftar lokasi tersimpan dengan data cuaca langsung di cache
                              await savedVm.saveLocationWithWeather(
                                widget.location,
                                current: current,
                                todayDaily: todayDaily,
                              );

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${widget.location.name} berhasil ditambahkan ke Added locations'),
                                    backgroundColor: const Color(0xFF0284C7),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );
                                // Tutup halaman preview dan beri sinyal sukses ke halaman Manage Cities
                                Navigator.pop(context, true);
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0284C7),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

              // Main Body Content
              Expanded(
                child: _buildBody(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_state == ViewState.loading) {
      return const LoadingWidget(message: 'Memuat data cuaca...');
    }

    if (_state == ViewState.error || _weather == null) {
      return ErrorStateWidget(
        message: _errorMessage ?? 'Terjadi kesalahan saat memuat preview cuaca.',
        onRetry: _fetchPreviewWeather,
      );
    }

    final current = _weather!.current;
    final daily = _weather!.daily;
    final weatherInfo = WeatherCodeHelper.getInfo(current.weatherCode);

    double highTemp = current.temperature;
    double lowTemp = current.temperature;
    if (daily.isNotEmpty) {
      highTemp = daily.first.tempMax;
      lowTemp = daily.first.tempMin;
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. City Name
          Text(
            widget.location.country != null && widget.location.country!.isNotEmpty
                ? '${widget.location.name}, ${widget.location.country}'
                : widget.location.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 12),

          // 2. Huge Temperature
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${current.temperature.round()}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 88,
                  fontWeight: FontWeight.w200,
                  height: 0.95,
                  letterSpacing: -2,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8.0, left: 4.0),
                child: Text(
                  '°',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 52,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // 3. Condition & High/Low (e.g. Overcast 31° / 25°)
          Text(
            '${weatherInfo.descriptionEn}  ${highTemp.round()}° / ${lowTemp.round()}°',
            style: TextStyle(
              color: Colors.white.withAlpha(220),
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Feels like ${current.apparentTemperature.round()}°C',
            style: TextStyle(
              color: Colors.white.withAlpha(150),
              fontSize: 14,
            ),
          ),
          SizedBox(
            height: (MediaQuery.sizeOf(context).height * 0.15)
                .clamp(100.0, 190.0),
          ),

          // 4. 7-Day Forecast Card (3 hari ringkas + See all)
          SevenDayForecastCard(dailyForecasts: _weather!.daily),
          const SizedBox(height: 22),

          // 5. Hourly Forecast
          HourlyForecastCard(hourlyForecasts: _weather!.hourly),
          const SizedBox(height: 22),

          // 6. Metric Cards (Real feel, Humidity, Wind speed, Precipitation)
          WeatherMetricsGrid(current: current),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
