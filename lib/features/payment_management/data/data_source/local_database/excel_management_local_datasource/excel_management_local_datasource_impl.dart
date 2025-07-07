import 'dart:io';

import 'package:excel/excel.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:notsy/core/commondomain/entities/based_api_result_models/api_result_model.dart';
import 'package:notsy/core/commondomain/entities/based_api_result_models/error_result_model.dart';
import 'package:notsy/features/payment_management/data/data_source/local_database/excel_management_local_datasource/excel_management_local_datasource.dart';
import 'package:open_filex/open_filex.dart';

@LazySingleton(as: ExcelManagementLocalDataSource)
class ExcelManagementLocalDataSourceImpl
    implements ExcelManagementLocalDataSource {
  static String folderName = 'notsy_excel_data';

  Future<Directory> _getDirectory() async {
    final directory = Directory('/storage/emulated/0/Download/$folderName');
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return directory;
  }

  @override
  Future<ApiResultModel<String>> deleteExcelFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
        return ApiResultModel.success(data: "File deleted Successfully");
      } else {
        return ApiResultModel.failure(
          message: ErrorResultModel(message: "File not found"),
        );
      }
    } catch (e, stachtrace) {
      return ApiResultModel.failure(
        message: ErrorResultModel(message: e.toString()),
      );
    }
  }

  @override
  Future<ApiResultModel<List<FileSystemEntity>>> getAllExcelFiles() async {
    try {
      final directory = await _getDirectory();
      final files = directory
          .listSync()
          .where((file) => file is File && file.path.endsWith('.xlsx'))
          .toList();

      files.sort(
        (a, b) => b.statSync().modified.compareTo(a.statSync().modified),
      ); // newest first

      return ApiResultModel.success(data: files);
    } catch (e, stacktrace) {
      return ApiResultModel.failure(
        message: ErrorResultModel(message: e.toString()),
      );
    }
  }

  @override
  Future<ApiResultModel<String>> openExcelFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
        await OpenFilex.open(file.path);
        return ApiResultModel.success(data: "File deleted Successfully");
      } else {
        return ApiResultModel.failure(
          message: ErrorResultModel(message: "File does not exists"),
        );
      }
    } catch (e, stacktrace) {
      return ApiResultModel.failure(
        message: ErrorResultModel(message: e.toString()),
      );
    }
  }

  @override
  Future<ApiResultModel<File>> saveExcelFile(
    Excel excel,
    String baseFileName,
  ) async {
    try {
      final directory = await _getDirectory();
      final timestamp = DateFormat('yyyy-MM-dd_HHmmss').format(DateTime.now());
      final fullFileName = '$baseFileName\_$timestamp.xlsx';
      final filePath = '${directory.path}/$fullFileName';

      final file = File(filePath);
      await file.writeAsBytes(excel.encode()!);

      print('✅ Excel file saved: $filePath');
      return ApiResultModel.success(data: file);
    } catch (e, stacktrace) {
      return ApiResultModel.failure(
        message: ErrorResultModel(message: e.toString()),
      );
    }
  }
}
