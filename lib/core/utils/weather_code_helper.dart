import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class WeatherCodeInfo {
  final String descriptionId;
  final String descriptionEn;
  final IconData icon;
  final Color iconColor;
  final List<Color> gradientColors;

  const WeatherCodeInfo({
    required this.descriptionId,
    required this.descriptionEn,
    required this.icon,
    required this.iconColor,
    required this.gradientColors,
  });
}

class WeatherCodeHelper {
  WeatherCodeHelper._();

  static WeatherCodeInfo getInfo(int code) {
    switch (code) {
      case 0:
        return const WeatherCodeInfo(
          descriptionId: 'Cerah',
          descriptionEn: 'Clear Sky',
          icon: Icons.wb_sunny_rounded,
          iconColor: AppColors.sunnyGold,
          gradientColors: [Color(0xFF0284C7), Color(0xFF38BDF8)],
        );
      case 1:
        return const WeatherCodeInfo(
          descriptionId: 'Sebagian Besar Cerah',
          descriptionEn: 'Mainly Clear',
          icon: Icons.wb_sunny_outlined,
          iconColor: AppColors.sunnyGold,
          gradientColors: [Color(0xFF0369A1), Color(0xFF38BDF8)],
        );
      case 2:
        return const WeatherCodeInfo(
          descriptionId: 'Berawan Sebagian',
          descriptionEn: 'Partly Cloudy',
          icon: Icons.cloud_queue_rounded,
          iconColor: AppColors.cloudGray,
          gradientColors: [Color(0xFF1E3A8A), Color(0xFF60A5FA)],
        );
      case 3:
        return const WeatherCodeInfo(
          descriptionId: 'Mendung',
          descriptionEn: 'Overcast',
          icon: Icons.cloud_rounded,
          iconColor: AppColors.cloudGray,
          gradientColors: [Color(0xFF1E293B), Color(0xFF475569)],
        );
      case 45:
        return const WeatherCodeInfo(
          descriptionId: 'Berkabut',
          descriptionEn: 'Fog',
          icon: Icons.foggy,
          iconColor: AppColors.cloudGray,
          gradientColors: [Color(0xFF334155), Color(0xFF64748B)],
        );
      case 48:
        return const WeatherCodeInfo(
          descriptionId: 'Kabut Tebal',
          descriptionEn: 'Depositing Rime Fog',
          icon: Icons.foggy,
          iconColor: AppColors.cloudGray,
          gradientColors: [Color(0xFF1E293B), Color(0xFF475569)],
        );
      case 51:
        return const WeatherCodeInfo(
          descriptionId: 'Gerimis Ringan',
          descriptionEn: 'Light Drizzle',
          icon: Icons.grain_rounded,
          iconColor: AppColors.rainBlue,
          gradientColors: [Color(0xFF0C4A6E), Color(0xFF38BDF8)],
        );
      case 53:
        return const WeatherCodeInfo(
          descriptionId: 'Gerimis Sedang',
          descriptionEn: 'Moderate Drizzle',
          icon: Icons.grain_rounded,
          iconColor: AppColors.rainBlue,
          gradientColors: [Color(0xFF0C4A6E), Color(0xFF0284C7)],
        );
      case 55:
        return const WeatherCodeInfo(
          descriptionId: 'Gerimis Lebat',
          descriptionEn: 'Dense Drizzle',
          icon: Icons.grain_rounded,
          iconColor: AppColors.rainBlue,
          gradientColors: [Color(0xFF075985), Color(0xFF0284C7)],
        );
      case 56:
        return const WeatherCodeInfo(
          descriptionId: 'Gerimis Beku Ringan',
          descriptionEn: 'Light Freezing Drizzle',
          icon: Icons.ac_unit_rounded,
          iconColor: AppColors.snowIce,
          gradientColors: [Color(0xFF1E293B), Color(0xFF38BDF8)],
        );
      case 57:
        return const WeatherCodeInfo(
          descriptionId: 'Gerimis Beku Lebat',
          descriptionEn: 'Dense Freezing Drizzle',
          icon: Icons.ac_unit_rounded,
          iconColor: AppColors.snowIce,
          gradientColors: [Color(0xFF0F172A), Color(0xFF0284C7)],
        );
      case 61:
        return const WeatherCodeInfo(
          descriptionId: 'Hujan Ringan',
          descriptionEn: 'Slight Rain',
          icon: Icons.water_drop_rounded,
          iconColor: AppColors.rainBlue,
          gradientColors: [Color(0xFF0F172A), Color(0xFF0284C7)],
        );
      case 63:
        return const WeatherCodeInfo(
          descriptionId: 'Hujan Sedang',
          descriptionEn: 'Moderate Rain',
          icon: Icons.water_drop_rounded,
          iconColor: AppColors.rainBlue,
          gradientColors: [Color(0xFF0F172A), Color(0xFF1D4ED8)],
        );
      case 65:
        return const WeatherCodeInfo(
          descriptionId: 'Hujan Lebat',
          descriptionEn: 'Heavy Rain',
          icon: Icons.thunderstorm_rounded,
          iconColor: AppColors.rainBlue,
          gradientColors: [Color(0xFF0F172A), Color(0xFF1E3A8A)],
        );
      case 66:
        return const WeatherCodeInfo(
          descriptionId: 'Hujan Beku Ringan',
          descriptionEn: 'Light Freezing Rain',
          icon: Icons.ac_unit_rounded,
          iconColor: AppColors.snowIce,
          gradientColors: [Color(0xFF0F172A), Color(0xFF2563EB)],
        );
      case 67:
        return const WeatherCodeInfo(
          descriptionId: 'Hujan Beku Lebat',
          descriptionEn: 'Heavy Freezing Rain',
          icon: Icons.ac_unit_rounded,
          iconColor: AppColors.snowIce,
          gradientColors: [Color(0xFF020617), Color(0xFF1D4ED8)],
        );
      case 71:
        return const WeatherCodeInfo(
          descriptionId: 'Salju Ringan',
          descriptionEn: 'Slight Snow Fall',
          icon: Icons.ac_unit_rounded,
          iconColor: AppColors.snowIce,
          gradientColors: [Color(0xFF1E293B), Color(0xFF93C5FD)],
        );
      case 73:
        return const WeatherCodeInfo(
          descriptionId: 'Salju Sedang',
          descriptionEn: 'Moderate Snow Fall',
          icon: Icons.ac_unit_rounded,
          iconColor: AppColors.snowIce,
          gradientColors: [Color(0xFF1E293B), Color(0xFF60A5FA)],
        );
      case 75:
        return const WeatherCodeInfo(
          descriptionId: 'Salju Lebat',
          descriptionEn: 'Heavy Snow Fall',
          icon: Icons.ac_unit_rounded,
          iconColor: AppColors.snowIce,
          gradientColors: [Color(0xFF0F172A), Color(0xFF3B82F6)],
        );
      case 77:
        return const WeatherCodeInfo(
          descriptionId: 'Butiran Salju',
          descriptionEn: 'Snow Grains',
          icon: Icons.ac_unit_rounded,
          iconColor: AppColors.snowIce,
          gradientColors: [Color(0xFF1E293B), Color(0xFF60A5FA)],
        );
      case 80:
        return const WeatherCodeInfo(
          descriptionId: 'Hujan Rintik Sesaat',
          descriptionEn: 'Slight Rain Showers',
          icon: Icons.umbrella_rounded,
          iconColor: AppColors.rainBlue,
          gradientColors: [Color(0xFF0F172A), Color(0xFF0284C7)],
        );
      case 81:
        return const WeatherCodeInfo(
          descriptionId: 'Hujan Deras Sesaat',
          descriptionEn: 'Moderate Rain Showers',
          icon: Icons.umbrella_rounded,
          iconColor: AppColors.rainBlue,
          gradientColors: [Color(0xFF0F172A), Color(0xFF1D4ED8)],
        );
      case 82:
        return const WeatherCodeInfo(
          descriptionId: 'Hujan Badai Sesaat',
          descriptionEn: 'Violent Rain Showers',
          icon: Icons.flash_on_rounded,
          iconColor: AppColors.stormPurple,
          gradientColors: [Color(0xFF0F172A), Color(0xFF581C87)],
        );
      case 85:
        return const WeatherCodeInfo(
          descriptionId: 'Hujan Salju Sesaat',
          descriptionEn: 'Slight Snow Showers',
          icon: Icons.severe_cold_rounded,
          iconColor: AppColors.snowIce,
          gradientColors: [Color(0xFF1E293B), Color(0xFF38BDF8)],
        );
      case 86:
        return const WeatherCodeInfo(
          descriptionId: 'Badai Salju Sesaat',
          descriptionEn: 'Heavy Snow Showers',
          icon: Icons.severe_cold_rounded,
          iconColor: AppColors.snowIce,
          gradientColors: [Color(0xFF0F172A), Color(0xFF1D4ED8)],
        );
      case 95:
        return const WeatherCodeInfo(
          descriptionId: 'Badai Petir',
          descriptionEn: 'Thunderstorm',
          icon: Icons.thunderstorm_rounded,
          iconColor: AppColors.stormPurple,
          gradientColors: [Color(0xFF0F172A), Color(0xFF6B21A8)],
        );
      case 96:
        return const WeatherCodeInfo(
          descriptionId: 'Badai Petir Hujan Es Ringan',
          descriptionEn: 'Thunderstorm with Slight Hail',
          icon: Icons.thunderstorm_rounded,
          iconColor: AppColors.stormPurple,
          gradientColors: [Color(0xFF0B1120), Color(0xFF581C87)],
        );
      case 99:
        return const WeatherCodeInfo(
          descriptionId: 'Badai Petir Hujan Es Lebat',
          descriptionEn: 'Thunderstorm with Heavy Hail',
          icon: Icons.thunderstorm_rounded,
          iconColor: AppColors.stormPurple,
          gradientColors: [Color(0xFF020617), Color(0xFF3B0764)],
        );
      default:
        return const WeatherCodeInfo(
          descriptionId: 'Cuaca Tidak Diketahui',
          descriptionEn: 'Unknown Weather',
          icon: Icons.wb_cloudy_rounded,
          iconColor: AppColors.cloudGray,
          gradientColors: [Color(0xFF1E293B), Color(0xFF334155)],
        );
    }
  }

