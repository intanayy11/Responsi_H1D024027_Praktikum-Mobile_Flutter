import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/weather_code_helper.dart';
import '../../../data/models/current_weather_model.dart';
import '../../../data/models/location_model.dart';

class SavedLocationCard extends StatelessWidget {
  final LocationModel location;
  final CurrentWeatherModel? weather;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const SavedLocationCard({
    super.key,
    required this.location,
    this.weather,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final weatherInfo = weather != null
        ? WeatherCodeHelper.getInfo(weather!.weatherCode)
        : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF132B54).withAlpha(220),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withAlpha(20),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(30),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // 1. City Icon / Graphic Thumbnail (Matching Reference Screen 2)
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF1E40AF),
                        Color(0xFF0369A1),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withAlpha(40),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.location_city_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),

                // 2. City Name & Country
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        location.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        location.country ?? location.formattedSubtitle,
                        style: TextStyle(
                          color: Colors.white.withAlpha(160),
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (weather != null && weatherInfo != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              weatherInfo.icon,
                              size: 14,
                              color: weatherInfo.iconColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${weather!.temperature.round()}°C • ${weatherInfo.descriptionEn}',
                              style: const TextStyle(
                                color: Color(0xFF7DD3FC),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // 3. Right Arrow to Select & Red Trash Can to Delete
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppColors.error.withAlpha(25),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.delete_rounded,
                          color: Color(0xFFF87171),
                          size: 18,
                        ),
                        tooltip: 'Delete location',
                        onPressed: onDelete,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
