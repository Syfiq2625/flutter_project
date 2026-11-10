import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tool_provider.dart';
import '../models/tool.dart';
import '../widgets/status_chip.dart';

class ToolsListScreen extends StatelessWidget {
  const ToolsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Alat Lab'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Menyegarkan data dari API
              context.read<ToolProvider>().loadTools();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Bagian Pencarian dan Filter
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchBar(
                  hintText: 'Cari nama alat atau kategori...',
                  leading: const Icon(Icons.search),
                  onSubmitted: (value) => context.read<ToolProvider>().setSearchQuery(value),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8.0,
                  children: [
                    FilterChip(
                      label: const Text('Tersedia'),
                      selected: context.watch<ToolProvider>().activeFilter == 'available',
                      onSelected: (_) => context.read<ToolProvider>().setFilter('available'),
                    ),
                    FilterChip(
                      label: const Text('Perlu Diperbaiki'),
                      selected: context.watch<ToolProvider>().activeFilter == 'repair',
                      onSelected: (_) => context.read<ToolProvider>().setFilter('repair'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Bagian Daftar Data (Tabel / ListView)
          Expanded(
            child: Consumer<ToolProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (provider.errorMessage.isNotEmpty) {
                  return Center(
                    child: Text('Error: ${provider.errorMessage}', 
                    style: const TextStyle(color: Colors.red))
                  );
                }

                if (provider.tools.isEmpty) {
                  return const Center(child: Text('Data tidak ditemukan.'));
                }

                // Menggunakan LayoutBuilder dengan breakpoint 600
                return LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth >= 600) {
                      return _buildDesktopTable(provider.tools);
                    } else {
                      return _buildMobileList(provider.tools);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Nanti diarahkan ke form tambah alat
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Fitur tambah alat segera hadir')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Tampilan untuk layar sempit (< 600px) menggunakan ListView
  Widget _buildMobileList(List<Tool> tools) {
    return ListView.builder(
      // Padding bawah agar item terakhir tidak tertutup floating navbar
      padding: const EdgeInsets.only(bottom: 90, top: 8), 
      itemCount: tools.length,
      itemBuilder: (context, index) {
        final tool = tools[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: ListTile(
            title: Text(tool.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${tool.inventoryCode} • ${tool.category}'),
                  const SizedBox(height: 4),
                  Text('Stok: ${tool.availableQty} / ${tool.totalQty}'),
                ],
              ),
            ),
            trailing: StatusChip(status: tool.status),
            onTap: () {
              // TODO: Aksi klik detail
            },
          ),
        );
      },
    );
  }

  // Tampilan untuk layar lebar (>= 600px) menggunakan DataTable
  Widget _buildDesktopTable(List<Tool> tools) {
    return SingleChildScrollView(
      // Padding bawah 100 agar tombol FAB tidak tertutup dock navigasi
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 0.0, bottom: 100.0),
      child: SizedBox(
        width: double.infinity,
        child: Card(
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Kode', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Nama Alat', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Kategori', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Stok', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Aksi', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: tools.map((tool) => DataRow(
              cells: [
                DataCell(Text(tool.inventoryCode)),
                DataCell(Text(tool.name)),
                DataCell(Text(tool.category)),
                DataCell(Text('${tool.availableQty} / ${tool.totalQty}')),
                DataCell(StatusChip(status: tool.status)),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, color: Colors.blue, size: 20), 
                        onPressed: () {}
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20), 
                        onPressed: () {}
                      ),
                    ],
                  ),
                ),
              ],
            )).toList(),
          ),
        ),
      ),
    );
  }
}