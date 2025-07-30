import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:notsy/core/commondomain/usecase/base_param_usecase.dart';
import 'package:notsy/features/payment_management/domain/repositories/excel_management_repository/excel_management_repository.dart';

import '../../../../../core/commondomain/entities/based_api_result_models/api_result_model.dart';

@injectable
class GetAllExcelFiles
    extends BaseParamsUseCase<List<FileSystemEntity>, NoParams> {
  final ExcelManagementRepository excelManagementRepository;
  GetAllExcelFiles({required this.excelManagementRepository});

  @override
  Future<ApiResultModel<List<FileSystemEntity>>> call(NoParams params) async {
    return await excelManagementRepository.getAllExcelFiles();
  }
}
