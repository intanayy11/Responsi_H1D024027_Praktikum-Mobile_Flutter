import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/weather_code_helper.dart';
import '../../../data/models/daily_forecast_model.dart';

class SevenDayForecastScreen extends StatelessWidget {
  final List<DailyForecastModel> dailyForecasts;

  const SevenDayForecastScreen({
    super.key,
    required this.dailyForecasts,
  });

  String _formatDayLabel(String dateStr, int index) {
    if (index == 0) return 'Today';
    if (index == 1) return 'Tomorrow';
    try {
      final dt = DateTime.parse(dateStr);
      return DateFormat('EEE').format(dt);
    } catch (_) {
      return 'Day ${index + 1}';
    }
  }

  String _formatMonthDay(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      return DateFormat('MM/dd').format(dt);
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final days = dailyForecasts.take(7).toList();
    const double columnWidth = 92.0;
    const double chartHeight = 170.0;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1424),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.45, 1.0],
            colors: [
              Color(0xFF0B1424),
              Color(0xFF13233F),
              Color(0xFF192F56),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Bar: Back Button
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
                const SizedBox(height: 16),

                // Page Title
                const Text(
                  '7-day forecast',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 24),

                // Swipeable 7-Day Chart Card
                if (days.isNotEmpty)
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF13233F).withAlpha(200),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withAlpha(20),
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: SizedBox(
                        width: days.length * columnWidth,
                        child: Stack(
                          children: [
                            // Highlighted column background for Today
                            Positioned(
                              left: 0,
                              top: 0,
                              bottom: 0,
                              width: columnWidth,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(14),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                            ),

                            // Temperature Curve Painter positioned over the chart band
                            Positioned(
                              left: 0,
                              right: 0,
                              top: 96,
                              height: chartHeight,
                              child: CustomPaint(
                                size: Size(days.length * columnWidth, chartHeight),
                                painter: _TemperatureCurvePainter(
                                  days: days,
                                  columnWidth: columnWidth,
                                ),
                              ),
                            ),

                            // Columns with Day, Date, Icon, Spacer for Curve, Rain % & Condition
                            Row(
                              children: List.generate(days.length, (index) {
                                final day = days[index];
                                final weatherInfo = WeatherCodeHelper.getInfo(day.weatherCode);
                                final isToday = index == 0;

                                return SizedBox(
                                  width: columnWidth,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Day name
                                        Text(
                                          _formatDayLabel(day.time, index),
                                          style: TextStyle(
                                            color: isToday
                                                ? Colors.white
                                                : Colors.white.withAlpha(200),
                                            fontSize: 15,
                                            fontWeight: isToday
                                                ? FontWeight.bold
                                                : FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),

                                        // Date (MM/dd)
                                        Text(
                                          _formatMonthDay(day.time),
                                          style: TextStyle(
                                            color: Colors.white.withAlpha(120),
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 14),

                                        // Top Weather Icon
                                        Icon(
                                          weatherInfo.icon,
                                          size: 24,
                                          color: weatherInfo.iconColor,
                                        ),

                                        // Space reserved for dual temperature curve
                                        const SizedBox(height: chartHeight + 12),

                                        // Precipitation Probability
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.water_drop_rounded,
                                              size: 13,
                                              color: Color(0xFF38BDF8),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${day.precipitationProbabilityMax}%',
                                              style: TextStyle(
                                                color: isToday
                                                    ? Colors.white
                                                    : Colors.white.withAlpha(180),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),

                                        // Short Condition Description
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 4),
                                          child: Text(
                                            weatherInfo.descriptionEn,
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.white.withAlpha(140),
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TemperatureCurvePainter extends CustomPainter {
  final List<DailyForecastModel> days;
  final double columnWidth;

  _TemperatureCurvePainter({
    required this.days,
    required this.columnWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (days.isEmpty) return;

    double minTemp = days.map((d) => d.tempMin).reduce(math.min);
    double maxTemp = days.map((d) => d.tempMax).reduce(math.max);
    if ((maxTemp - minTemp).abs() < 1.0) {
      maxTemp += 1.0;
      minTemp -= 1.0;
    }

    // Reserve top/bottom padding inside the chart band so degree labels fit cleanly
    const double topPad = 32.0;
    const double bottomPad = 32.0;
    final double usableHeight = size.height - topPad - bottomPad;

    double tempToY(double temp) {
      final ratio = (temp - minTemp) / (maxTemp - minTemp);
      return topPad + (1.0 - ratio) * usableHeight;
    }

    final highPoints = <Offset>[];
    final lowPoints = <Offset>[];

    for (int i = 0; i < days.length; i++) {
      final x = i * columnWidth + columnWidth / 2;
      highPoints.add(Offset(x, tempToY(days[i].tempMax)));
      lowPoints.add(Offset(x, tempToY(days[i].tempMin)));
    }

    _drawSmoothLine(
      canvas,
      highPoints,
      const Color(0xFFF59E0B),
    );
    _drawSmoothLine(
      canvas,
      lowPoints,
      const Color(0xFF38BDF8),
    );

    // Draw dots and temperature labels
    for (int i = 0; i < days.length; i++) {
      final isToday = i == 0;
      _drawPointAndLabel(
        canvas: canvas,
        point: highPoints[i],
        label: '${days[i].tempMax.round()}°',
        dotColor: const Color(0xFFF59E0B),
        isAbove: true,
        isToday: isToday,
      );
      _drawPointAndLabel(
        canvas: canvas,
        point: lowPoints[i],
        label: '${days[i].tempMin.round()}°',
        dotColor: const Color(0xFF38BDF8),
        isAbove: false,
        isToday: isToday,
      );
    }
  }

  void _drawSmoothLine(Canvas canvas, List<Offset> points, Color color) {
    if (points.length < 2) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final controlX = (p0.dx + p1.dx) / 2;
      path.cubicTo(controlX, p0.dy, controlX, p1.dy, p1.dx, p1.dy);
    }
    canvas.drawPath(path, paint);
  }

  void _drawPointAndLabel({
    required Canvas canvas,
    required Offset point,
    required String label,
    required Color dotColor,
    required bool isAbove,
    required bool isToday,
  }) {
    // Subtle outer ring for Today
    if (isToday) {
      canvas.drawCircle(
        point,
        5.5,
        Paint()..color = dotColor.withAlpha(70),
      );
    }
    canvas.drawCircle(
      point,
      3.5,
      Paint()..color = dotColor,
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: isToday ? Colors.white : Colors.white.withAlpha(200),
          fontSize: 14,
          fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout();

    final double dy = isAbove
        ? point.dy - textPainter.height - 8
        : point.dy + 8;

    textPainter.paint(
      canvas,
      Offset(point.dx - textPainter.width / 2, dy),
    );
  }

  @override
  bool shouldRepaint(covariant _TemperatureCurvePainter oldDelegate) {
    return oldDelegate.days != days;
  }
}
