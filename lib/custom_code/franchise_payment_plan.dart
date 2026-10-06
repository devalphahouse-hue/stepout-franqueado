/// Payment terms persisted with the invoice, including reduced demo plans.
class FranchisePaymentPlan {
  const FranchisePaymentPlan(this.total, this.installments, this.installment);

  final double total;
  final int installments;
  final double installment;

  factory FranchisePaymentPlan.restore({
    required double total,
    int? installments,
    double? installment,
  }) {
    if (!total.isFinite || total <= 0) {
      throw const FormatException('Cobrança sem valor válido.');
    }
    // Compatibility for invoices created before terms were persisted.
    final count = installments ??
        switch (total) {
          30.0 || 25000.0 => 6,
          60.0 || 30000.0 => 12,
          _ => 1,
        };
    if (count < 1 || count > 12) {
      throw const FormatException('Quantidade de parcelas inválida.');
    }
    final expected = total / count;
    final value = installment ?? expected;
    if (!value.isFinite ||
        value <= 0 ||
        (value * count - total).abs() > count * 0.005 + 0.005) {
      throw const FormatException('Parcelas não correspondem ao total.');
    }
    return FranchisePaymentPlan(total, count, value);
  }
}
