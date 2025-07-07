import 'package:injectable/injectable.dart';
import 'package:notsy/core/commondomain/entities/based_api_result_models/api_result_model.dart';
import 'package:notsy/features/payment_management/domain/entities/payment_entities/payment_info_entity.dart';
import 'package:notsy/features/payment_management/domain/repositories/payment_management_repository/payment_repository.dart';

import '../../domain/use_case/payment_usecase/filter_payment_info.dart';
import '../data_source/local_database/Payment_local_datasource/payment_local_datasource.dart';

@Singleton(as: PaymentRepository)
class PaymentRepositoryImpl implements PaymentRepository {
  PaymentLocalDatasource localDataSource;
  PaymentRepositoryImpl({required this.localDataSource});

  @override
  ApiResultModel<bool> deletePayment({required int id}) {
    return localDataSource.deletePaymentInfo(paymentId: id);
  }

  @override
  ApiResultModel<List<PaymentInfoEntity>> filterPaymentInfo({
    required FilterPaymentParamsEntity filters,
  }) {
    return localDataSource.filterPaymentInfo(
      input: filters.input,
      categoryNames: filters.categoryList,
      page: filters.page,
      to: filters.to,
      from: filters.from,
    );
  }

  @override
  ApiResultModel<PaymentInfoEntity> getPayment({required int id}) {
    return localDataSource.getPaymentInfo(paymentId: id);
  }

  @override
  ApiResultModel<bool> updatePayment({
    required PaymentInfoEntity paymentInfoEntity,
  }) {
    return localDataSource.updatePaymentInfo(
      paymentInfoEntity: paymentInfoEntity,
    );
  }

  @override
  ApiResultModel<int> addNewPayment({
    required PaymentInfoEntity paymentInfoEntity,
  }) {
    return localDataSource.savePaymentInfo(
      paymentInfoEntity: paymentInfoEntity,
    );
  }

  @override
  ApiResultModel<List<PaymentInfoEntity>> getAllPayment() {
    return localDataSource.getAllPaymentsInfo();
  }
}

//
// getAllPayments
// getFilteredPayment categoy_list to from
