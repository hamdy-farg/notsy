import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:notsy/core/commondomain/usecase/base_param_usecase.dart';
import 'package:notsy/features/payment_management/domain/repositories/excel_management_repository/excel_management_repository.dart';

import '../../../../../core/commondomain/entities/based_api_result_models/api_result_model.dart';

@injectable
class DeleteExcelFile extends BaseParamsUseCase<String, File> {
  final ExcelManagementRepository excelManagementRepository;
  DeleteExcelFile({required this.excelManagementRepository});

  @override
  Future<ApiResultModel<String>> call(file) async {
    return await excelManagementRepository.deleteExcelFile(file: file);
  }
}
