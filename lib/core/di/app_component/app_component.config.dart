// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:notsy/core/common_data/data_source/local/local/local_database.dart'
    as _i281;
import 'package:notsy/core/common_presentation/bottom_navigation/view/main_navigation_view_model.dart'
    as _i1072;
import 'package:notsy/core/di/app_component/app_module.dart' as _i489;
import 'package:notsy/core/utils/helper/extension_function/responsive_ui_helper/responsive_config.dart'
    as _i208;
import 'package:notsy/features/payment_management/data/data_source/local_database/category_local_datasource/category_local_datasource.dart'
    as _i324;
import 'package:notsy/features/payment_management/data/data_source/local_database/category_local_datasource/category_local_datasource_impl.dart'
    as _i317;
import 'package:notsy/features/payment_management/data/data_source/local_database/excel_management_local_datasource/excel_management_local_datasource.dart'
    as _i271;
import 'package:notsy/features/payment_management/data/data_source/local_database/excel_management_local_datasource/excel_management_local_datasource_impl.dart'
    as _i65;
import 'package:notsy/features/payment_management/data/data_source/local_database/Payment_local_datasource/payment_local_datasource.dart'
    as _i653;
import 'package:notsy/features/payment_management/data/data_source/local_database/Payment_local_datasource/payment_local_datasource_impl.dart'
    as _i167;
import 'package:notsy/features/payment_management/data/repositories/category_repository_impl.dart'
    as _i506;
import 'package:notsy/features/payment_management/data/repositories/excel_management_repository_impl.dart'
    as _i133;
import 'package:notsy/features/payment_management/data/repositories/payment_management_repository_impl.dart'
    as _i808;
import 'package:notsy/features/payment_management/domain/repositories/Category_management_repository/dart/category_repository.dart'
    as _i289;
import 'package:notsy/features/payment_management/domain/repositories/excel_management_repository/excel_management_repository.dart'
    as _i287;
import 'package:notsy/features/payment_management/domain/repositories/payment_management_repository/payment_repository.dart'
    as _i507;
import 'package:notsy/features/payment_management/domain/use_case/category_usecase/add_new_category.dart'
    as _i9;
import 'package:notsy/features/payment_management/domain/use_case/category_usecase/delete_category.dart'
    as _i98;
import 'package:notsy/features/payment_management/domain/use_case/category_usecase/get_all_category.dart'
    as _i72;
import 'package:notsy/features/payment_management/domain/use_case/category_usecase/get_category.dart'
    as _i881;
import 'package:notsy/features/payment_management/domain/use_case/category_usecase/update_category.dart'
    as _i343;
import 'package:notsy/features/payment_management/domain/use_case/excel_management_usecase/delete_excel_file.dart'
    as _i421;
import 'package:notsy/features/payment_management/domain/use_case/excel_management_usecase/get_all_excelFiles.dart'
    as _i525;
import 'package:notsy/features/payment_management/domain/use_case/excel_management_usecase/open_excel_file.dart'
    as _i731;
import 'package:notsy/features/payment_management/domain/use_case/excel_management_usecase/save_excel_file.dart'
    as _i829;
import 'package:notsy/features/payment_management/domain/use_case/payment_usecase/delete_payment.dart'
    as _i710;
import 'package:notsy/features/payment_management/domain/use_case/payment_usecase/filter_payment_info.dart'
    as _i543;
import 'package:notsy/features/payment_management/domain/use_case/payment_usecase/get_payment.dart'
    as _i645;
import 'package:notsy/features/payment_management/domain/use_case/payment_usecase/insert_payment.dart'
    as _i522;
import 'package:notsy/features/payment_management/domain/use_case/payment_usecase/update_payment.dart'
    as _i1061;
import 'package:notsy/features/payment_management/presentation/add_new_payment/add_new_payment_view_model.dart'
    as _i999;
import 'package:notsy/features/payment_management/presentation/home/payment_filter_view_model.dart'
    as _i637;
