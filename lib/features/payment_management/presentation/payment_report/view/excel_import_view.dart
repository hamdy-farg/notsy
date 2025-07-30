import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notsy/core/common_presentation/bottom_navigation/wigets/responsive_text_widget.dart';
import 'package:notsy/core/utils/helper/extension_function/size_extension.dart';

import '../../../../../core/baseComponents/base_view_model_view.dart';
import '../../../../../core/common_presentation/bottom_navigation/wigets/custom_snackBarWidget.dart';
import '../../../../../core/common_presentation/bottom_navigation/wigets/show_delete_confirmation_dialog.dart';
import '../../../../../core/commondomain/entities/based_api_result_models/api_result_model.dart';
import '../../../../../l10n/app_localizations.dart';
import '../payment_report_viewModel.dart';

class ExcelImportView extends StatefulWidget {
  const ExcelImportView({super.key});

  @override
  State<ExcelImportView> createState() => _ExcelImportViewState();
}

class _ExcelImportViewState extends State<ExcelImportView> {
  PaymentReportViewModel? _provider;
  List<FileSystemEntity> _system_list = [];
  Future<void> _getAllSheets() async {
    ApiResultModel<List<FileSystemEntity>>? result = await _provider
        ?.getAllExcelSheets();
    // log("result ${result}");
    if (result is Success<List<FileSystemEntity>>) {
      _system_list.clear();
      _system_list = result.data;
    } else {
      showAppSnack(
        context,
        "there is error please try again",
        fromTop: true,
        isError: true,
        icon: Icons.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return BaseViewModelView<PaymentReportViewModel>(
      onInitState: (PaymentReportViewModel provider) {
        _provider = provider;
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await Future.delayed(Duration(milliseconds: 100));
          _getAllSheets();
        });
      },
      buildWidget: (provider) {
        return Scaffold(
          appBar: AppBar(
            title: Text('${t?.exportedFiles}'),
            actions: [
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  _getAllSheets();
                },
              ),
            ],
          ),
          body: ListView.builder(
            itemCount: _system_list.length,
            itemBuilder: (context, index) {
              final filePath = _system_list[index].path;
              final fileName = filePath.split('/').last;
              // log("sysetm  $_system_list");
              return GestureDetector(
                onTap: () {
                  _provider?.openExcelSheet(File(_system_list[index].path));
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 16.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: .1,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 12.w,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.file_open_outlined,
                          color: Color(0xff045506),
                          size: 25,
                        ),
                      ),

                      SizedBox(width: 16),
                      ResponsiveTextWidget(text: fileName),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDeleteConfirmationDialog(
                            onConfirm: () async {
                              await _provider?.deleteExcelSheet(
                                excelFile: File(_system_list[index].path),
                              );
                              _getAllSheets();
                            },
                            context: context,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
