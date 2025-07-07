import 'dart:io';

import 'package:excel/excel.dart';
import 'package:notsy/core/commondomain/entities/based_api_result_models/api_result_model.dart';

abstract class ExcelManagementLocalDataSource {
  Future<ApiResultModel<File>> saveExcelFile(Excel excel, String baseFileName);
  Future<ApiResultModel<List<FileSystemEntity>>> getAllExcelFiles();
  Future<ApiResultModel<String>> openExcelFile(File file);
  Future<ApiResultModel<String>> deleteExcelFile(File file);
}
