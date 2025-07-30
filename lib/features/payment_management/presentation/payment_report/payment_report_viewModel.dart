import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:notsy/core/baseComponents/base_view_model.dart';
import 'package:notsy/core/commondomain/entities/based_api_result_models/error_result_model.dart';
import 'package:notsy/features/payment_management/domain/entities/payment_entities/export_to_excel_entity.dart';
import 'package:notsy/features/payment_management/domain/entities/person_entity/dart/person_Entity.dart';
import 'package:notsy/features/payment_management/domain/use_case/category_usecase/get_all_category.dart';
import 'package:notsy/features/payment_management/domain/use_case/excel_management_usecase/delete_excel_file.dart';
import 'package:notsy/features/payment_management/domain/use_case/excel_management_usecase/get_all_excelFiles.dart';
import 'package:notsy/features/payment_management/domain/use_case/excel_management_usecase/open_excel_file.dart';
import 'package:notsy/features/payment_management/domain/use_case/excel_management_usecase/save_excel_file.dart';
import 'package:notsy/features/payment_management/domain/use_case/payment_usecase/filter_payment_info.dart';

import '../../../../core/commondomain/entities/based_api_result_models/api_result_model.dart';
import '../../../../core/commondomain/usecase/base_param_usecase.dart';
import '../../../../core/utils/helper/permission_helper/dart/permossion_helper.dart';
import '../../domain/entities/payment_entities/category_entity.dart';

@injectable
class PaymentReportViewModel extends BaseViewModel {
  final FilterPersonPayments _filterPaymentInfo;
  final GetAllPaymentCategories _getAllPaymentCategories;
  final SaveExcelFile _saveExcelFile;
  final GetAllExcelFiles _getAllExcelFiles;
  final DeleteExcelFile _deleteExcelFile;
  final OpenExcelFile _openExcelFile;
  PaymentReportViewModel(
    this._filterPaymentInfo,
    this._getAllPaymentCategories,
    this._saveExcelFile,
    this._getAllExcelFiles,
    this._openExcelFile,
    this._deleteExcelFile,
  ) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: 100));
      filterPaymentInfo();
      getAllPaymentCategory();
    });
  }

  DateTime toDate = DateTime.now().add(Duration(days: 1));
  //
  // Excel? excelFile = null;
  // String? baseFileName = null;
  DateTime fromDate = DateTime.now();

  List<String> selectedCategoryName = ["All"];
  void selectedCategoryNameChange(List<String> value) {
    selectedCategoryName = value;
    notifyListeners();

    // filterPaymentInfo();
  }

  Future<void> setFromDate(DateTime value) async {
    fromDate = value;
    notifyListeners();
    await Future.delayed(Duration(milliseconds: 700));
    filterPaymentInfo();
    // filterPaymentInfo();
  }

  Future<void> setToDate(DateTime value) async {
    toDate = value;
    notifyListeners();
    await Future.delayed(Duration(milliseconds: 700));
    filterPaymentInfo();
  }

  final StreamController<ApiResultModel<List<CategoryEntity>>>
      //
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
  Future<void> filterPaymentInfo() async {
    // notifyListeners();
    // log(
    //   "try trye${toDate?.value}, ${fromDate?.value} , ${selectedCategoryName.value}",
    // );
    // log("${fromDate?.value}");
    // log("hii ${toDate?.value} \\ ${fromDate} \\ ${selectedCategoryName}");
    // Future.delayed(Duration(milliseconds: 100));
    final ApiResultModel<List<PersonEntity>>? result =
        await executeParamsUseCase(
          useCase: _filterPaymentInfo,
          query: FilterPaymentParamsEntity(
            to: DateTime(toDate!.year, toDate!.month, toDate!.day),
            from: DateTime(fromDate!.year, fromDate.month, fromDate!.day),
            categoryList: selectedCategoryName,
          ),
        );
    // log("hii ${result}");

    payemnt_list_result.add(result!);

    // notifyListeners();
  }

  Future<void> buildExcelFile(List<PersonEntity> personList) async {}

  Future<ApiResultModel<File>> exportToExcel({
    required List<PersonEntity> personList,
    required fileName,
  }) async {
    final hasPermission = await PermissionHelper.ensureStoragePermission();

    if (!hasPermission) {
      return ApiResultModel.failure(
        message: ErrorResultModel(
          message: "you must give permission to export excel",
        ),
      );
    } else {
      log(
        "message load"
        "",
      );
      final result = await executeParamsUseCase(
        useCase: _saveExcelFile,
        query: ExportToExcelEntity(
          personList: personList,
          selectedCategoryName: selectedCategoryName,
          fileName: fileName,
        ),
      );
      return result!;
    }
  }

  Future<ApiResultModel<String>> deleteExcelSheet({
    required File excelFile,
  }) async {
    final hasPermission = await PermissionHelper.ensureStoragePermission();

    if (!hasPermission) {
      return ApiResultModel.failure(
        message: ErrorResultModel(
          message: "you must give permission to export excel",
        ),
      );
    } else {
      final result = await executeParamsUseCase(
        useCase: _deleteExcelFile,
        query: excelFile,
      );

      return result!;
    }
  }

  Future<ApiResultModel<List<FileSystemEntity>>> getAllExcelSheets() async {
    final hasPermission = await PermissionHelper.ensureStoragePermission();

    if (!hasPermission) {
      return ApiResultModel.failure(
        message: ErrorResultModel(
          message: "you must give permission to export excel",
        ),
      );
    }
    final result = await executeParamsUseCase(
      useCase: _getAllExcelFiles,
      query: NoParams(),
    );
    // log("category ${(result as Success<List<FileSystemEntity>>).data}");
    return result!;
  }

  Future<ApiResultModel<String>> openExcelSheet(File file) async {
    final result = await executeParamsUseCase(
      useCase: _openExcelFile,
      query: file,
    );
    // log("category ${(result)}");

    return result!;
  }

  Future<void> getAllPaymentCategory() async {
    final result = await executeParamsUseCase(
      useCase: _getAllPaymentCategories,
      query: NoParams(),
    );
    // log("category ${(result as Success<List<CategoryEntity>>).data}");
    _category_list_result.add(result!);
    // notifyListeners();
  }

  @override
  void onDispose() {
    // log("disposed correct payment filter");
    _category_list_result.close();
    _payemnt_list_result.close();

    // log("value ${toDate?.isDisposed}");
    // TODO: implement onDispose
    super.onDispose();
  }
}
