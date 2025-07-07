import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:notsy/core/commondomain/entities/based_api_result_models/api_result_model.dart';
import 'package:notsy/core/commondomain/usecase/base_param_usecase.dart';
import 'package:notsy/features/payment_management/domain/entities/payment_entities/payment_info_entity.dart';
import 'package:notsy/features/payment_management/domain/use_case/category_usecase/get_all_category.dart';
import 'package:notsy/features/payment_management/domain/use_case/payment_usecase/filter_payment_info.dart';

import '../../../../core/baseComponents/base_view_model.dart';
import '../../domain/entities/payment_entities/category_entity.dart';

@injectable
class HomePaymentFilterViewModel extends BaseViewModel {
  HomePaymentFilterViewModel({
    required this.filter,
    required this.getAllPaymentCategories,
  }) {
    searchController.addListener(filterPaymentInfo);
    selectedCategoryName.addListener(filterPaymentInfo);
    currentPage.addListener(filterPaymentInfo);
  }
  List<PaymentInfoEntity> paymentList = <PaymentInfoEntity>[];
  late final pagingController = PagingController<int, PaymentInfoEntity>(
    getNextPageKey: (state) =>
        state.lastPageIsEmpty ? null : state.nextIntPageKey,
    fetchPage: (pageKey) {
      currentPage.value = pageKey;
      return paymentList;
    },
  );

  //
  final TextEditingController searchController = TextEditingController();
  //
  ValueNotifier<int> currentPage = ValueNotifier<int>(0);
  //
  ValueNotifier<List<String>> selectedCategoryName =
      ValueNotifier<List<String>>(["All"]);
  //

  final FilterPaymentInfo filter;
  final GetAllPaymentCategories getAllPaymentCategories;
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
  ApiResultModel<List<CategoryEntity>>? categoryList;

  Future<void> filterPaymentInfo() async {
    log(
      "try trye${searchController.value}, ${currentPage.value} , ${selectedCategoryName.value}",
    );
    final ApiResultModel<List<PaymentInfoEntity>>? result =
        await executeParamsUseCase(
          useCase: filter,
          query: FilterPaymentParamsEntity(
            input: searchController.text,
            page: currentPage.value,
            categoryList: selectedCategoryName.value,
          ),
        );

    _payemnt_list_result.add(result!);

    notifyListeners();
  }

  Future<void> setCurrentPage(int page) async {
    if (currentPage.value != page) {
      currentPage.value = page;
    } else {
      // Force trigger
      await filterPaymentInfo();
    }
  }

  Future<void> getAllPaymentCategory() async {
    final result = await executeParamsUseCase(
      useCase: getAllPaymentCategories,
      query: NoParams(),
    );
    log("category ${(result as Success<List<CategoryEntity>>).data}");
    _category_list_result.add(result);
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    log("dispooooooose1");

    // TODO: implement
    //  dispose
  }

  @override
  void onDispose() {
    log("dispooooooose");
    searchController.dispose();
    currentPage.dispose();
    selectedCategoryName.dispose();
    _payemnt_list_result.close();
    // TODO: implement dispose
  }
}
