import 'package:flutter/cupertino.dart';

extension LocaleX on BuildContext {
  /// Returns `true` when the current language code is 'ar'
  bool get isArabic =>
      Localizations.localeOf(this).languageCode.toLowerCase() == 'ar';

  /// Returns `true` when the current layout direction is RTL
}
