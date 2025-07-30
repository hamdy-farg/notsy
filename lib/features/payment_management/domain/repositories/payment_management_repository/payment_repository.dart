import 'package:notsy/features/payment_management/domain/entities/payment_entities/payment_info_entity.dart';
import 'package:notsy/features/payment_management/domain/entities/person_entity/dart/person_Entity.dart';

import '../../../../../core/commondomain/entities/based_api_result_models/api_result_model.dart';
import '../../use_case/payment_usecase/filter_payment_info.dart';

abstract class PaymentRepository {
  ApiResultModel<PaymentInfoEntity> getPayment({required int id});

  ApiResultModel<List<PersonEntity>> filterPersonPayments({
    required FilterPaymentParamsEntity filters,
  });

  ApiResultModel<bool> updatePersonData({required PersonEntity person});

  ApiResultModel<bool> deletePerson({required int id});
  ApiResultModel<List<PaymentInfoEntity>> getAllPayment();

  ApiResultModel<List<int>> addNewPayment({
    required List<PaymentInfoEntity> payments,
  });
}
