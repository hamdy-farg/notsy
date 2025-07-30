import 'package:flutter/cupertino.dart';

extension LocalizedMoneyX on BuildContext {
  /// Returns the number with the correct currency symbol:
  /// • English UI → "$ 123.45"
  /// • Arabic  UI → "١٢٣٫٤٥ ج.م"
  String money(dynamic value) {
    final isArabic = Localizations.localeOf(this).languageCode == 'ar';

    // 1️⃣  Ensure we have a clean numeric string
    final raw = value.toString();

    // 2️⃣  Convert digits if Arabic
    final number = isArabic ? _toArabicDigits(raw) : raw;

    // 3️⃣  Attach the right symbol (after in Arabic, before in English)
    return isArabic ? '$number ج.م' : '\$ $number';
  }
}

/// Helper: swap Western digits → Arabic-Indic digits.
String _toArabicDigits(String input) {
  const western = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const eastern = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

  var out = input;
  for (int i = 0; i < 10; i++) {
    out = out.replaceAll(western[i], eastern[i]);
  }
  // replace decimal point with Arabic decimal separator
  out = out.replaceAll('.', '٫');
  return out;
}
