import 'package:flutter/material.dart';
import 'package:notsy/core/commondomain/utils/extenstion/localize_money_extension.dart';
import 'package:notsy/features/payment_management/domain/entities/payment_entities/category_entity.dart';
import 'package:notsy/features/payment_management/domain/entities/payment_entities/payment_info_entity.dart';

import '../../../../l10n/app_localizations.dart';

extension PymentListExctension on List<PaymentInfoEntity> {
  PaymentInfoEntity getEffectiveCategory({
    List<String> highPriorityNames = const ['unpaid', 'underpaid'],
  }) {
    // Try to find a high-priority category like "Unpaid" or "Underpaid"

    final index = indexWhere(
      (payment) => highPriorityNames.contains(payment.paymentStatusEnum?.name),
    );

    // Return the matching category if found, or first category, or fallback
    if (index != -1) {
      return this[index];
    } else {
      return first;
    }
  }

  int getEffectivePaymentColor() {
    final effective = getEffectiveCategory();
    if (effective.colorValue == null) {
      return int.tryParse(
            "0xff${effective.category?.originalColorValue?.replaceAll('#', '')}",
          ) ??
          0xffD1D5DB;
    } else {
      return int.tryParse(
            "0xff${effective.category?.originalColorValue?.replaceAll('#', '')}",
          ) ??
          0xffD1D5DB;
    }
  }

  String getEffectivePaymentSummary(BuildContext context) {
    final t = AppLocalizations.of(context);
    double totalPaid = 0;
    double totalCost = 0;
    for (var element in this) {
      totalPaid += element.amountPaid ?? 0;
      totalCost += (element.category?.cost ?? 0) * (element.quantity ?? 0);
    }

    if (totalCost != totalPaid && totalPaid == 0) {
      return "${t?.unpaid} ${context.money(totalCost)} / $totalCost ";
    } else if (totalCost != totalPaid && totalPaid < totalCost) {
      return "${t?.need} ${context.money(totalCost - totalPaid)} / $totalCost ";
    } else if (totalCost < totalPaid) {
      return "${t?.over} ${context.money((totalPaid ?? 0) - (totalCost ?? 0))} / ";
    } else {
      return "done";
    }
  }

  Color getEffectiveSummaryColor(BuildContext context) {
    final result = getEffectivePaymentSummary(context);
    final t = AppLocalizations.of(context);
    if (result.contains("${t?.unpaid}")) {
      return Colors.red;
    }

    if (result.contains("${t?.need}")) {
      return Colors.orange;
    }
    if (result.contains("${t?.over}")) {
      return Colors.purple;
    }
    return Colors.green;
  }

  String getEffectivePaymentDescription() {
    final unpaid_index = indexWhere(
      (payment) => payment.paymentStatusEnum?.name == "unpaid",
    );
    final underpaid_index = indexWhere(
      (payment) => payment.paymentStatusEnum?.name == "underpaid",
    );

    double totalCost = 0;
    double amountPaid = 0;
    if (unpaid_index != -1) {
      totalCost =
          (this[unpaid_index].category?.cost ?? 0) *
          (this[unpaid_index].quantity ?? 0);
      return "Need \$$totalCost";
    } else if (underpaid_index != -1) {
      totalCost =
          (this[underpaid_index].category?.cost ?? 0) *
          (this[underpaid_index].quantity ?? 0);
      amountPaid = (this[underpaid_index].amountPaid?.toDouble() ?? 0);

      return "-\$${totalCost - amountPaid}";
    } else {
      for (var element in this) {
        totalCost =
            totalCost + (element.category?.cost ?? 0) * (element.quantity ?? 0);
        amountPaid = amountPaid + (element.amountPaid ?? 0);
      }
      return """${(totalCost - (amountPaid)) == 0 ? "" : "over paid : ${(amountPaid - (totalCost))}"}""";
    }
  }
}

extension PymentExctension on PaymentInfoEntity {
  String getEffectivePaymentSummary() {
    double totalPaid = amountPaid ?? 0;
    double totalCost = (category?.cost ?? 0) * (quantity ?? 0);

    if (totalCost != totalPaid && totalPaid == 0) {
      return "unpaid $totalCost / $totalCost ";
    } else if (totalCost != totalPaid && totalPaid < totalCost) {
      return "Need ${totalCost - totalPaid} / $totalCost ";
    } else if (totalCost < totalPaid) {
      return "over ${totalPaid ?? 0} / ${totalCost ?? 0} ";
    } else {
      return "done";
    }
  }

  Color getEffectiveSummaryColor() {
    final result = getEffectivePaymentSummary();
    if (result.contains("unpaid")) {
      return Colors.red;
    }
    if (result.contains("Need")) {
      return Colors.orange;
    }
    if (result.contains("over")) {
      return Colors.purple;
    }
    return Colors.green;
  }
}
