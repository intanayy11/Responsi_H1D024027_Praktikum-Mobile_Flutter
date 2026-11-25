import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/weather_code_helper.dart';
import '../../../data/models/location_model.dart';
import '../../../data/models/weather_model.dart';
import '../../search/views/search_and_save_screen.dart';
import '../viewmodels/weather_viewmodel.dart';

class WeatherHeroCard extends StatelessWidget {
  final LocationModel location;
  final WeatherModel weather;

  const WeatherHeroCard({
    super.key,
    required this.location,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    final current = weather.current;
    final weatherInfo = WeatherCodeHelper.getInfo(current.weatherCode);

    double highTemp = current.temperature;
    double lowTemp = current.temperature;
    if (weather.daily.isNotEmpty) {
      highTemp = weather.daily.first.tempMax;
      lowTemp = weather.daily.first.tempMin;
    }

    final formattedDate = DateFormat('EEE, d MMM yyyy').format(DateTime.now());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Top Bar: City Name on Left + '+' (Add/Manage) on Right (Matching Reference Images 2, 3, 4)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // City Name with subtle location indicator
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
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.2,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.near_me_rounded,
                        color: Colors.white70,
                        size: 15,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    location.country != null && location.country!.isNotEmpty
                        ? '${location.country} • $formattedDate'
                        : formattedDate,
                    style: TextStyle(
                      color: Colors.white.withAlpha(150),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // '+' Button to Open "Manage cities" (Matching Reference Image)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF13233F).withAlpha(180),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withAlpha(30),
                  width: 1,
                ),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 24,
                ),
                tooltip: 'Manage cities',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SearchAndSaveScreen(
                        onLocationSelected: (newLoc) async {
                          final weatherVm = context.read<WeatherViewModel>();
                          await weatherVm.selectLocation(newLoc);
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),

        // 2. Huge Temperature & Condition Display (Matching Reference Image 4)
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
        const SizedBox(height: 8),

        // Condition & High/Low (e.g. Cloudy 31° / 23°)
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
      ],
    );
  }
}
