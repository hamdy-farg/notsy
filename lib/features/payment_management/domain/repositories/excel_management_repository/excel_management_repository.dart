import 'dart:io';

import 'package:notsy/core/commondomain/entities/based_api_result_models/api_result_model.dart';

import '../../entities/person_entity/dart/person_Entity.dart';

abstract class ExcelManagementRepository {
  const ExcelManagementRepository();
  Future<ApiResultModel<File>> saveExcelFile({
    required List<String> selectedCategoryName,
    required List<PersonEntity> personList,
    required String fileName,
  });
  Future<ApiResultModel<List<FileSystemEntity>>> getAllExcelFiles();
  Future<ApiResultModel<String>> openExcelFile({required File file});
  Future<ApiResultModel<String>> deleteExcelFile({required File file});
}
