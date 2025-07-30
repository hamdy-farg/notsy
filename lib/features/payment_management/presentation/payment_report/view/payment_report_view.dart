import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notsy/core/baseComponents/base_responsive_widget.dart';
import 'package:notsy/core/baseComponents/base_view_model_view.dart';
import 'package:notsy/core/common_presentation/bottom_navigation/wigets/custom_snackBarWidget.dart';
import 'package:notsy/core/commondomain/utils/extenstion/localize_money_extension.dart';
import 'package:notsy/core/utils/global_widgets/custom_textFormField_widget.dart';
import 'package:notsy/core/utils/helper/extension_function/responsive_ui_helper/responsive_config.dart';
import 'package:notsy/core/utils/helper/extension_function/size_extension.dart';
import 'package:notsy/features/payment_management/domain/entities/person_entity/dart/person_Entity.dart';
import 'package:notsy/features/payment_management/presentation/payment_report/payment_report_viewModel.dart';
import 'package:provider/provider.dart';

import '../../../../../core/commondomain/entities/based_api_result_models/api_result_model.dart';
import '../../../../../core/utils/custom_method/date_time_picker_mothod.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/entities/payment_entities/category_entity.dart';
import '../widgets/ask_for_excel_dailog_widget.dart';
import 'excel_import_view.dart';

class PaymentReportView extends StatefulWidget {
  const PaymentReportView({super.key});

  @override
  State<PaymentReportView> createState() => _PaymentReportViewState();
}

class _PaymentReportViewState extends State<PaymentReportView> {
  List<CategoryEntity> _category_list = <CategoryEntity>[];
  List<PersonEntity> _person_list = <PersonEntity>[];
  double totalCost = 0;
  double totalAmountPaid = 0;
  double totalRemaining = 0;
  PaymentReportViewModel? _provider;
  void _listenToLocalPaymentList() {
    _provider?.payemnt_list_result.stream.listen((
      ApiResultModel<List<PersonEntity>> result,
    ) {
      // log("listener is on $result");
      if (result is Success<List<PersonEntity>>) {
        _person_list.clear();
        _person_list = (result.data);
        totalRemaining = 0;
        totalCost = 0;
        totalAmountPaid = 0;
        for (var person in _person_list) {
          final payments = person.payments ?? [];

          for (var payment in payments) {
            final cost = payment.category?.cost ?? 0;
            final paid = payment.amountPaid ?? 0;
            final quantity = payment.quantity ?? 0;
            // log("values ${_provider!.selectedCategoryName.value}");
            if (_provider!.selectedCategoryName.contains(
                  payment.category?.name,
                ) ||
                _provider!.selectedCategoryName.contains("All")) {
              totalAmountPaid += paid;
              totalCost += cost * quantity;
              totalRemaining += (totalCost - totalAmountPaid);
            }
          }
        }
        // log("totals ${totalCost} , ${totalAmountPaid} , ${totalRemaining}");
        // log("new PaymentList : ${_payment_list}");
      } else {
        showAppSnack(
          context,
          "there is error please try again",
          fromTop: true,
          isError: true,
          icon: Icons.error,
        );
      }
    });
  }

