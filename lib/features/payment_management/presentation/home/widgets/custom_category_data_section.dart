import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:notsy/core/utils/helper/extension_function/size_extension.dart';
import 'package:notsy/core/utils/validators/dart/input_validators.dart';

import '../../../../../core/utils/global_widgets/custom_textFormField_widget.dart';
import '../add_new_payment_view_model.dart';
import 'category_payment_section_widget.dart';

class CustomCategoryDataWidgetSection extends StatelessWidget {
  CustomCategoryDataWidgetSection({
    super.key,
    this.onRemove,
    this.dropDownHint,
    required this.provider,
    required this.index,
    required this.formKey,
  });
  GlobalKey<FormState> formKey;
  void Function()? onRemove;
  String? dropDownHint;
  AddNewPaymentViewModel provider;
  int index;

  @override
  Widget build(BuildContext context) {
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
                  closedBorder: Border.all(
                    width: 1,
                    color: provider.categoryEntityList[index].name != ""
                        ? Color(0xffD1D5DB)
                        : Colors.red,
                  ),
                ),
                hintText: dropDownHint,
                items: provider.fitchedCategoryList
                    .map((e) => e.name ?? "")
                    .toList(),

                onChanged: (value) {
                  final category = provider.fitchedCategoryList.firstWhere(
                    (element) => element.name == value,
                  );
                  final cost = category.cost;
                  final description = category.description;
                  final original_color_value = category.original_color_value;
                  provider.setNewCategoryEntity(
                    index: index,
                    name: value,
                    cost: cost,
                    description: description,
                    original_color_value: original_color_value,
                  );
                },
              ),
            ),
            provider.categoryEntityList[index].name != ""
                ? SizedBox()
                : Text(
                    "you have to choose category",
                    style: TextStyle(color: Colors.red),
                  ),

            provider.categoryEntityList[index].name != null
                ? Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: CustomTextFormField(
                          controller: provider.amountPaidControllerList[index],
                          label: "Amount Paid",
                          hintText: "Enter Amount Paid",
                          validator: InputValidators.validateAmountPaid,
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
                          label: "Quantity",
                          hintText: "Enter Quantity",
                          onFieldSubmitted: (value) {
                            formKey.currentState!.validate();
                          },
                          validator:
                              InputValidators.validateQuantitvalidateNumbery,
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
            provider.categoryEntityList[index].name != null
                ? CategoryPaymentSection(provider: provider, index: index)
                : SizedBox(),

            SizedBox(height: 10.h),
            provider.categoryEntityList.length > 1
                ? GestureDetector(
                    // PaymentSummaryInfoRow(provider: provider, index: index, label: "remaining", isHaveValue: provider.categoryEntityList[index].quantity != null &&
                    //     provider.categoryEntityList[index].cost != null &&
                    //     provider.categoryEntityList[index].amount_paid != null)
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
                          " Remove",
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
