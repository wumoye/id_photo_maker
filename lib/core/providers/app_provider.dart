import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  bool _isProcessing = false;
  
  bool get isProcessing => _isProcessing;
  
  void setProcessing(bool value) {
    _isProcessing = value;
    notifyListeners();
  }
}