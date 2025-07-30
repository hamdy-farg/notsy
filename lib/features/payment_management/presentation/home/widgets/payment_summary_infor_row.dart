import 'package:flutter/cupertino.dart';
import 'package:notsy/core/commondomain/utils/extenstion/localize_money_extension.dart';
import 'package:notsy/core/utils/custom_method/is_arabic_method.dart';
import 'package:notsy/core/utils/helper/extension_function/size_extension.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../add_new_payment/add_new_payment_view_model.dart';

class PaymentSummaryInfoRow extends StatelessWidget {
  PaymentSummaryInfoRow({
    super.key,
    required this.provider,
    required this.label,
    required this.isHaveValue,
    required this.valueColor,
    required this.value,
    this.labelTextStyle,
    this.valueTextStyle,
  });
  TextStyle? valueTextStyle;
  TextStyle? labelTextStyle;
  final String label;
  final AddNewPaymentViewModel provider;

  final String value;
  final bool isHaveValue;
  final Color valueColor;
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        Text(
          label,
          style: TextStyle(
            color: Color(0xff4A4A4A),
            fontWeight: FontWeight.w500,
            fontSize: 14.w,
          ),
        ),
        if (isHaveValue)
          Expanded(
            child: Align(
              alignment: context.isArabic == true
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Text(
                "${context.money(value)}",
                style:
                    valueTextStyle ??
                    TextStyle(
                      color: valueColor,
                      fontSize: 18.w,
                      fontWeight: FontWeight.w700,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
      ],
    );
  }
}
