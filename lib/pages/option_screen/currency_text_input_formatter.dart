import 'package:flutter/services.dart';

class CurrencyTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;

    if (newText.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final intValue =
        int.tryParse(newText.replaceAll(',', '').replaceAll('₹', ''));
    if (intValue == null) {
      return oldValue;
    }

    final formattedValue = _formatCurrency(intValue);
    return newValue.copyWith(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }

  String _formatCurrency(int value) {
    String valueString = value.toString();
    String result = '';

    for (int i = 0; i < valueString.length; i++) {
      if (i > 0 && (valueString.length - i) % 2 == 0) {
        result += ',';
      }
      result += valueString[i];
    }

    return '$result';
  }
}
