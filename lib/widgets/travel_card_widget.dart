import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_travel/models/travel.dart'; // Sesuaikan dengan struktur model app_travel

final _lightColors = [
  const Color.fromARGB(255, 79, 208, 255),
  Color.fromARGB(255, 252, 122, 254),
  Color.fromARGB(212, 192, 76, 255),
  Colors.orange.shade300,
  Colors.pinkAccent.shade100,
  Colors.tealAccent.shade100,
];

class TravelCardWidget extends StatelessWidget {
  const TravelCardWidget({Key? key, required this.travel, required this.index});

  final Travel travel;
  final int index;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMd();
    final time = dateFormat.format(travel.travelDate);
    final minHeight = _getMinHeight(index);
    final color = _lightColors[index % _lightColors.length];

    return Card(
      color: color,
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              travel.name,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }

  double _getMinHeight(int index) {
    switch (index % 4) {
      case 0:
      case 3:
        return 100;
      case 1:
      case 2:
        return 150;
      default:
        return 100;
    }
  }
}
