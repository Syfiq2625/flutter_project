import 'package:flutter/material.dart';

class ToolsListScreen extends StatelessWidget {
  const ToolsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Nanti kita akan pindahkan validasi API dari main.dart ke sini
    return const Center(
      child: Text('Halaman Daftar Alat (Segera Hadir)', style: TextStyle(fontSize: 24)),
    );
  }
}