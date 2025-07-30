import 'package:notsy/core/commondomain/entities/based_api_result_models/api_result_model.dart';
import 'package:notsy/features/payment_management/domain/entities/payment_entities/category_entity.dart';
import 'package:notsy/features/payment_management/domain/entities/payment_entities/payment_info_entity.dart';
import 'package:notsy/features/payment_management/domain/entities/person_entity/dart/person_Entity.dart';

abstract class PaymentLocalDatasource {
  ApiResultModel<PaymentInfoEntity> getPaymentInfo({required int paymentId});
  ApiResultModel<List<CategoryEntity>> getAllPaymentCategory();
  ApiResultModel<List<PaymentInfoEntity>> getAllPayments();

  ApiResultModel<List<PersonEntity>> filterPersonPayments({
    String? input,
    List<String>? categoryNames,
    int? page,
    DateTime? to,
    DateTime? from,
  });

  ApiResultModel<bool> updatePersonData({required PersonEntity person});
  ApiResultModel<bool> deletePerson({required int personId});

  ApiResultModel<List<int>> addPersonAndPayments({
    required List<PaymentInfoEntity> payments,
  });
}
