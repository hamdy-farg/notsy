import 'package:injectable/injectable.dart';
import 'package:notsy/core/commondomain/entities/based_api_result_models/api_result_model.dart';
import 'package:notsy/core/commondomain/usecase/base_param_usecase.dart';

import '../../repositories/payment_management_repository/payment_repository.dart';

@injectable
class DeletePayment extends BaseParamsUseCase<bool, int> {
  DeletePayment(this.repository);
  final PaymentRepository repository;
  @override
  ApiResultModel<bool> call(id) {
    return repository.deletePayment(id: id);
  }
}
