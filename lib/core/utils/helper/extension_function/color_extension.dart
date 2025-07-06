import 'package:flutter/material.dart';

extension ColorExtension on Color {
  Color chooseCorrectColorBasedOnTotalCostAndPaid({
    required double? totalCost,
    required double? totalPaid,
  }) {
    totalCost ??= 0;
    totalPaid ??= 0;

    if (totalCost == totalPaid) {
      return Color(0xff2E7D32);
    } else if (totalPaid == 0) {
      return Color(0xffB91C1C);
    } else if (totalCost > totalPaid!.toDouble()) {
      return Color(0xffEA580C);
    }
    return Colors.deepPurple;
  }
}
