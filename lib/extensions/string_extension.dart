import 'package:flutter/material.dart';

extension StringExtension on String {
  IconData get weatherIcon {
    switch (toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
        return Icons.umbrella;
      case 'snow':
        return Icons.ac_unit;
      case 'thunderstorm':
        return Icons.flash_on;
      case 'drizzle':
        return Icons.grain;
      case 'mist':
        return Icons.water;
      case 'fog':
        return Icons.foggy;
      case 'haze':
        return Icons.foggy;
      default:
        return Icons.help_outline;
    }
  }
}
