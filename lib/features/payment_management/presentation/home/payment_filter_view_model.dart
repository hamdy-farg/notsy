import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:notsy/core/commondomain/entities/based_api_result_models/api_result_model.dart';
import 'package:notsy/core/commondomain/usecase/base_param_usecase.dart';
import 'package:notsy/features/payment_management/domain/entities/person_entity/dart/person_Entity.dart';
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
    searchController.addListener(filterPersonInfo);
    selectedCategoryName.addListener(filterPersonInfo);
    currentPage.addListener(filterPersonInfo);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: 100));
      getAllPaymentCategory();
      filterPersonInfo();
    });
  }
  List<PersonEntity> paymentList = <PersonEntity>[];
  late final pagingController = PagingController<int, PersonEntity>(
    getNextPageKey: (state) =>
        state.lastPageIsEmpty ? null : state.nextIntPageKey,
    fetchPage: (pageKey) async {
      final result = await filterPersonInfo(page: pageKey);
      return result;
    },
  );

  //
  final TextEditingController searchController = TextEditingController();
  //
  ValueNotifier<int> currentPage = ValueNotifier<int>(1);
  //
  ValueNotifier<List<String>> selectedCategoryName =
      ValueNotifier<List<String>>(["All"]);
  //

  final FilterPersonPayments filter;
  final GetAllPaymentCategories getAllPaymentCategories;
  //
  final StreamController<ApiResultModel<List<CategoryEntity>>>
  _category_list_result =
      StreamController<ApiResultModel<List<CategoryEntity>>>.broadcast();
  StreamController<ApiResultModel<List<CategoryEntity>>>
  get category_list_result => _category_list_result;
  //
  final StreamController<ApiResultModel<List<PersonEntity>>>
  _payemnt_list_result =
      StreamController<ApiResultModel<List<PersonEntity>>>.broadcast();

  StreamController<ApiResultModel<List<PersonEntity>>>
  get payemnt_list_result => _payemnt_list_result;
  //
  ApiResultModel<List<CategoryEntity>>? categoryList;

  Future<List<PersonEntity>> filterPersonInfo({int? page}) async {
    // log(
    //   "try trye${searchController.value.text}, ${currentPage.value - 1} , ${selectedCategoryName.value}",
    // );

    final ApiResultModel<List<PersonEntity>>? result =
        await executeParamsUseCase(
          useCase: filter,
          query: FilterPaymentParamsEntity(
            input: searchController.text,
            page: page ?? currentPage.value,
            categoryList: selectedCategoryName.value,
          ),
        );

    _payemnt_list_result.add(result!);
    return (result as Success<List<PersonEntity>>).data;
    // notifyListeners();
  }

  // Future<void> setCurrentPage(int page) async {
  //   if (currentPage.value != page) {
  //     currentPage.value = page;
  //   } else {
  //     // Force trigger
  //     // await filterPaymentInfo();
  //   }
  // }

  Future<void> getAllPaymentCategory() async {
    final result = await executeParamsUseCase(
      useCase: getAllPaymentCategories,
      query: NoParams(),
    );
    // log("category ${(result as Success<List<CategoryEntity>>).data}");
    _category_list_result.add(result!);
  }

  @override
  void onDispose() {
    searchController.dispose();
    currentPage.dispose();
    selectedCategoryName.dispose();
    _payemnt_list_result.close();
    _category_list_result.close();
    pagingController.dispose();

    log("dispoooooooos home");
    // TODO: implement dispose
  }
}
