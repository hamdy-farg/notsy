import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

@singleton
class ResponsiveUiConfig {
  late MediaQueryData _mediaQuery;
  late double _screenWidth;
  late double _screenHeight;
  double get screenWidth => _screenWidth;
  double get screenHeight => _screenHeight;

  void initialize(BuildContext context) {
    _mediaQuery = MediaQuery.of(context);
    _screenWidth = _mediaQuery.size.width;
    _screenHeight = _mediaQuery.size.height;
  }

  double setWidth(num value) => _screenWidth * (value / 375);
  double setHeight(num value) => _screenHeight * (value / 812);
}