  void _listenToAllPaymentCategory() async {
    _provider?.category_list_result.stream.listen((
      ApiResultModel<List<CategoryEntity>> result,
    ) {
      if (result is Success<List<CategoryEntity>>) {
        _category_list.clear();
        _category_list.add(
          CategoryEntity(name: "All", originalColorValue: "2E7D32"),
        );

        _category_list?.addAll(result.data);
        // log("activated now ${_category_list}");
      } else {
        showAppSnack(
          context,
          "there is error please try again",
          fromTop: true,
          isError: true,
          icon: Icons.error,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return BaseResponsiveWidget(
      initializeConfig: true,
      buildWidget:
          (
            BuildContext context,
            ResponsiveUiConfig responsiveUiConfig,
          ) => BaseViewModelView<PaymentReportViewModel>(
            onInitState: (PaymentReportViewModel provider) {
              _provider = provider;

              _listenToLocalPaymentList();
              _listenToAllPaymentCategory();
            },
            buildWidget: (PaymentReportViewModel provider) {
              return Scaffold(
                appBar: AppBar(
                  elevation: 0, // optional: flat app bar
                  surfaceTintColor: Colors.transparent,
                  centerTitle: true,
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(1.0),
                    child: Container(
                      color: Colors.grey, // border color
                      height: .4,
                    ),
                  ),
                  title: Text(
                    "${t?.reports}",

                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 20.w,
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChangeNotifierProvider.value(
                              value: _provider!, // use the existing instance
                              child: ExcelImportView(),
                            ),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.folder_copy_outlined,
                        color: Colors.black,
                        size: 24.w,
                      ),
                    ),
                    SizedBox(width: 20.w),
                  ],
                ),
                body: SafeArea(
                  child: Align(
                    alignment: Alignment.topCenter,

                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextFormField(
                                    readOnly: true,
                                    hintText: provider.fromDate == null
                                        ? "select start time"
                                        : provider.fromDate.toString(),
                                    suffixIcon: Icon(
                                      color: Color(0xffD1D5DB),
                                      Icons.calendar_today,
                                      size: 25,
                                    ),
                                    suffixIconOnPressed: () async {
                                      final result = await dateOnlyPicker(
                                        context: context,
                                        istoField: false,
                                      );
                                      _provider?.setFromDate(result);
                                      DateTime current = result;
                                      _provider?.setToDate(
                                        current.add(Duration(days: 1)),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(width: 20.w),
                                Expanded(
                                  child: CustomTextFormField(
                                    readOnly: true,
                                    hintText: provider.toDate == null
                                        ? "select end date"
                                        : provider.toDate.toString(),

                                    suffixIcon: Icon(
                                      color: Color(0xffD1D5DB),
                                      Icons.calendar_today,
                                      size: 20,
                                    ),
                                    suffixIconOnPressed: () async {
                                      final result = await dateOnlyPicker(
                                        context: context,
                                        istoField: true,
                                        from: _provider?.fromDate,
                                        toPrevValue: _provider?.toDate,
                                      );
                                      _provider?.setToDate(result);
                                    },
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 10.h),
                            SizedBox(
                              height: 33.h,

                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: _category_list.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      //   log(
                                      //     "categorys ${provider.selectedCategoryName.value ?? ""}",
                                      //   );

                                      final current = List<String>.from(
                                        provider.selectedCategoryName,
                                      );

                                      // log("categorys ${_category_list ?? ""}");
                                      if (!provider.selectedCategoryName
                                          .contains(
                                            _category_list[index].name,
                                          )) {
                                        //
                                        current.add(
                                          _category_list[index].name ?? "",
                                        );
                                        if (_category_list[index].name !=
                                            "All") {
                                          current.remove("All");
                                        }
                                        if (_category_list[index].name ==
                                            "All") {
                                          current.clear();
                                          current.add(
                                            _category_list[index].name ?? "",
                                          );
                                        }
                                      } else {
                                        //
                                        current.remove(
                                          _category_list[index].name,
                                        );
                                        if (current.isEmpty) {
                                          current.add("All");
                                        } //
                                      }
                                      provider.selectedCategoryNameChange(
                                        current,
                                      );
                                      await Future.delayed(
                                        Duration(milliseconds: 5),
                                      );
                                      await _provider?.filterPaymentInfo();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),

                                      decoration: BoxDecoration(
                                        color:
                                            provider.selectedCategoryName
                                                .contains(
                                                  _category_list[index].name,
                                                )
                                            ? Color(
                                                int.tryParse(
                                                      "0xff${_category_list[index].originalColorValue}",
                                                    ) ??
                                                    0,
                                              )
                                            : Color(
                                                int.tryParse(
                                                      "0xff${_category_list[index].originalColorValue}",
                                                    ) ??
                                                    0,
                                              ).withOpacity(.2),

                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          width: 1,
                                          color: Color(
                                            int.tryParse(
                                                  "0xff${_category_list[index].originalColorValue}",
                                                ) ??
                                                0,
                                          ),
                                        ),
                                      ),

                                      margin: EdgeInsets.only(left: 8.w),
                                      child: Text(
                                        "${_category_list[index].name}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13.w,
                                          color:
                                              provider.selectedCategoryName
                                                  .contains(
                                                    _category_list[index].name,
                                                  )
                                              ? Colors.white
                                              : Color(
                                                  int.tryParse(
                                                        "0xff${_category_list[index].originalColorValue}",
                                                      ) ??
                                                      0,
                                                ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 10.h),
                            CustomTotalContainer(
                              context.money(totalAmountPaid),
                              "${t?.totalAmountPaid}",
                              Color(0xFFF2FDF6),
                              "./assets/json_images/Banknote-bro.svg",
                            ),
                            CustomTotalContainer(
                              context.money(totalCost),
                              "${t?.totalCost}",
                              Color(0xFFF0F8FF),
                              "./assets/json_images/Browser stats-rafiki.svg",
                            ),
                            CustomTotalContainer(
                              context.money(totalRemaining),
                              "${t?.totalRemaining}",
                              Color(0xFFFDF8EC),
                              "./assets/json_images/Online world-cuate.svg",
                            ),
                            SizedBox(height: 30.h),
                            GestureDetector(
                              onTap: () async {
                                final String? fileName = await askForExcelName(
                                  context,
                                );

                                if (fileName == null || fileName.trim().isEmpty)
                                  return; // user cancelled

                                final exportResult = await _provider
                                    ?.exportToExcel(
                                      personList: _person_list,
                                      fileName: fileName,
                                    );
                                if (exportResult is Success<File>) {
                                  showAppSnack(
                                    context,
                                    "your file is saved you can look at files at top right corner",
                                    fromTop: true,
                                  );
                                } else if (exportResult is Failure) {
                                  showAppSnack(
                                    context,
                                    "we have error while saving",
                                    icon: Icons.error,
                                    isError: true,
                                    fromTop: true,
                                  );
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      (totalCost == 0 && totalAmountPaid == 0)
                                      ? Color(0xffe9e9ed)
                                      : Color(0xff34D399),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.calendar_month_outlined,
                                      color:
                                          (totalCost == 0 &&
                                              totalAmountPaid == 0)
                                          ? Color(0xff374151)
                                          : Color(0xffe9e9ed),
                                      size: 24.w,
                                    ),
                                    SizedBox(width: 5.w),
                                    Text(
                                      "${t?.exportFilteredExcel}",
                                      style: TextStyle(
                                        color:
                                            (totalCost == 0 &&
                                                totalAmountPaid == 0)
                                            ? Color(0xff374151)
                                            : Color(0xffe9e9ed),
                                        fontSize: 16.w,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
    );
  }
}

Widget CustomTotalContainer(
  String total,
  String title,
  Color backGroundImageColor,
  String imageAddress,
) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 5.h),
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: .6,
          blurRadius: 8,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 70.w,
          height: 70.w, // Use same width & height for a perfect circle
          decoration: BoxDecoration(
            color: backGroundImageColor, // Background color
            shape: BoxShape.circle,
          ),

          padding: EdgeInsets.all(12), // Optional: for inner padding
          child: SvgPicture.asset(imageAddress, fit: BoxFit.cover),
        ),
        SizedBox(width: 10.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Color(0xff6B7280),
                fontSize: 16.w,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              "$total",
              style: TextStyle(
                color: Color(0xff111827),
                fontSize: 20.w,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
