import 'dart:io';

import 'package:excel/excel.dart';
import 'package:notsy/core/commondomain/entities/based_api_result_models/api_result_model.dart';

abstract class ExcelManagementRepository {
  const ExcelManagementRepository();
  Future<ApiResultModel<File>> saveExcelFile({
    required Excel excel,
    required String baseFileName,
  });
  Future<ApiResultModel<List<FileSystemEntity>>> getAllExcelFiles();
  Future<ApiResultModel<String>> openExcelFile({required File file});
  Future<ApiResultModel<String>> deleteExcelFile({required File file});
}
