import 'package:injectable/injectable.dart';

import '../../../../../core/commondomain/entities/based_api_result_models/api_result_model.dart';
import '../../../../../core/commondomain/usecase/base_param_usecase.dart';
import '../../entities/payment_entities/payment_info_entity.dart';
import '../../repositories/payment_management_repository/payment_repository.dart';

@injectable
class UpdatePayment extends BaseParamsUseCase<bool, PaymentInfoEntity> {
  UpdatePayment(this.repository);
  final PaymentRepository repository;
  @override
  ApiResultModel<bool> call(payment) {
    // TODO: implement call
    return repository.updatePayment(paymentInfoEntity: payment);
  }
}
