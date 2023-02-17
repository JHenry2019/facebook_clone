import 'package:flutter/material.dart';

class TabsManager extends ChangeNotifier {
  int currentIndex = 0;

  void changeToTab(int index) {
    currentIndex = index;
    notifyListeners();
  }
}
