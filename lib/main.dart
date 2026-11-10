import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/tool_provider.dart';
import 'layout/responsive_scaffold.dart';
import 'providers/summary_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ToolProvider()..loadTools()),
        ChangeNotifierProvider(create: (_) => SummaryProvider()..loadSummary()),
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
      debugShowCheckedModeBanner: false, // Menghilangkan banner debug
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ResponsiveScaffold(),
    );
  }
}