import 'package:injectable/injectable.dart';
import 'package:notsy/core/commondomain/entities/based_api_result_models/api_result_model.dart';
import 'package:notsy/core/commondomain/usecase/base_param_usecase.dart';

import '../../repositories/Category_management_repository/dart/category_repository.dart';

@injectable
class DeleteCategory extends BaseParamsUseCase<bool, int> {
  DeleteCategory(this.repository);
  final CategoryRepository repository;
  @override
  ApiResultModel<bool> call(id) {
    // TODO: implement call
    return repository.deleteCategory(id: id);
  }
}
