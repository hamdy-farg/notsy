import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:notsy/core/commondomain/usecase/base_param_usecase.dart';
import 'package:notsy/features/payment_management/domain/entities/payment_entities/export_to_excel_entity.dart';
import 'package:notsy/features/payment_management/domain/repositories/excel_management_repository/excel_management_repository.dart';

import '../../../../../core/commondomain/entities/based_api_result_models/api_result_model.dart';

@injectable
class SaveExcelFile extends BaseParamsUseCase<File, ExportToExcelEntity> {
  final ExcelManagementRepository excelManagementRepository;
  SaveExcelFile({required this.excelManagementRepository});

  @override
  Future<ApiResultModel<File>> call(ExportToExcelEntity params) async {
    return await excelManagementRepository.saveExcelFile(
      personList: params.personList,
      selectedCategoryName: params.selectedCategoryName,
      fileName: params.fileName,
    );
  }
}
