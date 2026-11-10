import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/tool_provider.dart';
import 'providers/summary_provider.dart';
import 'providers/loan_provider.dart';
import 'providers/theme_provider.dart';
import 'layout/responsive_scaffold.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ToolProvider()..loadTools()),
        ChangeNotifierProvider(create: (_) => SummaryProvider()),
        ChangeNotifierProvider(create: (_) => LoanProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // Provider Tema
      ],
      child: const LabApp(),
    ),
  );
}

class LabApp extends StatelessWidget {
  const LabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Manajemen Lab Komputer',
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode, // Mengikuti state dari provider
          
          // Konfigurasi Light Mode
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue, 
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),
          
          // Konfigurasi Dark Mode
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue, 
              brightness: Brightness.dark, // Kunci utama Dark Mode Material 3
            ),
            useMaterial3: true,
          ),
          
          home: const ResponsiveScaffold(),
        );
      },
    );
  }
}