import 'package:notsy/features/payment_management/presentation/payment_report/payment_report_viewModel.dart'
    as _i332;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.factory<_i1072.MainNavigationViewModel>(
      () => _i1072.MainNavigationViewModel(),
    );
    await gh.factoryAsync<_i281.AppLocalDatabase>(
      () => appModule.prefs,
      preResolve: true,
    );
    gh.singleton<_i208.ResponsiveUiConfig>(() => _i208.ResponsiveUiConfig());
    gh.lazySingleton<_i271.ExcelManagementLocalDataSource>(
      () => _i65.ExcelManagementLocalDataSourceImpl(),
    );
    gh.lazySingleton<_i653.PaymentLocalDatasource>(
      () => _i167.PaymentLocalDataSourceImpl(db: gh<_i281.AppLocalDatabase>()),
    );
    gh.lazySingleton<_i324.CategoryLocalDatasource>(
      () => _i317.CategoryDataSourceImpl(db: gh<_i281.AppLocalDatabase>()),
    );
    gh.singleton<_i287.ExcelManagementRepository>(
      () => _i133.ExcelManagementRepositoryImpl(
        excelManagementLocalDataSource:
            gh<_i271.ExcelManagementLocalDataSource>(),
      ),
    );
    gh.factory<_i731.OpenExcelFile>(
      () => _i731.OpenExcelFile(
        excelManagementRepository: gh<_i287.ExcelManagementRepository>(),
      ),
    );
    gh.factory<_i421.DeleteExcelFile>(
      () => _i421.DeleteExcelFile(
        excelManagementRepository: gh<_i287.ExcelManagementRepository>(),
      ),
    );
    gh.factory<_i829.SaveExcelFile>(
      () => _i829.SaveExcelFile(
        excelManagementRepository: gh<_i287.ExcelManagementRepository>(),
      ),
    );
    gh.factory<_i525.GetAllExcelFiles>(
      () => _i525.GetAllExcelFiles(
        excelManagementRepository: gh<_i287.ExcelManagementRepository>(),
      ),
    );
    gh.singleton<_i289.CategoryRepository>(
      () => _i506.CategoryRepositoryImpl(
        localDataSource: gh<_i324.CategoryLocalDatasource>(),
      ),
    );
    gh.singleton<_i507.PaymentRepository>(
      () => _i808.PaymentRepositoryImpl(
        localDataSource: gh<_i653.PaymentLocalDatasource>(),
      ),
    );
    gh.factory<_i1061.UpdatePersonData>(
      () => _i1061.UpdatePersonData(gh<_i507.PaymentRepository>()),
    );
    gh.factory<_i645.GetPayment>(
      () => _i645.GetPayment(gh<_i507.PaymentRepository>()),
    );
    gh.factory<_i710.DeletePerson>(
      () => _i710.DeletePerson(gh<_i507.PaymentRepository>()),
    );
    gh.factory<_i522.AddNewPayment>(
      () => _i522.AddNewPayment(gh<_i507.PaymentRepository>()),
    );
    gh.factory<_i543.FilterPersonPayments>(
      () => _i543.FilterPersonPayments(gh<_i507.PaymentRepository>()),
    );
    gh.factory<_i98.DeleteCategory>(
      () => _i98.DeleteCategory(gh<_i289.CategoryRepository>()),
    );
    gh.factory<_i881.GetCategory>(
      () => _i881.GetCategory(gh<_i289.CategoryRepository>()),
    );
    gh.factory<_i343.UpdateCategory>(
      () => _i343.UpdateCategory(gh<_i289.CategoryRepository>()),
    );
    gh.factory<_i72.GetAllPaymentCategories>(
      () => _i72.GetAllPaymentCategories(gh<_i289.CategoryRepository>()),
    );
    gh.factory<_i9.AddNewCategory>(
      () => _i9.AddNewCategory(gh<_i289.CategoryRepository>()),
    );
    gh.factory<_i999.AddNewPaymentViewModel>(
      () => _i999.AddNewPaymentViewModel(
        gh<_i1061.UpdatePersonData>(),
        gh<_i522.AddNewPayment>(),
        gh<_i9.AddNewCategory>(),
        gh<_i645.GetPayment>(),
        gh<_i72.GetAllPaymentCategories>(),
        gh<_i710.DeletePerson>(),
      ),
    );
    gh.factory<_i332.PaymentReportViewModel>(
      () => _i332.PaymentReportViewModel(
        gh<_i543.FilterPersonPayments>(),
        gh<_i72.GetAllPaymentCategories>(),
        gh<_i829.SaveExcelFile>(),
        gh<_i525.GetAllExcelFiles>(),
        gh<_i731.OpenExcelFile>(),
        gh<_i421.DeleteExcelFile>(),
      ),
    );
    gh.factory<_i637.HomePaymentFilterViewModel>(
      () => _i637.HomePaymentFilterViewModel(
        filter: gh<_i543.FilterPersonPayments>(),
        getAllPaymentCategories: gh<_i72.GetAllPaymentCategories>(),
      ),
    );
    return this;
  }
}

class _$AppModule extends _i489.AppModule {}
