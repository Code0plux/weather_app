import 'package:flutter/material.dart';
import 'package:weather_app/extensions/string_extension.dart';

class Temperature {
  const Temperature({
    this.time,
    this.temperature,
    this.icon,
  });

  final DateTime? time;
  final double? temperature;
  final IconData? icon;

  static Temperature fromJson(Map<String, dynamic> json) {
    const kelvin = 273.15;

    return Temperature(
      time: DateTime.parse(json['dt_txt']),
      temperature: json['main']['temp'] - kelvin,
      icon: (json['weather'][0]['main'] as String?)?.weatherIcon,
    );
  }
}
