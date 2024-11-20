import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/data/temperature.dart';

class HourlyForecastCard extends StatelessWidget {
  final Temperature temperature;

  const HourlyForecastCard({
    super.key,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 7,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            if (temperature.time != null)
              Text(
                DateFormat.Hm().format(temperature.time!),
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 10),
            if (temperature.icon != null) Icon(temperature.icon, size: 35),
            const SizedBox(height: 10),
            if (temperature.temperature != null)
              Text(
                '${temperature.temperature?.toStringAsFixed(2)} °C',
                style: const TextStyle(fontSize: 15),
              ),
          ],
        ),
      ),
    );
  }
}
