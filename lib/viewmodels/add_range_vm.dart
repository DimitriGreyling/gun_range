import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddRangeViewModel extends ChangeNotifier {
  int _currentPage = 0;
  int get currentPage => _currentPage;

  // Example form fields
  String? rangeName;
  String? location;
  // Add more fields as needed

  void nextPage() {
    _currentPage++;
    notifyListeners();
  }

  void previousPage() {
    if (_currentPage > 0) {
      _currentPage--;
      notifyListeners();
    }
  }

  void setRangeName(String value) {
    rangeName = value;
    notifyListeners();
  }

  void setLocation(String value) {
    location = value;
    notifyListeners();
  }

  // Add validation and submission logic as needed
}

final addRangeVmProvider = ChangeNotifierProvider((ref) => AddRangeViewModel());