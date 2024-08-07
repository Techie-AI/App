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
    int length = valueString.length;

    if (length <= 3) return valueString;

    String result = '';
    int counter = 0;

    for (int i = length - 1; i >= 0; i--) {
      result = valueString[i] + result;
      counter++;

      if (counter == 3 && i != 0) {
        result = ',' + result;
        counter = 0;
      } else if (counter == 2 && i > 1 && (length - i - 1) > 3) {
        result = ',' + result;
        counter = 0;
      }
    }

    return result;
  }
}
