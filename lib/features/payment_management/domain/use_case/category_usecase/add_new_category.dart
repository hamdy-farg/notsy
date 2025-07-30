import 'package:injectable/injectable.dart';
import 'package:notsy/core/commondomain/entities/based_api_result_models/api_result_model.dart';
import 'package:notsy/core/commondomain/usecase/base_param_usecase.dart';
import 'package:notsy/features/payment_management/domain/entities/payment_entities/category_entity.dart';

import '../../repositories/Category_management_repository/dart/category_repository.dart';

@injectable
class AddNewCategory extends BaseParamsUseCase<int, CategoryEntity> {
  AddNewCategory(this.repository);
  final CategoryRepository repository;
  @override
  Future<ApiResultModel<int>> call(categoryEntity) async {
    return repository.addNewCategory(categoryEntity: categoryEntity);
  }
}
