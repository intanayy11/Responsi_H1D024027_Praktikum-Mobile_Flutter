class AppStrings {
  AppStrings._();

  static const String appName = 'SkyCast';
  static const String appTagline = 'Weather Forecast';

  // Navigation
  static const String home = 'Beranda';
  static const String search = 'Cari Kota';
  static const String favorites = 'Kota Favorit';

  // Weather Screen
  static const String currentWeather = 'Cuaca Saat Ini';
  static const String feelsLike = 'Terasa Seperti';
  static const String humidity = 'Kelembapan';
  static const String windSpeed = 'Kecepatan Angin';
  static const String precipitation = 'Curah Hujan';
  static const String dailyForecast = 'Prakiraan 7 Hari';
  static const String precipitationProbability = 'Peluang Hujan';
  static const String today = 'Hari Ini';
  static const String addedToFavorites = 'Ditambahkan ke favorit';
  static const String removedFromFavorites = 'Dihapus dari favorit';

  // Search Screen
  static const String searchHint = 'Ketik nama kota (misal: Jakarta, Tokyo)...';
  static const String searchInstruction = 'Cari kota di seluruh dunia untuk melihat ramalan cuaca';
  static const String noResultsTitle = 'Kota Tidak Ditemukan';
  static const String noResultsDesc = 'Periksa kembali ejaan nama kota yang Anda masukkan.';
  static const String searching = 'Mencari kota...';

  // Favorites Screen
  static const String emptyFavoritesTitle = 'Belum Ada Kota Favorit';
  static const String emptyFavoritesDesc = 'Tambahkan kota favorit melalui tombol bintang di halaman cuaca atau pencarian.';
  static const String deleteFavoriteConfirm = 'Hapus dari favorit?';

  // Error States
  static const String errorGeneral = 'Terjadi kesalahan. Silakan coba lagi.';
  static const String errorNetwork = 'Koneksi internet bermasalah. Periksa jaringan Anda.';
  static const String errorTimeout = 'Waktu permintaan habis. Silakan coba lagi.';
  static const String retry = 'Coba Lagi';
}
