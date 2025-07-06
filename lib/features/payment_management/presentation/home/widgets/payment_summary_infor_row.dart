import 'package:flutter/cupertino.dart';
import 'package:notsy/core/utils/helper/extension_function/size_extension.dart';

import '../add_new_payment_view_model.dart';

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
              alignment: Alignment.centerRight,
              child: Text(
                "\$ ${value}",
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
