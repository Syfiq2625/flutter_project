import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  final String status;
  
  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor = Colors.white;

    switch (status.toLowerCase()) {
      case 'tersedia':
        bgColor = Colors.green;
        break;
      case 'dipinjam':
        bgColor = Colors.orange;
        break;
      case 'rusak':
        bgColor = Colors.red;
        break;
      default:
        bgColor = Colors.grey;
    }

    return Chip(
      label: Text(
        status.toUpperCase(), 
        style: TextStyle(color: textColor, fontSize: 11, fontWeight: FontWeight.bold)
      ),
      backgroundColor: bgColor,
      side: BorderSide.none, // Menghilangkan border bawaan Material 3
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
    );
  }
}