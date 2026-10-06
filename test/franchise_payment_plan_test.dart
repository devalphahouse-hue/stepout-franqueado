import 'package:flutter_test/flutter_test.dart';
import 'package:stepout_franqueado/custom_code/franchise_payment_plan.dart';

void main() {
  for (final entry in <double, int>{
    10: 1,
    30: 6,
    60: 12,
    20000: 1,
    25000: 6,
    30000: 12,
  }.entries) {
    test('Restores existing plan ${entry.key} without replacing its total', () {
      final plan = FranchisePaymentPlan.restore(total: entry.key);
      expect(plan.total, entry.key);
      expect(plan.installments, entry.value);
      expect(plan.installment * plan.installments, closeTo(entry.key, 0.001));
    });
  }
  test('Persisted installments take precedence over legacy plan lookup', () {
    final plan = FranchisePaymentPlan.restore(
        total: 30, installments: 3, installment: 10);
    expect(plan.installments, 3);
    expect(plan.installment, 10);
  });
  test('Unknown positive totals keep their existing single installment', () {
    expect(FranchisePaymentPlan.restore(total: 42).installment, 42);
  });
  test('Cent rounding is allowed without changing the total', () {
    expect(
        FranchisePaymentPlan.restore(
                total: 25000, installments: 6, installment: 4166.67)
            .total,
        25000);
  });
  test('Original overcharge of two reais is rejected', () {
    expect(
        () => FranchisePaymentPlan.restore(
            total: 25000, installments: 6, installment: 4167),
        throwsFormatException);
  });
  test('Invalid terms never fall back to a real plan price', () {
    for (final total in [0.0, -1.0, double.nan, double.infinity]) {
      expect(() => FranchisePaymentPlan.restore(total: total),
          throwsFormatException);
    }
    for (final count in [0, -1, 13]) {
      expect(() => FranchisePaymentPlan.restore(total: 30, installments: count),
          throwsFormatException);
    }
    expect(
        () => FranchisePaymentPlan.restore(
            total: 30, installments: 6, installment: 500),
        throwsFormatException);
  });
}
