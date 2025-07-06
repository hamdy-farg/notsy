import 'package:notsy/core/commondomain/entities/based_api_result_models/api_result_model.dart';
import 'package:notsy/features/payment_management/domain/entities/payment_entities/category_entity.dart';

abstract class CategoryLocalDatasource {
  ApiResultModel<CategoryEntity> getCategory({required int categoryId});
  ApiResultModel<List<CategoryEntity>> getAllCategory();

  ApiResultModel<bool> updateCategory({required CategoryEntity categoryEntity});
  ApiResultModel<bool> deleteCategory({required int categoryId});

  ApiResultModel<int> addNewCategory({required CategoryEntity categoryEntity});
}
