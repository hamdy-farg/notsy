import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

Future<DateTime> dateTimepicker({
  required BuildContext context,
  required bool isHaveTime,
  required bool istoField,
  DateTime? from,
}) async {
  final result = await showOmniDateTimePicker(
    context: context,
    theme: ThemeData(colorSchemeSeed: Colors.white),
    initialDate: (istoField && from != null)
        ? from.add(Duration(days: 1))
        : DateTime.now(),
    firstDate: (istoField && from != null)
        ? from.add(const Duration(days: 1))
        : DateTime(1600).subtract(Duration(days: 3652)),
    lastDate: DateTime.now().add(const Duration(days: 3650)),
    is24HourMode: false,
    isShowSeconds: false,
    minutesInterval: isHaveTime ? 1 : 0,
    secondsInterval: isHaveTime ? 1 : 0,
    borderRadius: const BorderRadius.all(Radius.circular(16)),
    constraints: const BoxConstraints(maxWidth: 350, maxHeight: 650),

    transitionBuilder: (context, anim1, anim2, child) {
      return FadeTransition(
        opacity: anim1.drive(Tween(begin: 0, end: 1)),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 200),
    barrierDismissible: true,

    selectableDayPredicate: (dateTime) {
      // Disable 25th Feb 2023
      if (dateTime == DateTime(2023, 2, 25)) {
        return false;
      } else {
        return true;
      }
    },
  );
  DateTime? customDate;
  customDate = result;
  if (result != null)
    customDate = DateTime(result.year, result.month, result.day);

  return customDate ?? DateTime.now();
}

Future<DateTime> dateOnlyPicker({
  required BuildContext context,
  bool istoField = false,
  DateTime? from,
  DateTime? toPrevValue,
}) async {
  final now = DateTime.now();
  final nextDay = now.add(Duration(days: 1));

  DateTime initialDate;

  try {
    if (istoField && from != null) {
      if (toPrevValue != null && !toPrevValue.isAtSameMomentAs(nextDay)) {
        initialDate = toPrevValue;
      } else {
        initialDate = from.add(Duration(days: 1));
      }
    } else {
      initialDate = now;
    }
  } catch (e, stack) {
    // log("Error while setting initial date: $e");
    initialDate = now;
  }

  final firstDate = (istoField && from != null)
      ? from.add(Duration(days: 1))
      : DateTime(1600);

  final lastDate = now.add(Duration(days: 3650));

  final DateTime? result = await showDatePicker(
    context: context,
    currentDate: initialDate,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    builder: (context, child) {
      return Theme(
        data: ThemeData(colorSchemeSeed: Colors.white),
        child: child!,
      );
    },
  );

  // Return the result, or fall back to a logical date
  return result ??
      (toPrevValue != null && !toPrevValue.isAtSameMomentAs(nextDay)
          ? toPrevValue
          : initialDate);
}
