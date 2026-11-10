import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tool_provider.dart';
import '../providers/loan_provider.dart';
import '../providers/summary_provider.dart';
import '../models/tool.dart';

class LoanFormScreen extends StatefulWidget {
  const LoanFormScreen({super.key});

  @override
  State<LoanFormScreen> createState() => _LoanFormScreenState();
}

class _LoanFormScreenState extends State<LoanFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  Tool? _selectedTool;
  final _borrowerController = TextEditingController();
  final _qtyController = TextEditingController(text: '1');
  DateTime _dueDate = DateTime.now().add(const Duration(days: 3)); // Default 3 hari
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    // Ambil daftar alat yang tersedia saja dari ToolProvider
    final tools = context.watch<ToolProvider>().tools
        .where((t) => t.status != 'rusak' && t.availableQty > 0)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Buat Peminjaman')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600), // Standar arsitektur
          child: Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<Tool>(
                      decoration: const InputDecoration(labelText: 'Pilih Alat', border: OutlineInputBorder()),
                      initialValue: _selectedTool,
                      items: tools.map((t) => DropdownMenuItem(
                        value: t,
                        child: Text('${t.name} (Sisa: ${t.availableQty})'),
                      )).toList(),
                      onChanged: (val) => setState(() => _selectedTool = val),
                      validator: (val) => val == null ? 'Alat wajib dipilih' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _borrowerController,
                      decoration: const InputDecoration(labelText: 'Nama Peminjam', border: OutlineInputBorder()),
                      validator: (val) => val!.isEmpty ? 'Nama tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: _qtyController,
                            decoration: const InputDecoration(labelText: 'Jumlah', border: OutlineInputBorder()),
                            keyboardType: TextInputType.number,
                            validator: (val) => (int.tryParse(val ?? '') ?? 0) <= 0 ? 'Minimal 1' : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: InkWell(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: _dueDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(const Duration(days: 30)),
                              );
                              if (picked != null) setState(() => _dueDate = picked);
                            },
                            child: InputDecorator(
                              decoration: const InputDecoration(labelText: 'Tenggat Kembali', border: OutlineInputBorder()),
                              child: Text("${_dueDate.year}-${_dueDate.month.toString().padLeft(2, '0')}-${_dueDate.day.toString().padLeft(2, '0')}"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitForm,
                        child: _isSubmitting 
                            ? const CircularProgressIndicator() 
                            : const Text('Simpan Peminjaman', style: TextStyle(fontSize: 16)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedTool != null) {
      setState(() => _isSubmitting = true);
      
      final data = {
        'tool_id': _selectedTool!.id,
        'borrower_name': _borrowerController.text,
        'qty': int.parse(_qtyController.text),
        'due_date': "${_dueDate.year}-${_dueDate.month.toString().padLeft(2,'0')}-${_dueDate.day.toString().padLeft(2,'0')}",
      };

      try {
        await context.read<LoanProvider>().addLoan(data);
        
        if (mounted) {
          // Segarkan data lainnya karena stok berkurang
          context.read<ToolProvider>().loadTools();
          context.read<SummaryProvider>().loadSummary();
          
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Peminjaman berhasil!'), backgroundColor: Colors.green));
          Navigator.pop(context); // Kembali ke halaman sebelumnya
        }
      } catch (e) {
        if (mounted) {
          // Tampilkan pesan error (seperti penolakan stok dari API)
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
        }
      } finally {
        if (mounted) setState(() => _isSubmitting = false);
      }
    }
  }
}