  /// Menghasilkan gradasi 3 warna background yang menyesuaikan kondisi cuaca & siang/malam.
  static List<Color> getBackgroundGradient(int code, {String? currentTimeIso}) {
    final parsed = currentTimeIso != null ? DateTime.tryParse(currentTimeIso) : null;
    final hour = parsed?.hour ?? DateTime.now().hour;
    final isNight = hour < 6 || hour >= 18;

    if (code >= 95) {
      // Badai Petir
      return isNight
          ? const [Color(0xFF0D091A), Color(0xFF1B1233), Color(0xFF281B47)]
          : const [Color(0xFF14192E), Color(0xFF242B4A), Color(0xFF343D63)];
    }
    if ((code >= 51 && code <= 67) || (code >= 80 && code <= 82)) {
      // Gerimis / Hujan
      return isNight
          ? const [Color(0xFF07101F), Color(0xFF0E223D), Color(0xFF163252)]
          : const [Color(0xFF0F2942), Color(0xFF1B4268), Color(0xFF285A84)];
    }
    if (code == 45 || code == 48) {
      // Berkabut
      return isNight
          ? const [Color(0xFF0C131D), Color(0xFF192433), Color(0xFF243245)]
          : const [Color(0xFF22303F), Color(0xFF364659), Color(0xFF4A5B70)];
    }
    if (code == 3) {
      // Mendung (Overcast)
      return isNight
          ? const [Color(0xFF0A0F1A), Color(0xFF151E2E), Color(0xFF1E293B)]
          : const [Color(0xFF1A273B), Color(0xFF2B3B52), Color(0xFF3D4F69)];
    }
    if (code == 2) {
      // Berawan Sebagian
      return isNight
          ? const [Color(0xFF081226), Color(0xFF112244), Color(0xFF1A3361)]
          : const [Color(0xFF123463), Color(0xFF1E4D8C), Color(0xFF326AA8)];
    }
    if (code == 0 || code == 1) {
      // Cerah / Sebagian Besar Cerah
      return isNight
          ? const [Color(0xFF070D1A), Color(0xFF0F1C38), Color(0xFF1A2B50)]
          : const [Color(0xFF0A4D8C), Color(0xFF1572B6), Color(0xFF2B95D6)];
    }

    // Default / Salju / Lainnya
    return const [Color(0xFF0B1424), Color(0xFF13233F), Color(0xFF192F56)];
  }
}
