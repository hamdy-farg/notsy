import 'package:injectable/injectable.dart';
import 'package:notsy/core/commondomain/entities/based_api_result_models/api_result_model.dart';
import 'package:notsy/core/commondomain/usecase/base_param_usecase.dart';

import '../../repositories/payment_management_repository/payment_repository.dart';

@injectable
class DeletePerson extends BaseParamsUseCase<bool, int> {
  DeletePerson(this.repository);
  final PaymentRepository repository;
  @override
  Future<ApiResultModel<bool>> call(id) async {
    return repository.deletePerson(id: id);
  }
}
