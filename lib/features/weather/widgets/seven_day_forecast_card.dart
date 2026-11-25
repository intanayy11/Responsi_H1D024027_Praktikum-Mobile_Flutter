import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/weather_code_helper.dart';
import '../../../data/models/daily_forecast_model.dart';
import '../views/seven_day_forecast_screen.dart';

class SevenDayForecastCard extends StatelessWidget {
  final List<DailyForecastModel> dailyForecasts;

  const SevenDayForecastCard({
    super.key,
    required this.dailyForecasts,
  });

  String _formatDate(String dateStr, int index) {
    if (index == 0) return 'Today';
    if (index == 1) return 'Tomorrow';
    try {
      final dt = DateTime.parse(dateStr);
      return DateFormat('EEEE').format(dt);
    } catch (_) {
      return 'Day ${index + 1}';
    }
  }

  void _openSevenDayPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SevenDayForecastScreen(
          dailyForecasts: dailyForecasts,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (dailyForecasts.isEmpty) return const SizedBox.shrink();

    final previewDays = dailyForecasts.take(3).toList();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF13233F).withAlpha(190),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withAlpha(20),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Calendar Icon, Title, and "See all >"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    color: Colors.white70,
                    size: 16,
                  ),
                  SizedBox(width: 8),
                  Text(
                    '7-day forecast',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => _openSevenDayPage(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Row(
                    children: [
                      Text(
                        'See all',
                        style: TextStyle(
                          color: Colors.white.withAlpha(190),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white.withAlpha(190),
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 3 Daily Rows (Today, Tomorrow, Saturday/Day 3)
          ...List.generate(previewDays.length, (index) {
            final day = previewDays[index];
            final weatherInfo = WeatherCodeHelper.getInfo(day.weatherCode);
            final dateLabel = _formatDate(day.time, index);

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 9.0),
              child: Row(
                children: [
                  // Day Name
                  SizedBox(
                    width: 88,
                    child: Text(
                      dateLabel,
                      style: TextStyle(
                        color: index == 0 ? Colors.white : Colors.white.withAlpha(210),
                        fontSize: 14,
                        fontWeight: index == 0 ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                  ),

                  // Weather Icon
                  Icon(
                    weatherInfo.icon,
                    size: 20,
                    color: weatherInfo.iconColor,
                  ),
                  const SizedBox(width: 16),

                  // Low Temp
                  SizedBox(
                    width: 32,
                    child: Text(
                      '${day.tempMin.round()}°',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.white.withAlpha(180),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Gradient Temperature Range Bar
                  Expanded(
                    child: Container(
                      height: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: Colors.white.withAlpha(15),
                      ),
                      child: Row(
                        children: [
                          const Spacer(flex: 1),
                          Expanded(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF38BDF8),
                                    Color(0xFFF97316),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const Spacer(flex: 1),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // High Temp
                  SizedBox(
                    width: 32,
                    child: Text(
                      '${day.tempMax.round()}°',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 12),

          // Bottom Action Button "7-day forecast"
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => _openSevenDayPage(context),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withAlpha(22),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                '7-day forecast',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
