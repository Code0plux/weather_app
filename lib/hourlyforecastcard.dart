import 'package:flutter/material.dart';

class HourlyForecastCard extends StatelessWidget {
  final String time;
  final String temperature;
  final IconData icon;
  const HourlyForecastCard(
      {super.key,
      required this.time,
      required this.temperature,
      required this.icon});

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
            Text(time,
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 10,
            ),
            Icon(
              icon,
              size: 35,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(temperature, style: const TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
