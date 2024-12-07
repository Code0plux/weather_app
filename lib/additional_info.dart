import 'package:flutter/material.dart';

class Additionalinfo extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;
  const Additionalinfo(
      {super.key,
      required this.label,
      required this.icon,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          Icon(icon),
          const SizedBox(
            height: 8,
          ),
          Text(label),
          const SizedBox(
            height: 8,
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
            ),
          )
        ]),
      ),
    );
  }
}
