import 'package:injectable/injectable.dart';
import 'package:notsy/core/commondomain/entities/based_api_result_models/api_result_model.dart';
import 'package:notsy/core/commondomain/usecase/base_param_usecase.dart';
import 'package:notsy/features/payment_management/domain/entities/payment_entities/payment_info_entity.dart';

import '../../repositories/payment_management_repository/payment_repository.dart';

@injectable
class AddNewPayment
    extends BaseParamsUseCase<List<int>, List<PaymentInfoEntity>> {
  AddNewPayment(this.repository);
  final PaymentRepository repository;
  @override
  Future<ApiResultModel<List<int>>> call(
    List<PaymentInfoEntity> payments,
  ) async {
    // TODO: implement call
    return repository.addNewPayment(payments: payments);
  }
}
