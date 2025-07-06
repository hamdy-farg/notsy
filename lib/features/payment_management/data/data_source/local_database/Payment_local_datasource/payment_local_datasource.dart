import 'package:notsy/core/commondomain/entities/based_api_result_models/api_result_model.dart';
import 'package:notsy/features/payment_management/domain/entities/payment_entities/category_entity.dart';
import 'package:notsy/features/payment_management/domain/entities/payment_entities/payment_info_entity.dart';

abstract class PaymentLocalDatasource {
  ApiResultModel<PaymentInfoEntity> getPaymentInfo({required int paymentId});
  ApiResultModel<List<CategoryEntity>> getAllPaymentCategory();

  ApiResultModel<List<PaymentInfoEntity>> filterPaymentInfo({
    String? input,
    List<String>? categoryNames,
    int? page,
  });

  ApiResultModel<bool> updatePaymentInfo({
    required PaymentInfoEntity paymentInfoEntity,
  });
  ApiResultModel<bool> deletePaymentInfo({required int paymentId});

  ApiResultModel<int> savePaymentInfo({
    required PaymentInfoEntity paymentInfoEntity,
  });
}
