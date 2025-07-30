import 'package:flutter/widgets.dart';

import '../../../../l10n/app_localizations.dart';

class InputValidators {
  const InputValidators._(); // prevent instantiation

  static String? validateNotEmpty(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)?.fieldRequired;
    }
    return null;
  }

  static String? validateNumber(
    BuildContext context,
    String? value, {
    bool allowZero = false,
  }) {
    final t = AppLocalizations.of(context);

    if (value == null || value.trim().isEmpty) {
      return t?.fieldRequired;
    }

    final number = num.tryParse(value);
    if (number == null) {
      return t?.fieldMustBeNumber;
    }

    if (!allowZero && number <= 0) {
      return t?.fieldGreaterThanZero;
    }

    if (allowZero && number < 0) {
      return t?.fieldCannotBeNegative;
    }

    return null;
  }

  static String? validateEgyptianPhoneNumber(
    BuildContext context,
    String? value,
  ) {
    final t = AppLocalizations.of(context);

    if (value == null || value.trim().isEmpty) {
      return t?.phoneRequired;
    }

    final regex = RegExp(r'^01[0125][0-9]{8}$');
    if (!regex.hasMatch(value)) {
      return t?.invalidEgyptianPhone;
    }

    return null;
  }

  static String? validateQuantity(BuildContext context, String? value) {
    return validateNumber(context, value);
  }

  static String? validateAmountPaid(BuildContext context, String? value) {
    return validateNumber(context, value, allowZero: true);
  }

  static String? validateCategoryName(BuildContext context, String? value) {
    return validateNotEmpty(context, value);
  }

  static String? validatePersonName(BuildContext context, String? value) {
    return validateNotEmpty(context, value);
  }

  static String? validateDescription(BuildContext context, String? value) {
    return validateNotEmpty(context, value);
  }

  static String? validateDefaultCost(BuildContext context, String? value) {
    return validateNumber(context, value, allowZero: true);
  }
}
