import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  /// Formats an ISO string (e.g. 2026-11-25T14:00) into a readable day and date:
  /// e.g. "Rabu, 25 Nov 2026"
  static String formatFullDate(DateTime dateTime) {
    final dayNames = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    final monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    final dayName = dayNames[dateTime.weekday - 1];
    final monthName = monthNames[dateTime.month - 1];
    return '$dayName, ${dateTime.day} $monthName ${dateTime.year}';
  }

  /// Formats a date string (YYYY-MM-DD) from Open-Meteo daily data:
  /// e.g. "Hari Ini" or "Kam, 26 Nov"
  static String formatForecastDay(String dateStr, {bool isToday = false}) {
    if (isToday) return 'Hari Ini';
    try {
      final dt = DateTime.parse(dateStr);
      final dayNames = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
      final monthNames = [
        'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'
      ];
      return '${dayNames[dt.weekday - 1]}, ${dt.day} ${monthNames[dt.month - 1]}';
    } catch (_) {
      return dateStr;
    }
  }

  /// Formats time in HH:mm
  static String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }
}
