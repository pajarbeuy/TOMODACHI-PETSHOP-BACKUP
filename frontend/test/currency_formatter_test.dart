import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontendd/utils/currency_formatter.dart';

void main() {
  group('parseCurrency', () {
    final cases = <String, double>{
      'null returns zero': 0,
      'plain integer': 12500,
      'rupiah text': 12500,
      'dot thousands': 12500,
      'comma thousands': 12500,
      'comma decimal': 12500.75,
      'dot decimal': 12500.75,
      'mixed id format': 12500.75,
      'mixed en format': 12500.75,
      'empty text': 0,
    };

    final inputs = <String, Object?>{
      'null returns zero': null,
      'plain integer': 12500,
      'rupiah text': 'Rp 12.500',
      'dot thousands': '12.500',
      'comma thousands': '12,500',
      'comma decimal': '12500,75',
      'dot decimal': '12500.75',
      'mixed id format': '12.500,75',
      'mixed en format': '12,500.75',
      'empty text': '',
    };

    for (final entry in cases.entries) {
      test(entry.key, () {
        expect(parseCurrency(inputs[entry.key]), entry.value);
      });
    }
  });

  group('formatCurrencyInput', () {
    final cases = <Object?, String>{
      0: '',
      1: '1',
      1000: '1.000',
      12500: '12.500',
      'Rp 12.500': '12.500',
      '12,500.75': '12.501',
    };

    for (final entry in cases.entries) {
      test('formats ${entry.key}', () {
        expect(formatCurrencyInput(entry.key), entry.value);
      });
    }
  });

  group('formatRupiah', () {
    test('formats zero with rupiah prefix', () {
      expect(formatRupiah(0), 'Rp 0');
    });

    test('formats thousands with id locale separator', () {
      expect(formatRupiah(12500), 'Rp 12.500');
    });

    test('parses text before formatting', () {
      expect(formatRupiah('12,500'), 'Rp 12.500');
    });
  });

  group('RupiahInputFormatter', () {
    final formatter = RupiahInputFormatter();

    test('clears text when no digits are present', () {
      final result = formatter.formatEditUpdate(
        const TextEditingValue(text: '123'),
        const TextEditingValue(text: 'abc'),
      );

      expect(result.text, '');
    });

    test('formats typed digits', () {
      final result = formatter.formatEditUpdate(
        const TextEditingValue(text: ''),
        const TextEditingValue(text: '12500'),
      );

      expect(result.text, '12.500');
      expect(result.selection.baseOffset, result.text.length);
    });
  });
}
