// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class City extends Equatable {
  final String name;
  final String region;
  final String country;
  final String url;

  const City({
    required this.name,
    required this.region,
    required this.country,
    required this.url,
  });

  factory City.initial() {
    return const City(
      name: "Blank City",
      region: "Blank Region",
      country: "Blank Country",
      url: "Blank url"
    );
  }

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'],
      region: json['region'],
      country: json['country'],
      url: json['url'],
    );
  }

  @override
  List<Object> get props => [name, region, country];

  @override
  String toString() {
    return ('name: $name, region: $region, country: $country, url: $url');
  }

  City copyWith({
    String? name,
    String? region,
    String? country,
    String? url,
  }) {
    return City(
      name: name ?? this.name,
      region: region ?? this.region,
      country: country ?? this.country,
      url: url ?? this.url,
    );
  }
}
