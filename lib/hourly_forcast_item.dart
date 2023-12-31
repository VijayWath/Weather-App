import 'package:flutter/material.dart';

class ForcastCard extends StatelessWidget {
  final String time;
  final String temp;
  final IconData icon;
  const ForcastCard(
      {super.key, required this.time, required this.temp, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: 100,
          child: Column(
            children: [
              Text(
                time,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 8,
              ),
              Icon(
                icon,
                size: 32,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                temp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
