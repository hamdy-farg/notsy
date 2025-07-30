import 'package:flutter/material.dart';
import 'package:notsy/core/utils/helper/extension_function/color_extension.dart';
import 'package:notsy/core/utils/helper/extension_function/size_extension.dart';
import 'package:notsy/features/payment_management/presentation/home/widgets/payment_summary_infor_row.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../add_new_payment/add_new_payment_view_model.dart';

class CategoryPaymentSection extends StatelessWidget {
  const CategoryPaymentSection({
    super.key,
    required this.provider,
    required this.index,
  });
  final AddNewPaymentViewModel provider;
  final int index;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Container(
      margin: EdgeInsets.only(top: 16.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Color(0xffF0F9F1),
        border: Border.all(color: Color(0xffC8E6C9), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          PaymentSummaryInfoRow(
            provider: provider,
            label: "${t?.costPerItem} :",
            isHaveValue: true,
            valueColor: Colors.white,
            value: "${provider.paymentEntities[index].category?.cost ?? 0}",
            valueTextStyle: TextStyle(
              color: Color(0xff2E7D32),
              fontSize: 16.w,
              fontWeight: FontWeight.w600,
            ),
          ),

          PaymentSummaryInfoRow(
            provider: provider,
            valueColor: Color(0xff2E7D32),

            value:
                "${(provider.paymentEntities[index].category?.cost ?? 0) * (provider.paymentEntities[index].quantity ?? 0)}",
            label: "${t?.totalCost} :",
            isHaveValue:
                (provider.paymentEntities[index].quantity != null &&
                provider.paymentEntities[index].category?.cost != null),
          ),
          PaymentSummaryInfoRow(
            provider: provider,
            valueColor: Colors.transparent
                .chooseCorrectColorBasedOnTotalCostAndPaid(
                  totalCost:
                      provider.paymentEntities[index].category?.cost ??
                      0 * (provider.paymentEntities[index].quantity ?? 0),
                  totalPaid: provider.paymentEntities[index].amountPaid,
                ),
            value:
                "${(provider.paymentEntities[index].category?.cost ?? 0) * (provider.paymentEntities[index].quantity ?? 0) - (provider.paymentEntities[index].amountPaid ?? 0)}",
            label: "${t?.remaining} :",
            isHaveValue:
                provider.paymentEntities[index].quantity != null &&
                provider.paymentEntities[index].category?.cost != null &&
                provider.paymentEntities[index].amountPaid != null,
          ),
        ],
      ),
    );
  }
}
