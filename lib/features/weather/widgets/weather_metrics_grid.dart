import 'package:flutter/material.dart';
import '../../../data/models/current_weather_model.dart';

class WeatherMetricsGrid extends StatelessWidget {
  final CurrentWeatherModel current;

  const WeatherMetricsGrid({
    super.key,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMetricTile(
                title: 'Real feel',
                value: '${current.apparentTemperature.round()}°',
                icon: Icons.thermostat_rounded,
                accentColor: const Color(0xFFFBBF24),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildMetricTile(
                title: 'Humidity',
                value: '${current.relativeHumidity}%',
                icon: Icons.water_drop_rounded,
                accentColor: const Color(0xFF38BDF8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _buildMetricTile(
                title: 'Wind speed',
                value: '${current.windSpeed.toStringAsFixed(1)} km/h',
                icon: Icons.air_rounded,
                accentColor: const Color(0xFF34D399),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildMetricTile(
                title: 'Precipitation',
                value: '${current.precipitation.toStringAsFixed(1)} mm',
                icon: Icons.grain_rounded,
                accentColor: const Color(0xFF818CF8),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricTile({
    required String title,
    required String value,
    required IconData icon,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF13233F).withAlpha(190),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withAlpha(20),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withAlpha(160),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Icon(icon, color: accentColor, size: 18),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
