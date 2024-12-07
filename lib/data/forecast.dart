import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weather_app/data/temperature.dart';
import 'package:weather_app/extensions/string_extension.dart';

class Forecast {
  const Forecast({
    this.temperature,
    this.conditions,
    this.icon,
    this.pressure,
    this.humidity,
    this.windSpeed,
    this.firstTemperature,
    this.secondTemperature,
    this.thirdTemperature,
    this.fourthTemperature,
  });

  final double? temperature;
  final String? conditions;
  final int? pressure;
  final int? humidity;
  final int? windSpeed;
  final IconData? icon;
  final Temperature? firstTemperature;
  final Temperature? secondTemperature;
  final Temperature? thirdTemperature;
  final Temperature? fourthTemperature;

  static Forecast fromString(String string) {
    final json = jsonDecode(string)['list'];
    final currentWeather = json[0]['weather'][0];
    final currentMain = json[0]['main'];
    const kelvin = 273.15;

    return Forecast(
      temperature: currentMain['temp'] - kelvin,
      conditions: currentWeather['main'],
      icon: (currentWeather['main'] as String?)?.weatherIcon,
      pressure: currentMain['pressure'],
      humidity: currentMain['humidity'],
      windSpeed: currentMain['speed'],
      firstTemperature: Temperature.fromJson(json[1]),
      secondTemperature: Temperature.fromJson(json[2]),
      thirdTemperature: Temperature.fromJson(json[3]),
      fourthTemperature: Temperature.fromJson(json[4]),
    );
  }
}
