import 'dart:io';

import 'package:excel/excel.dart' as xl;
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:notsy/core/commondomain/entities/based_api_result_models/api_result_model.dart';
import 'package:notsy/core/commondomain/entities/based_api_result_models/error_result_model.dart';
import 'package:notsy/features/payment_management/data/data_source/local_database/excel_management_local_datasource/excel_management_local_datasource.dart';
import 'package:notsy/features/payment_management/domain/entities/payment_entities/payment_info_entity.dart';
import 'package:notsy/features/payment_management/domain/entities/person_entity/dart/person_Entity.dart';
import 'package:open_filex/open_filex.dart';

import '../../../../../../core/utils/helper/permission_helper/dart/permossion_helper.dart';

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
        await OpenFilex.open(file.path);
        return ApiResultModel.success(data: "File opened Successfully");
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

  Future<ApiResultModel<File>> saveExcelFile(
    List<String> selectedCategoryName,
    List<PersonEntity> personList,
    String fileName,
  ) async {
    // ① permission
    if (!await PermissionHelper.ensureStoragePermission()) {
      return ApiResultModel.failure(
        message: ErrorResultModel(message: 'Storage permission denied'),
      );
    }

    // ② heavy work in background
    final Uint8List excelBytes = await compute(_buildExcelIsolate, {
      'people': personList,
      'categories': selectedCategoryName,
    });

    try {
      // ③ path & name
      final directory = await _getDirectory(); // your helper
      final timestamp = DateFormat('MM-dd_HH').format(DateTime.now());
      final base = selectedCategoryName.join(',');
      final file_name = '${fileName}_category_${base}_time${timestamp}.xlsx';
      final filePath = '${directory.path}/$file_name';

      // ④ write
      final file = File(filePath);
      await file.writeAsBytes(excelBytes);

      return ApiResultModel.success(data: file);
    } catch (e) {
      return ApiResultModel.failure(
        message: ErrorResultModel(message: e.toString()),
      );
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 1️⃣  TOP-LEVEL isolate function
//    (must not access BuildContext, must import excel & models here)
Uint8List _buildExcelIsolate(Map<String, dynamic> args) {
  final List<PersonEntity> people = args['people'];
  final List<String> selected = List<String>.from(args['categories']);

  final excel = xl.Excel.createExcel();
  final defaultSheet = excel.getDefaultSheet();
  if (defaultSheet != null) excel.delete(defaultSheet);

  final sheet = excel[selected.join(',')];
  sheet.appendRow([
    'ID',
    'Name',
    'Phone Number',
    'Category',
    'Total Cost',
    'Amount Paid',
    'Remaining',
    'Payment Method',
    'Payment Date',
    'Notes',
  ]);

  int id = 0;
  for (final person in people) {
    for (PaymentInfoEntity payment in person.payments!) {
      if (selected.contains(payment.category?.name) ||
          selected.contains('All')) {
        final unitCost = payment.category?.cost ?? 0;
        final quantity = payment.quantity ?? 0;
        final paid = payment.amountPaid ?? 0;
        final total = unitCost * quantity;
        final remain = total - paid;

        id++;
        sheet.appendRow([
          id,
          person.name ?? '',
          person.phoneNumber ?? '',
          payment.category?.name ?? '',
          total.toStringAsFixed(2),
          paid.toStringAsFixed(2),
          remain.toStringAsFixed(2),
          payment.paymentMethodEnum?.name ?? '',
          payment.date?.toIso8601String() ?? '',
          payment.paymentStatusEnum?.name ?? '',
        ]);
      }
    }
  }

  return Uint8List.fromList(excel.encode()!); // ✅ fixed
}
