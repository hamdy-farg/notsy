import 'package:excel/excel.dart';

class ExportToExcelEntity {
  final String baseFileName;
  final Excel excelFile; // structured rows of data

  const ExportToExcelEntity({
    required this.baseFileName,
    required this.excelFile,
  });
}
