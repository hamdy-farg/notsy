import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:notsy/core/baseComponents/base_view_model.dart';
import 'package:notsy/features/payment_management/domain/use_case/category_usecase/get_all_category.dart';
import 'package:notsy/features/payment_management/domain/use_case/excel_management_usecase/save_excel_file.dart';
import 'package:notsy/features/payment_management/domain/use_case/payment_usecase/filter_payment_info.dart';

import '../../../../core/commondomain/entities/based_api_result_models/api_result_model.dart';
import '../../../../core/commondomain/usecase/base_param_usecase.dart';
import '../../domain/entities/payment_entities/category_entity.dart';
import '../../domain/entities/payment_entities/payment_info_entity.dart';

class PaymentReportViewModel extends BaseViewModel {
  final FilterPaymentInfo _filterPaymentInfo;
  final GetAllPaymentCategories _getAllPaymentCategories;
  final SaveExcelFile _saveExcelFile;
  PaymentReportViewModel(
    this._filterPaymentInfo,
    this._getAllPaymentCategories,
    this._saveExcelFile,
  ) {
    toDate.addListener(filterPaymentInfo);
    toDate.addListener(filterPaymentInfo);
    selectedCategoryName.addListener(filterPaymentInfo);
  }

  ValueNotifier<DateTime> toDate = ValueNotifier<DateTime>(
    DateTime.now().add(Duration(days: 1)),
  );
  //
  ValueNotifier<DateTime> fromDate = ValueNotifier<DateTime>(DateTime.now());
  ValueNotifier<List<String>> selectedCategoryName =
      ValueNotifier<List<String>>(["All"]);
  //
  final StreamController<ApiResultModel<List<CategoryEntity>>>
  _category_list_result =
      StreamController<ApiResultModel<List<CategoryEntity>>>.broadcast();
  StreamController<ApiResultModel<List<CategoryEntity>>>
  get category_list_result => _category_list_result;
  //
  final StreamController<ApiResultModel<List<PaymentInfoEntity>>>
  _payemnt_list_result =
      StreamController<ApiResultModel<List<PaymentInfoEntity>>>.broadcast();
  StreamController<ApiResultModel<List<PaymentInfoEntity>>>
  get payemnt_list_result => _payemnt_list_result;
  //
  Future<void> filterPaymentInfo() async {
    final ApiResultModel<List<PaymentInfoEntity>>? result =
        await executeParamsUseCase(
          useCase: _filterPaymentInfo,
          query: FilterPaymentParamsEntity(
            to: toDate.value,
            from: fromDate.value,
            categoryList: selectedCategoryName.value,
          ),
        );
    _payemnt_list_result.add(result!);

    notifyListeners();
  }

  Future<ApiResultModel>
  Future<void> getAllPaymentCategory() async {
    final result = await executeParamsUseCase(
      useCase: _getAllPaymentCategories,
      query: NoParams(),
    );
    log("category ${(result as Success<List<CategoryEntity>>).data}");
    _category_list_result.add(result);
    notifyListeners();
  }
}
