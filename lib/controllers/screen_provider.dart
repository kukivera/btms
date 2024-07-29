import 'package:flutter/material.dart';

class SelectedScreenProvider extends ChangeNotifier {
  String _selectedScreen = 'Home';

  String get selectedScreen => _selectedScreen;

  void setScreen(String screen) {
    _selectedScreen = screen;
    notifyListeners();
  }
}