import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

@injectable
class MainNavigationViewModel extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  set currentIndex(int val) {
    log("val $val");
    _currentIndex = val;
    notifyListeners();
  }
}
