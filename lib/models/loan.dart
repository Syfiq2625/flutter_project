class Loan {
  final int id;
  final int toolId;
  final String toolName;
  final String borrowerName;
  final int qty;
  final String loanDate;
  final String dueDate;
  final String? returnDate;
  final bool isLate;

  Loan({
    required this.id,
    required this.toolId,
    required this.toolName,
    required this.borrowerName,
    required this.qty,
    required this.loanDate,
    required this.dueDate,
    this.returnDate,
    required this.isLate,
  });

  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      id: json['id'],
      toolId: json['tool_id'],
      toolName: json['tool_name'],
      borrowerName: json['borrower_name'],
      qty: json['qty'],
      loanDate: json['loan_date'],
      dueDate: json['due_date'],
      returnDate: json['return_date'],
      isLate: json['is_late'] ?? false,
    );
  }
}