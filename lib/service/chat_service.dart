import 'package:flutter/material.dart';

class ChatProvider with ChangeNotifier {
  String _pcType = '';
  String _budget = '';

  String get pcType => _pcType;
  String get budget => _budget;

  void setPcType(String pcType) {
    _pcType = pcType;
    notifyListeners();
  }

  void setBudget(String budget) {
    _budget = budget;
    notifyListeners();
  }
}
