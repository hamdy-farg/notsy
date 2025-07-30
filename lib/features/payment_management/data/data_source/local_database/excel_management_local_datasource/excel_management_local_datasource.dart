import 'dart:io';

import 'package:notsy/core/commondomain/entities/based_api_result_models/api_result_model.dart';
import 'package:notsy/features/payment_management/domain/entities/person_entity/dart/person_Entity.dart';

abstract class ExcelManagementLocalDataSource {
  Future<ApiResultModel<File>> saveExcelFile(
    List<String> excel,
    List<PersonEntity> baseFileName,
    String fileName,
  );
  Future<ApiResultModel<List<FileSystemEntity>>> getAllExcelFiles();
  Future<ApiResultModel<String>> openExcelFile(File file);
  Future<ApiResultModel<String>> deleteExcelFile(File file);
}
