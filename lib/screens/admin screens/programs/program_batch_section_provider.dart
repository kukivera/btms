import "package:flutter/material.dart";

class ScheduleState with ChangeNotifier {
  String? _selectedProgram;
  String? _selectedBatch;
  String? _selectedSection;

  String? get selectedProgram => _selectedProgram;
  String? get selectedBatch => _selectedBatch;
  String? get selectedSection => _selectedSection;

  void setSelectedProgram(String id) {
    _selectedProgram = id;
    notifyListeners();
  }

  void setSelectedBatch(String id) {
    _selectedBatch = id;
    notifyListeners();
  }

  void setSelectedSection(String id) {
    _selectedSection = id;
    notifyListeners();
  }
}