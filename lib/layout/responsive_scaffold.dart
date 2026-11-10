import 'package:flutter/material.dart';
import '../screens/dashboard_screen.dart';
import '../screens/tools_list_screen.dart';
import '../screens/loans_screen.dart';

class ResponsiveScaffold extends StatefulWidget {
  const ResponsiveScaffold({super.key});

  @override
  State<ResponsiveScaffold> createState() => _ResponsiveScaffoldState();
}

class _ResponsiveScaffoldState extends State<ResponsiveScaffold> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const ToolsListScreen(),
    const LoansScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody wajib true agar layar berada di bawah floating bar
      extendBody: true, 
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Breakpoint 900px untuk transisi dari Mobile/Tablet ke Desktop
          if (constraints.maxWidth >= 900) {
            return Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (int index) {
                    setState(() => _selectedIndex = index);
                  },
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(icon: Icon(Icons.dashboard), label: Text('Dashboard')),
                    NavigationRailDestination(icon: Icon(Icons.inventory), label: Text('Alat')),
                    NavigationRailDestination(icon: Icon(Icons.swap_horiz), label: Text('Peminjaman')),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(child: _screens[_selectedIndex]),
              ],
            );
          } else {
            // Lebar di bawah 900px menampilkan konten penuh
            return _screens[_selectedIndex];
          }
        },
      ),
      // Tampilkan Floating Bar hanya jika lebar layar di bawah 900px
      bottomNavigationBar: MediaQuery.of(context).size.width < 900 
          ? _buildFloatingNavBar() 
          : null,
    );
  }

  // Desain Floating Navigation Bar ala macOS/iPadOS
  Widget _buildFloatingNavBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: NavigationBar(
              height: 65,
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) => setState(() => _selectedIndex = index),
              destinations: const [
                NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Dashboard'),
                NavigationDestination(icon: Icon(Icons.inventory_2_outlined), selectedIcon: Icon(Icons.inventory), label: 'Alat'),
                NavigationDestination(icon: Icon(Icons.swap_horiz_outlined), selectedIcon: Icon(Icons.swap_horiz), label: 'Peminjaman'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}