import 'package:flutter/material.dart';
import '../../../core/utils/weather_code_helper.dart';
import '../../../data/models/hourly_forecast_model.dart';

class HourlyForecastCard extends StatelessWidget {
  final List<HourlyForecastModel> hourlyForecasts;

  const HourlyForecastCard({
    super.key,
    required this.hourlyForecasts,
  });

  @override
  Widget build(BuildContext context) {
    if (hourlyForecasts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with Clock Icon & Title
        const Row(
          children: [
            Icon(
              Icons.access_time_rounded,
              color: Colors.white,
              size: 18,
            ),
            SizedBox(width: 8),
            Text(
              'Hourly Forecast',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Horizontal Scrolling Pills
        SizedBox(
          height: 125,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: hourlyForecasts.length,
            itemBuilder: (context, index) {
              final item = hourlyForecasts[index];
              final isNow = item.isNow || index == 0;
              final weatherInfo = WeatherCodeHelper.getInfo(item.weatherCode);

              return Container(
                width: 72,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                decoration: BoxDecoration(
                  color: isNow
                      ? const Color(0xFF1E4C90).withAlpha(190)
                      : const Color(0xFF0F2E60).withAlpha(160),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isNow
                        ? const Color(0xFF38BDF8).withAlpha(160)
                        : Colors.white.withAlpha(20),
                    width: isNow ? 1.5 : 1.0,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.formattedHour,
                      style: TextStyle(
                        color: isNow ? Colors.white : Colors.white.withAlpha(200),
                        fontSize: 13,
                        fontWeight: isNow ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                    Icon(
                      weatherInfo.icon,
                      color: weatherInfo.iconColor,
                      size: 26,
                    ),
                    Text(
                      '${item.temperature.round()}°',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${item.precipitationProbability}%',
                      style: TextStyle(
                        color: Colors.white.withAlpha(160),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
