class LocationModel {
  final int? id;
  final String name;
  final double latitude;
  final double longitude;
  final String? country;
  final String? admin1;
  final String? countryCode;
  final String? timezone;

  const LocationModel({
    this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.country,
    this.admin1,
    this.countryCode,
    this.timezone,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] is int ? json['id'] as int : null,
      name: json['name'] as String? ?? 'Tidak Diketahui',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      country: json['country'] as String?,
      admin1: json['admin1'] as String?,
      countryCode: json['country_code'] as String?,
      timezone: json['timezone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'country': country,
      'admin1': admin1,
      'country_code': countryCode,
      'timezone': timezone,
    };
  }

  String get formattedSubtitle {
    final parts = <String>[];
    if (admin1 != null && admin1!.isNotEmpty && admin1 != name) {
      parts.add(admin1!);
    }
    if (country != null && country!.isNotEmpty) {
      parts.add(country!);
    }
    return parts.isEmpty ? 'Koordinat: ${latitude.toStringAsFixed(2)}, ${longitude.toStringAsFixed(2)}' : parts.join(', ');
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationModel &&
        other.name.toLowerCase() == name.toLowerCase() &&
        (other.latitude - latitude).abs() < 0.001 &&
        (other.longitude - longitude).abs() < 0.001;
  }

  @override
  int get hashCode => name.toLowerCase().hashCode ^ latitude.hashCode ^ longitude.hashCode;
}
