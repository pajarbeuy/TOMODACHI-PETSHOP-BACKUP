import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

final NumberFormat _rupiahFormatter = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp ',
  decimalDigits: 0,
);

String formatRupiah(Object? value) {
  return _rupiahFormatter.format(parseCurrency(value));
}

String formatCurrencyInput(Object? value) {
  final amount = parseCurrency(value).round();
  if (amount == 0) return '';
  return NumberFormat.decimalPattern('id_ID').format(amount);
}

double parseCurrency(Object? value) {
  if (value == null) return 0;
  if (value is num) return value.toDouble();

  final cleaned = value.toString().replaceAll(RegExp(r'[^0-9,.-]'), '');
  if (cleaned.isEmpty) return 0;

  final lastComma = cleaned.lastIndexOf(',');
  final lastDot = cleaned.lastIndexOf('.');
  final decimalSeparator = lastComma > lastDot ? ',' : '.';

  var normalized = cleaned;
  if (lastComma != -1 && lastDot != -1) {
    normalized = decimalSeparator == ','
        ? cleaned.replaceAll('.', '').replaceAll(',', '.')
        : cleaned.replaceAll(',', '');
  } else if (lastDot != -1) {
    final fractionLength = cleaned.length - lastDot - 1;
    normalized = fractionLength == 3 ? cleaned.replaceAll('.', '') : cleaned;
  } else if (lastComma != -1) {
    final fractionLength = cleaned.length - lastComma - 1;
    normalized = fractionLength == 3
        ? cleaned.replaceAll(',', '')
        : cleaned.replaceAll(',', '.');
  }

  return double.tryParse(normalized) ?? 0;
}

class RupiahInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) {
      return const TextEditingValue();
    }

    final formatted = NumberFormat.decimalPattern(
      'id_ID',
    ).format(int.parse(digits));

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
