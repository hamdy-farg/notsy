import 'package:injectable/injectable.dart';

import '../../../../../core/commondomain/entities/based_api_result_models/api_result_model.dart';
import '../../../../../core/commondomain/usecase/base_param_usecase.dart';
import '../../entities/person_entity/dart/person_Entity.dart';
import '../../repositories/payment_management_repository/payment_repository.dart';

@injectable
class UpdatePersonData extends BaseParamsUseCase<bool, PersonEntity> {
  UpdatePersonData(this.repository);
  final PaymentRepository repository;
  @override
  Future<ApiResultModel<bool>> call(person) async {
    // TODO: implement call
    return repository.updatePersonData(person: person);
  }
}
