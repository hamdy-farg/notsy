class InputValidators {
  static String? validateNotEmpty(String? value, {String fieldName = 'Field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateNumber(
    String? value, {
    String fieldName = 'Field',
    bool allowZero = false,
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    final number = num.tryParse(value);
    if (number == null) {
      return '$fieldName must be a valid number';
    }

    if (!allowZero && number <= 0) {
      return '$fieldName must be greater than 0';
    }

    if (allowZero && number < 0) {
      return '$fieldName cannot be negative';
    }

    return null;
  }

  static String? validateEgyptianPhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }

    final regex = RegExp(r'^01[0125][0-9]{8}$');
    if (!regex.hasMatch(value)) {
      return 'Enter a valid Egyptian phone number';
    }

    return null;
  }

  static String? validateQuantitvalidateNumbery(String? value) {
    return validateNumber(value, fieldName: 'Quantity');
  }

  static String? validateAmountPaid(String? value) {
    return validateNumber(value, fieldName: 'Amount paid', allowZero: true);
  }

  static String? validateCategoryName(String? value) {
    return validateNotEmpty(value, fieldName: 'Category name');
  }

  static String? validatePersonName(String? value) {
    return validateNotEmpty(value, fieldName: 'Category name');
  }

  static String? validateDescription(String? value) {
    return validateNotEmpty(value, fieldName: 'Description');
  }

  static String? validateDefaultCost(String? value) {
    return validateNumber(value, fieldName: 'Default cost', allowZero: true);
  }
}
