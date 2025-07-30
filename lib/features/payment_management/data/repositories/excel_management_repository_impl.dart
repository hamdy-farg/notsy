import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:notsy/core/commondomain/entities/based_api_result_models/api_result_model.dart';
import 'package:notsy/features/payment_management/data/data_source/local_database/excel_management_local_datasource/excel_management_local_datasource.dart';
import 'package:notsy/features/payment_management/domain/entities/person_entity/dart/person_Entity.dart';
import 'package:notsy/features/payment_management/domain/repositories/excel_management_repository/excel_management_repository.dart';

@Singleton(as: ExcelManagementRepository)
class ExcelManagementRepositoryImpl extends ExcelManagementRepository {
  final ExcelManagementLocalDataSource excelManagementLocalDataSource;
  const ExcelManagementRepositoryImpl({
    required this.excelManagementLocalDataSource,
  });

  @override
  Future<ApiResultModel<String>> deleteExcelFile({required File file}) {
    return excelManagementLocalDataSource.deleteExcelFile(file);
  }

  @override
  Future<ApiResultModel<List<FileSystemEntity>>> getAllExcelFiles() {
    return excelManagementLocalDataSource.getAllExcelFiles();
  }

  @override
  Future<ApiResultModel<String>> openExcelFile({required File file}) {
    return excelManagementLocalDataSource.openExcelFile(file);
  }

  @override
  Future<ApiResultModel<File>> saveExcelFile({
    required List<String> selectedCategoryName,
    required List<PersonEntity> personList,
    required String fileName,
  }) {
    return excelManagementLocalDataSource.saveExcelFile(
      selectedCategoryName,
      personList,
      fileName,
    );
  }
}
