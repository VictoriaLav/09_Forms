import 'package:json_annotation/json_annotation.dart';

part 'hotel.g.dart';
//flutter pub run build_runner watch

@JsonSerializable(explicitToJson: true)
class HotelPreview {
  final String uuid;
  final String name;
  final String poster;

  HotelPreview({required this.uuid, required this.name, required this.poster});

  factory HotelPreview.fromJson(Map<String, dynamic> json) =>
      _$HotelPreviewFromJson(json);
  Map<String, dynamic> toJson() => _$HotelPreviewToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Hotel {
  final String uuid;
  final String name;
  final String poster;
  final HotelAddress address;
  final double price;
  final double rating;
  final Map<String, List<String>> services;
  final List<String> photos;

  Hotel({
    required this.uuid,
    required this.name,
    required this.poster,
    required this.address,
    required this.price,
    required this.rating,
    required this.services,
    required this.photos});

  factory Hotel.fromJson(Map<String, dynamic> json) =>
      _$HotelFromJson(json);
  Map<String, dynamic> toJson() => _$HotelToJson(this);
}

@JsonSerializable()
class HotelAddress {
  final String country;
  final String street;
  final String city;
  final int zip_code;
  final Map<String, double> coords;

  HotelAddress({
    required this.country,
    required this.street,
    required this.city,
    required this.zip_code,
    required this.coords});

  factory HotelAddress.fromJson(var json) => _$HotelAddressFromJson(json);
  Map<String, dynamic> toJson() => _$HotelAddressToJson(this);
}


