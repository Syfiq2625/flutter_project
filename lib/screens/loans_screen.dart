import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/loan_provider.dart';
import '../providers/tool_provider.dart';
import '../providers/summary_provider.dart';
import '../models/loan.dart';
import 'loan_form_screen.dart';

class LoansScreen extends StatefulWidget {
  const LoansScreen({super.key});

  @override
  State<LoansScreen> createState() => _LoansScreenState();
}

class _LoansScreenState extends State<LoansScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LoanProvider>().loadLoans();
    });
  }

  void _handleReturn(int loanId) async {
    await context.read<LoanProvider>().processReturn(loanId);
    if (mounted) {
      // Segarkan data dashboard dan daftar alat karena stok telah berubah
      context.read<SummaryProvider>().loadSummary();
      context.read<ToolProvider>().loadTools();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Alat berhasil dikembalikan')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Peminjaman'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: () => context.read<LoanProvider>().loadLoans())
        ],
      ),
      body: Consumer<LoanProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) return const Center(child: CircularProgressIndicator());
          if (provider.errorMessage.isNotEmpty) return Center(child: Text(provider.errorMessage, style: const TextStyle(color: Colors.red)));
          if (provider.loans.isEmpty) return const Center(child: Text('Belum ada riwayat peminjaman.'));

          return LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 600) {
                return _buildDesktopTable(provider.loans);
              } else {
                return _buildMobileList(provider.loans);
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Membuka halaman form peminjaman
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoanFormScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMobileList(List<Loan> loans) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 90, top: 8),
      itemCount: loans.length,
      itemBuilder: (context, index) {
        final loan = loans[index];
        final isActive = loan.returnDate == null;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: ListTile(
            title: Text('${loan.toolName} (x${loan.qty})', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Peminjam: ${loan.borrowerName}'),
                Text('Tenggat: ${loan.dueDate}'),
                if (loan.isLate) const Text('⚠️ Terlambat', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ],
            ),
            trailing: isActive 
                ? ElevatedButton(onPressed: () => _handleReturn(loan.id), child: const Text('Kembalikan'))
                : const Icon(Icons.check_circle, color: Colors.green),
          ),
        );
      },
    );
  }

  Widget _buildDesktopTable(List<Loan> loans) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 100.0),
      child: SizedBox(
        width: double.infinity,
        child: Card(
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Peminjam')),
              DataColumn(label: Text('Alat (Jumlah)')),
              DataColumn(label: Text('Tenggat')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Aksi')),
            ],
            rows: loans.map((loan) {
              final isActive = loan.returnDate == null;
              
              Widget statusWidget = isActive 
                ? (loan.isLate ? const Chip(label: Text('Terlambat', style: TextStyle(color: Colors.white, fontSize: 11)), backgroundColor: Colors.red, side: BorderSide.none) : const Text('Aktif'))
                : const Text('Selesai', style: TextStyle(color: Colors.green));

              return DataRow(cells: [
                DataCell(Text(loan.borrowerName)),
                DataCell(Text('${loan.toolName} (x${loan.qty})')),
                DataCell(Text(loan.dueDate)),
                DataCell(statusWidget),
                DataCell(
                  isActive 
                    ? TextButton(onPressed: () => _handleReturn(loan.id), child: const Text('Kembalikan'))
                    : const Icon(Icons.check, color: Colors.green)
                ),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }
}