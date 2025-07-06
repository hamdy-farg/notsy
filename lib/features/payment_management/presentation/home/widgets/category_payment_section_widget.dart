import 'package:flutter/material.dart';
import 'package:notsy/core/utils/helper/extension_function/color_extension.dart';
import 'package:notsy/core/utils/helper/extension_function/size_extension.dart';
import 'package:notsy/features/payment_management/presentation/home/widgets/payment_summary_infor_row.dart';

import '../add_new_payment_view_model.dart';

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
            label: "Cost Per Item",
            isHaveValue: true,
            valueColor: Colors.white,
            value: "${provider.categoryEntityList[index].cost ?? 0}",
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
                "${(provider.categoryEntityList[index].cost ?? 0) * (provider.categoryEntityList[index].quantity ?? 0)}",
            label: "Total Cost:",
            isHaveValue:
                (provider.categoryEntityList[index].quantity != null &&
                provider.categoryEntityList[index].cost != null),
          ),
          PaymentSummaryInfoRow(
            provider: provider,
            valueColor: Colors.transparent
                .chooseCorrectColorBasedOnTotalCostAndPaid(
                  totalCost:
                      provider.categoryEntityList[index].cost ??
                      0 * (provider.categoryEntityList[index].quantity ?? 0),
                  totalPaid: provider.categoryEntityList[index].amount_paid,
                ),
            value:
                "${((provider.categoryEntityList[index].cost ?? 0) * (provider.categoryEntityList[index].quantity ?? 0)) - (provider.categoryEntityList[index].amount_paid ?? 0)}",
            label: "remaining",
            isHaveValue:
                provider.categoryEntityList[index].quantity != null &&
                provider.categoryEntityList[index].cost != null &&
                provider.categoryEntityList[index].amount_paid != null,
          ),
        ],
      ),
    );
  }
}
