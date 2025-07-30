import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:notsy/core/utils/helper/extension_function/size_extension.dart';
import 'package:notsy/core/utils/validators/dart/input_validators.dart';

import '../../../../../core/utils/global_widgets/custom_textFormField_widget.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../add_new_payment/add_new_payment_view_model.dart';
import 'category_payment_section_widget.dart';

class CustomCategoryDataWidgetSection extends StatelessWidget {
  CustomCategoryDataWidgetSection({
    super.key,
    this.onRemove,
    this.dropDownHint,
    required this.provider,
    required this.index,
    required this.formKey,
    required this.isEdited,
  });
  bool isEdited;
  GlobalKey<FormState> formKey;
  void Function()? onRemove;
  String? dropDownHint;
  AddNewPaymentViewModel provider;
  int index;

  @override
  Widget build(BuildContext context) {
    final itemsNameList = provider.fitchedCategoryList
        .map((e) => e.name ?? "")
        .toList();
    final t = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Color(0xffD1D5DB)),
          borderRadius: BorderRadius.circular(12.w),
        ),
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: CustomDropdown<String>.search(
                decoration: CustomDropdownDecoration(
                  hintStyle: isEdited
                      ? TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.w,
                          color: Colors.black,
                        )
                      : null,
                  closedBorder: Border.all(
                    width: 1,
                    color: provider.paymentEntities[index].category?.name != ""
                        ? Color(0xffD1D5DB)
                        : Colors.red,
                  ),
                ),
                hintText: isEdited
                    ? provider.paymentEntities[index].category?.name
                    : dropDownHint,
                items: itemsNameList,

                onChanged: (value) {
                  final category = provider.fitchedCategoryList.firstWhere(
                    (element) => element.name == value,
                  );
                  provider.setNewPaymentEntity(
                    index: index,
                    category: category,
                  );
                },
              ),
            ),
            provider.paymentEntities[index].category?.name != ""
                ? SizedBox()
                : Text(
                    "${t?.chooseCategoryValidation}",
                    style: TextStyle(color: Colors.red),
                  ),

            provider.paymentEntities[index].category?.name != null
                ? Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: CustomTextFormField(
                          controller: provider.amountPaidControllerList[index],
                          label: "${t?.amountPaid}",
                          hintText: "${t?.enterAmountPaid}",
                          validator: (value) =>
                              InputValidators.validateAmountPaid(
                                context,
                                value,
                              ),
                          onFieldSubmitted: (value) {
                            formKey.currentState!.validate();
                          },
                          onChange: (value) {
                            provider.setAmountPaid(index, value);
                          },
                          hintStyle: TextStyle(
                            fontSize: 12.w,
                            fontWeight: FontWeight.w400,
                            color: Color(0xffb3b6ba),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Expanded(
                        flex: 2,
                        child: CustomTextFormField(
                          onChange: (value) {
                            provider.setQuantity(index, value);
                          },
                          controller: provider.quantityControllerList[index],
                          label: "${t?.quantity}",
                          hintText: "${t?.enterQuantity}",
                          onFieldSubmitted: (value) {
                            formKey.currentState!.validate();
                          },
                          validator: (value) =>
                              InputValidators.validateQuantity(context, value),
                          hintStyle: TextStyle(
                            fontSize: 12.w,
                            fontWeight: FontWeight.w400,
                            color: Color(0xffb3b6ba),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  )
                : SizedBox(),
            provider.paymentEntities[index].category?.name != null
                ? CategoryPaymentSection(provider: provider, index: index)
                : SizedBox(),

            SizedBox(height: 10.h),
            provider.paymentEntities.length > 1
                ? GestureDetector(
                    // PaymentSummaryInfoRow(provider: provider, index: index, label: "remaining", isHaveValue: provider.paymentEntities[index].category?.quantity != null &&
                    //     provider.paymentEntities[index].category?.cost != null &&
                    //     provider.paymentEntities[index].category?.amount_paid != null)
                    onTap: onRemove,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.delete,
                          color: Color(0xffEF4444),
                          size: 16.w,
                        ),
                        Text(
                          "${t?.remove}",
                          style: TextStyle(
                            color: Color(0xffEF4444),
                            fontWeight: FontWeight.w500,
                            fontSize: 14.w,
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
