import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notsy/core/baseComponents/base_view_model_view.dart';
import 'package:notsy/core/utils/helper/extension_function/color_extension.dart';
import 'package:notsy/core/utils/helper/extension_function/size_extension.dart';
import 'package:notsy/core/utils/validators/dart/input_validators.dart';
import 'package:notsy/features/payment_management/domain/entities/payment_entities/payment_info_entity.dart';
import 'package:notsy/features/payment_management/presentation/home/add_new_payment_view_model.dart';

import '../../../../../core/baseComponents/base_responsive_widget.dart';
import '../../../../../core/commondomain/entities/based_api_result_models/api_result_model.dart';
import '../../../../../core/utils/custom_method/date_time_picker_mothod.dart';
import '../../../../../core/utils/global_widgets/custom_textFormField_widget.dart';
import '../../../../../core/utils/helper/extension_function/responsive_ui_helper/responsive_config.dart';
import '../../../domain/entities/payment_entities/category_entity.dart';
import '../widgets/custom_category_data_section.dart';
import '../widgets/payment_summary_infor_row.dart';

class AddNewPaymentView extends StatefulWidget {
  const AddNewPaymentView({super.key});

  @override
  State<AddNewPaymentView> createState() => _AddNewPaymentViewState();
}

class _AddNewPaymentViewState extends State<AddNewPaymentView> {
  double total_paid = 0;
  List<String> solidColors = [
    "EF4444", // Red
    "10B981", // Green
    "3B82F6", // Blue
    "6366F1", // Indigo
    "8B5CF6", // Purple
    "EC4899", // Pink
    "F97316", // Orange
    "EAB308", // Yellow
    "14B8A6", // Teal
    "9CA3AF", // Gray
    "4B5563", // Dark Gray
    "0EA5E9", // Sky Blue
    "84CC16", // Lime Green
  ];
  bool? colorIsSelected = null;
  GlobalKey<FormState> _GlobalFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _newCategoryFormKey = GlobalKey<FormState>();

  AddNewPaymentViewModel? _provider;

