import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/summary_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Tarik data saat halaman pertama kali dimuat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SummaryProvider>().loadSummary();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Ringkasan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<SummaryProvider>().loadSummary(),
          )
        ],
      ),
      body: Consumer<SummaryProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage.isNotEmpty) {
            return Center(child: Text(provider.errorMessage, style: const TextStyle(color: Colors.red)));
          }
          if (provider.summary == null) {
            return const Center(child: Text('Tidak ada data'));
          }

          final s = provider.summary!;

          // Menggunakan Wrap agar kartu otomatis menyesuaikan lebar layar
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              spacing: 16.0,
              runSpacing: 16.0,
              children: [
                _buildSummaryCard(
                  context: context,
                  title: 'Total Semua Alat',
                  value: s.totalItems.toString(),
                  icon: Icons.inventory_2,
                  color: Colors.blue,
                ),
                _buildSummaryCard(
                  context: context,
                  title: 'Sedang Dipinjam',
                  value: s.totalBorrowed.toString(),
                  icon: Icons.swap_horiz,
                  color: Colors.orange,
                ),
                _buildSummaryCard(
                  context: context,
                  title: 'Kondisi Rusak',
                  value: s.totalBroken.toString(),
                  icon: Icons.warning_amber_rounded,
                  color: Colors.red,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget pembantu untuk mencetak Kartu
  Widget _buildSummaryCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    // Memastikan kartu memanjang di HP, namun terbagi rapi di layar lebar
    double width = MediaQuery.of(context).size.width;
    double cardWidth = width < 600 ? double.infinity : 250;

    return SizedBox(
      width: cardWidth,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}