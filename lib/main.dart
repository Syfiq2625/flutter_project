import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/tool_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ToolProvider()..loadTools()),
      ],
      child: const LabApp(),
    ),
  );
}

class LabApp extends StatelessWidget {
  const LabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manajemen Lab Komputer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const DashboardTestScreen(),
    );
  }
}

class DashboardTestScreen extends StatelessWidget {
  const DashboardTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Validasi API Flutter & PHP')),
      body: Consumer<ToolProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (provider.errorMessage.isNotEmpty) {
            return Center(child: Text(provider.errorMessage, style: const TextStyle(color: Colors.red)));
          }

          if (provider.tools.isEmpty) {
            return const Center(child: Text('Tidak ada data alat.'));
          }

          return ListView.builder(
            itemCount: provider.tools.length,
            itemBuilder: (context, index) {
              final tool = provider.tools[index];
              return ListTile(
                leading: CircleAvatar(child: Text(tool.availableQty.toString())),
                title: Text(tool.name),
                subtitle: Text('Status: ${tool.status} | Kondisi: ${tool.condition}'),
                trailing: Text(tool.category),
              );
            },
          );
        },
      ),
    );
  }
}