  Future<void> _fetchAllCategory() async {
    final result = await _provider?.getAllCategory();
    if (result is Success<List<CategoryEntity>>) {
      _provider?.fitchedCategoryList = result.data;
    } else if (result is Failure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('snack'),
          duration: const Duration(seconds: 1),
          action: SnackBarAction(
            label: '${(result as Failure).message.message}',

            onPressed: () {},
          ),
        ),
      );
    }
  }

  int? _selectedIndex = null;

  @override
  Widget build(BuildContext context) {
    return BaseResponsiveWidget(
      buildWidget: (BuildContext context, ResponsiveUiConfig responsiveUiConfig) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios_outlined,
              color: Color(0xff2E7D32),
              size: 24,
              weight: 400,
            ),
          ),
          centerTitle: true,
          title: Text(
            "New Payment",
            style: TextStyle(
              color: Color(0xff2E7D32),
              fontWeight: FontWeight.w600,
              fontSize: 20.w,
            ),
          ),
        ),
        body: SafeArea(
          child: BaseViewModelView<AddNewPaymentViewModel>(
            onInitState: (AddNewPaymentViewModel provider) async {
              _provider = provider;
              _provider!.addCategoryField();
              _fetchAllCategory();
            },
            buildWidget: (AddNewPaymentViewModel provider) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 16.h,
                    horizontal: 16.w,
                  ),
                  child: Form(
                    key: _GlobalFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //
                        CustomTextFormField(
                          controller: _provider!.nameController,
                          label: "Person Name",
                          hintText: "Enter Person Name",
                          validator: InputValidators.validatePersonName,
                          onFieldSubmitted: (value) {
                            _GlobalFormKey.currentState!.validate();
                          },
                        ),
                        CustomTextFormField(
                          controller: _provider!.phoneNumberController,
                          label: "Person Number",
                          hintText: "Enter Person Number",
                          keyboardType: TextInputType.phone,
                          validator:
                              InputValidators.validateEgyptianPhoneNumber,
                          onFieldSubmitted: (value) {
                            _GlobalFormKey.currentState!.validate();
                          },
                        ),
                        CustomTextFormField(
                          hintText: DateFormat(
                            'EEEE, MMMM d, yyyy \'at\' h:mm a',
                          ).format(_provider?.dateTime ?? DateTime.now()),
                          readOnly: true,
                          hintStyle: TextStyle(
                            color: Color(0xff111827),
                            fontSize: 16.w,
                            fontWeight: FontWeight.w400,
                          ),
                          suffixIcon: Icon(
                            Icons.calendar_today,
                            size: 24.w,
                            color: Color(0xff6B7280),
                          ),
                          suffixIconOnPressed: () async {
                            final result = await dateTimepicker(
                              context: context,
                            );
                            _provider?.setDateTime(result);
                            log("1111111${provider.dateTime}");
                          },
                        ),

                        Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Text(
                            "Category Payment",
                            style: TextStyle(
                              color: Color(0xff1F2937),
                              fontSize: 18.w,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        for (
                          int index = 0;
                          index < _provider!.categoryEntityList.length;
                          index++
                        )
                          CustomCategoryDataWidgetSection(
                            formKey: _GlobalFormKey,
                            provider: provider,
                            index: index,
                            dropDownHint: "Select Category",
                            onRemove: () {
                              _provider?.removeCategoryField(index: index);
                            },
                          ),

                        //
                        GestureDetector(
                          onTap: () {
                            _provider?.addCategoryField();
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 16.h),
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xffF0F9F1),

                              border: Border.all(
                                color: Color(0xff2E7D32),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  color: Color(0xff2E7D32),
                                  size: 25,
                                ),
                                Text(
                                  " Add Another Category",
                                  style: TextStyle(
                                    color: Color(0xff2E7D32),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.w,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.only(top: 20.h),
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: Color(0xffF0F9F1),
                            border: Border.all(
                              color: Color(0xff2E7D32),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.panorama_vertical_sharp,
                                    color: Color(0xff2E7D32),
                                    size: 24.w,
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    "Payment Summary",
                                    style: TextStyle(
                                      fontSize: 18.w,
                                      color: Color(0xff2E7D32),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 7),
                                width: double.infinity,
                                height: 1,
                                color: Color(0xff2E7D32),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5, bottom: 8),
                                child: PaymentSummaryInfoRow(
                                  provider: provider,
                                  label: "Total Amount Paid",
                                  isHaveValue: true,
                                  valueColor: Colors.white,
                                  value:
                                      (_provider
                                          ?.getTotalAmountPaid()
                                          .toString() ??
                                      "0"),
                                  labelTextStyle: TextStyle(
                                    fontSize: 16.w,
                                    color: Color(0xff1E1E1E),
                                    fontWeight: FontWeight.w700,
                                  ),
                                  valueTextStyle: TextStyle(
                                    fontSize: 20.w,
                                    color: Color(0xff2E7D32),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: PaymentSummaryInfoRow(
                                  provider: provider,
                                  label: "Total Cost:",
                                  isHaveValue: true,
                                  valueColor: Colors.white,
                                  value:
                                      (_provider?.getTotalCost().toString() ??
                                      "0"),
                                  labelTextStyle: TextStyle(
                                    fontSize: 16.w,
                                    color: Color(0xff1E1E1E),
                                    fontWeight: FontWeight.w700,
                                  ),
                                  valueTextStyle: TextStyle(
                                    fontSize: 20.w,
                                    color: Color(0xff2E7D32),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: PaymentSummaryInfoRow(
                                    provider: provider,
                                    label: "Total remaining:",
                                    isHaveValue: true,
                                    valueColor: Colors.white,
                                    value:
                                        (_provider
                                            ?.getTotalRemaining()
                                            .toString() ??
                                        "0"),
                                    labelTextStyle: TextStyle(
                                      fontSize: 16.w,
                                      color: Color(0xff2E7D32),
                                      fontWeight: FontWeight.w700,
                                    ),
                                    valueTextStyle: TextStyle(
                                      fontSize: 20.w,
                                      color: Colors.transparent
                                          .chooseCorrectColorBasedOnTotalCostAndPaid(
                                            totalCost: provider.getTotalCost(),
                                            totalPaid: provider
                                                .getTotalAmountPaid(),
                                          ),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (_provider?.newCategoryEntity == null) {
                              _provider?.addNewCategoryField();
                            } else {
                              colorIsSelected = null;
                              _provider?.removeNewCategoryField();
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 16.h),
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xff2E7D32),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  " Add New Category",
                                  style: TextStyle(
                                    color: Color(0xff2E7D32),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.w,
                                  ),
                                ),
                                _provider?.newCategoryEntity != null
                                    ? Icon(
                                        Icons.keyboard_arrow_up,
                                        color: Color(0xff2E7D32),
                                        size: 25,
                                      )
                                    : Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Color(0xff2E7D32),
                                        size: 25,
                                      ),
                              ],
                            ),
                          ),
                        ),
                        _provider?.newCategoryEntity != null
                            ? Form(
                                key: _newCategoryFormKey,
                                child: Container(
                                  margin: EdgeInsets.only(top: 16.h),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 10.h,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color(0xffE5E7EB),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomTextFormField(
                                        label: "Category Name",
                                        hintText: "Enter New Category Name",
                                        validator: InputValidators
                                            .validateCategoryName,
                                        onFieldSubmitted: (value) {
                                          _newCategoryFormKey.currentState!
                                              .validate();
                                        },
                                        onChange: (value) {
                                          _provider?.setNewCategoryName(value);
                                        },
                                        controller: _provider
                                            ?.newCategoryNameController,
                                      ),
                                      CustomTextFormField(
                                        maxLines: 3,
                                        label: "Description (optional)",
                                        hintText: "Enter Description",
                                        validator:
                                            InputValidators.validateDescription,
                                        onChange: (value) {
                                          _provider?.setNewCategoryDescription(
                                            value,
                                          );
                                        },
                                        onFieldSubmitted: (value) {
                                          _newCategoryFormKey.currentState!
                                              .validate();
                                        },
                                        controller: _provider
                                            ?.newCategoryDescriptionController,
                                      ),
                                      CustomTextFormField(
                                        label: "Default Cost",
                                        hintText: "Enter default Cost",
                                        controller: _provider
                                            ?.newCategoryCostController,
                                        validator:
                                            InputValidators.validateDefaultCost,

                                        onFieldSubmitted: (value) {
                                          _newCategoryFormKey.currentState!
                                              .validate();
                                        },
                                        onChange: (value) {
                                          _provider?.setNewCategoryCost(value);
                                        },
                                        keyboardType: TextInputType.number,
                                      ),
                                      GestureDetector(
                                        child: Container(
                                          padding: EdgeInsets.only(top: 10.h),
                                          child: Text(
                                            "Category Color",
                                            style: TextStyle(
                                              color: Color(0xff4B5563),
                                              fontSize: 14.w,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),

                                      Container(
                                        margin: EdgeInsets.only(top: 20.h),
                                        child: GridView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 6,
                                                crossAxisSpacing: 30,
                                                mainAxisSpacing: 20,
                                                childAspectRatio: 1,
                                              ),
                                          itemCount: 12,
                                          itemBuilder: (context, index) {
                                            bool isSelected =
                                                _selectedIndex == index;

                                            return GestureDetector(
                                              onTap: () {
                                                _selectedIndex = index;

                                                colorIsSelected = true;
                                                _provider
                                                    ?.setOriginalColorValue(
                                                      solidColors[index],
                                                    );
                                              },
                                              child: AnimatedScale(
                                                scale: isSelected ? 1.2 : .8,
                                                duration: Duration(
                                                  milliseconds: 700,
                                                ),
                                                curve: Curves.easeOutBack,
                                                child: AnimatedContainer(
                                                  duration: Duration(
                                                    milliseconds: 300,
                                                  ),
                                                  curve: Curves.easeInOut,
                                                  decoration: BoxDecoration(
                                                    color: isSelected
                                                        ? Color(
                                                            int.parse(
                                                              "0xff${solidColors[index]}",
                                                            ),
                                                          )
                                                        : Color(
                                                            int.parse(
                                                              "0xff${solidColors[index]}",
                                                            ),
                                                          ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                    boxShadow: isSelected
                                                        ? [
                                                            BoxShadow(
                                                              color: Color(
                                                                int.parse(
                                                                  "0xff${solidColors[index]}",
                                                                ),
                                                              ).withOpacity(0.4),
                                                              blurRadius: 10,
                                                              spreadRadius: 2,
                                                              offset: Offset(
                                                                0,
                                                                4,
                                                              ),
                                                            ),
                                                          ]
                                                        : [],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 20.h),
                                        padding: EdgeInsets.symmetric(
                                          vertical: 5.h,
                                          horizontal: 16.w,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: colorIsSelected == false
                                                ? Colors.red
                                                : Color(0xffE5E7EB),
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 20.w,
                                              width: 20.w,
                                              decoration: BoxDecoration(
                                                color:
                                                    _provider
                                                            ?.originalColorValue !=
                                                        null
                                                    ? Color(
                                                        int.tryParse(
                                                              "0xff${_provider?.originalColorValue}",
                                                            ) ??
                                                            0xff000000,
                                                      )
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                            Text(
                                              "   Preview:  ",
                                              style: TextStyle(
                                                color: Color(0xff4B5563),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14.w,
                                              ),
                                            ),
                                            ConstrainedBox(
                                              constraints: BoxConstraints(
                                                maxWidth: 200,
                                              ),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 8.w,
                                                  vertical: 2.w,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Color(
                                                    int.tryParse(
                                                          "0xff${_provider?.originalColorValue}",
                                                        ) ??
                                                        0xff000000,
                                                  ).withOpacity(.1),
                                                ),
                                                child: Text(
                                                  _provider!
                                                          .newCategoryNameController
                                                          .text
                                                          .isNotEmpty
                                                      ? _provider!
                                                            .newCategoryNameController
                                                            .text
                                                      : "category Name",
                                                  style: TextStyle(
                                                    fontSize: 12.w,
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        _provider!
                                                                .originalColorValue !=
                                                            null
                                                        ? Color(
                                                            int.tryParse(
                                                                  "0xff${_provider?.originalColorValue}",
                                                                ) ??
                                                                0xff000000,
                                                          )
                                                        : Colors.red,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      colorIsSelected == false
                                          ? Text(
                                              "you have to choose category color",
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12.w,
                                              ),
                                            )
                                          : SizedBox(),
                                      GestureDetector(
                                        onTap: () async {
                                          if (colorIsSelected == null ||
                                              colorIsSelected == false) {
                                            _newCategoryFormKey.currentState!
                                                .validate();
                                            colorIsSelected = false;

                                            provider.setOriginalColorValue(
                                              null,
                                            );
                                            return;
                                          }
                                          if (_newCategoryFormKey.currentState!
                                              .validate()) {
                                            final result = await _provider
                                                ?.addNewCategory_();

                                            if (result is Success<int>) {
                                              log("success");
                                              _provider
                                                  ?.removeNewCategoryField();
                                              _fetchAllCategory();
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: const Text('snack'),
                                                  duration: const Duration(
                                                    seconds: 1,
                                                  ),
                                                  action: SnackBarAction(
                                                    label: 'success',
                                                    onPressed: () {
                                                      // Some code to undo the change.
                                                    },
                                                  ),
                                                ),
                                              );
                                            } else if (result is Failure) {
                                              log("success2");

                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    '${(result as Failure).message}',
                                                  ),
                                                  duration: const Duration(
                                                    seconds: 1,
                                                  ),
                                                  action: SnackBarAction(
                                                    label: 'fail',
                                                    onPressed: () {
                                                      // Some code to undo the change.
                                                    },
                                                  ),
                                                ),
                                              );
                                            }
                                          }
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(top: 20.h),
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 24.w,
                                            vertical: 12.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Color(0xff2E7D32),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Save Category",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.w,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(),

                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "Payment Method",
                            style: TextStyle(
                              color: Color(0xff1F2937),
                              fontSize: 18.w,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xff2E7D32),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    _provider?.setPaymentMethod(
                                      PaymentMethodEnum.cash,
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          _provider?.paymentMethodEnum ==
                                              PaymentMethodEnum.cash
                                          ? Color(0xff2E7D32)
                                          : Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Cash",
                                      style: TextStyle(
                                        color:
                                            _provider?.paymentMethodEnum ==
                                                PaymentMethodEnum.cash
                                            ? Colors.white
                                            : Color(0xff2E7D32),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.w,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              //!
                              //!
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    _provider?.setPaymentMethod(
                                      PaymentMethodEnum.vodafone_cash,
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 16,
                                    ),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color:
                                          _provider?.paymentMethodEnum ==
                                              PaymentMethodEnum.vodafone_cash
                                          ? Color(0xff2E7D32)
                                          : Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      "Vodafone Cash",

                                      style: TextStyle(
                                        color:
                                            _provider?.paymentMethodEnum ==
                                                PaymentMethodEnum.vodafone_cash
                                            ? Colors.white
                                            : Color(0xff2E7D32),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.w,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1), // light black
                offset: Offset(0, -4), // shadow above the container
                blurRadius: 10,
                spreadRadius: 0,
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: GestureDetector(
            onTap: () async {
              if (_provider!.categoryEntityList.length >= 1) {
                for (
                  int index = 0;
                  index < _provider!.categoryEntityList.length;
                  index++
                ) {
                  log("${_provider?.categoryEntityList[index].name}");
                  if (_provider?.categoryEntityList[index].name == null) {
                    _GlobalFormKey.currentState!.validate();
                    _provider?.setCategoryName(index: index, name: "");
                  }
                }
              }

              if (_GlobalFormKey.currentState!.validate()) {
                final result = await _provider?.addPayment();
                if (result is Success<int>) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('snack'),
                      duration: const Duration(seconds: 1),
                      action: SnackBarAction(
                        label: 'success',
                        onPressed: () {
                          // Some code to undo the change.
                        },
                      ),
                    ),
                  );
                } else if (result is Failure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${(result as Failure).message}'),
                      duration: const Duration(seconds: 1),

                      action: SnackBarAction(
                        label: 'fail',
                        onPressed: () {
                          // Some code to undo the change.
                        },
                      ),
                    ),
                  );
                }
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                color: Color(0xff2E7D32),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  "Submit Payment",

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.w,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
