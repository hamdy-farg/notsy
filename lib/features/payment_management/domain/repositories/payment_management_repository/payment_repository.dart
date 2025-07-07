import 'package:notsy/features/payment_management/domain/entities/payment_entities/payment_info_entity.dart';

import '../../../../../core/commondomain/entities/based_api_result_models/api_result_model.dart';
import '../../use_case/payment_usecase/filter_payment_info.dart';

abstract class PaymentRepository {
  ApiResultModel<PaymentInfoEntity> getPayment({required int id});

  ApiResultModel<List<PaymentInfoEntity>> filterPaymentInfo({
    required FilterPaymentParamsEntity filters,
  });

  ApiResultModel<bool> updatePayment({
    required PaymentInfoEntity paymentInfoEntity,
  });

  ApiResultModel<bool> deletePayment({required int id});
  ApiResultModel<List<PaymentInfoEntity>> getAllPayment();

  ApiResultModel<int> addNewPayment({
    required PaymentInfoEntity paymentInfoEntity,
  });
}
