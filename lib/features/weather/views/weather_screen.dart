import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/weather_code_helper.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../viewmodels/weather_viewmodel.dart';
import '../widgets/hourly_forecast_card.dart';
import '../widgets/seven_day_forecast_card.dart';
import '../widgets/weather_hero_card.dart';
import '../widgets/weather_metrics_grid.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherVm = context.watch<WeatherViewModel>();
    final current = weatherVm.weather?.current;
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
          child: Builder(
            builder: (context) {
              if (weatherVm.isLoading && !weatherVm.hasData) {
                return const LoadingWidget(
                  message: 'Loading live weather data...',
                );
              }

              if (weatherVm.hasError && !weatherVm.hasData) {
                return ErrorStateWidget(
                  message: weatherVm.errorMessage ?? AppStrings.errorGeneral,
                  onRetry: () => weatherVm.fetchWeather(),
                );
              }

              if (weatherVm.weather != null && weatherVm.currentLocation != null) {
                final weather = weatherVm.weather!;
                final location = weatherVm.currentLocation!;

                return RefreshIndicator(
                  onRefresh: () => weatherVm.refresh(),
                  color: AppColors.skyBlue,
                  backgroundColor: const Color(0xFF13233F),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 12.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Hero Weather Card (Header with '+' button, Big Temp & Condition)
                        WeatherHeroCard(
                          location: location,
                          weather: weather,
                        ),
                        SizedBox(
                          height: (MediaQuery.sizeOf(context).height * 0.16)
                              .clamp(110.0, 200.0),
                        ),

                        // 2. 7-Day Forecast Card (3 hari ringkas + See all)
                        SevenDayForecastCard(
                          dailyForecasts: weather.daily,
                        ),
                        const SizedBox(height: 22),

                        // 3. Hourly Forecast Card (24-Hour Scrolling)
                        HourlyForecastCard(
                          hourlyForecasts: weather.hourly,
                        ),
                        const SizedBox(height: 22),

                        // 4. Metric Cards (Real feel, Humidity, Wind speed, Precipitation)
                        WeatherMetricsGrid(
                          current: weather.current,
                        ),
                        const SizedBox(height: 28),
                      ],
                    ),
                  ),
                );
              }

              return const LoadingWidget();
            },
          ),
        ),
      ),
    );
  }
}
