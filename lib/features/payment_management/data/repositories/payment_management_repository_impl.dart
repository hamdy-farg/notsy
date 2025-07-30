import 'package:injectable/injectable.dart';
import 'package:notsy/core/commondomain/entities/based_api_result_models/api_result_model.dart';
import 'package:notsy/features/payment_management/domain/entities/payment_entities/payment_info_entity.dart';
import 'package:notsy/features/payment_management/domain/entities/person_entity/dart/person_Entity.dart';
import 'package:notsy/features/payment_management/domain/repositories/payment_management_repository/payment_repository.dart';

import '../../domain/use_case/payment_usecase/filter_payment_info.dart';
import '../data_source/local_database/Payment_local_datasource/payment_local_datasource.dart';

@Singleton(as: PaymentRepository)
class PaymentRepositoryImpl implements PaymentRepository {
  PaymentLocalDatasource localDataSource;
  PaymentRepositoryImpl({required this.localDataSource});

  @override
  ApiResultModel<bool> deletePerson({required int id}) {
    return localDataSource.deletePerson(personId: id);
  }

  @override
  ApiResultModel<List<PersonEntity>> filterPersonPayments({
    required FilterPaymentParamsEntity filters,
  }) {
    return localDataSource.filterPersonPayments(
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
  ApiResultModel<bool> updatePersonData({required PersonEntity person}) {
    return localDataSource.updatePersonData(person: person);
  }

  @override
  ApiResultModel<List<int>> addNewPayment({
    required List<PaymentInfoEntity> payments,
  }) {
    return localDataSource.addPersonAndPayments(payments: payments);
  }

  @override
  ApiResultModel<List<PaymentInfoEntity>> getAllPayment() {
    return localDataSource.getAllPayments();
  }
}

//
// getAllPayments
// getFilteredPayment categoy_list to from
