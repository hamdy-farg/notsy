import 'package:notsy/features/payment_management/domain/entities/payment_entities/category_entity.dart';

import '../../../../../../core/commondomain/entities/based_api_result_models/api_result_model.dart';

abstract class CategoryRepository {
  ApiResultModel<int> addNewCategory({required CategoryEntity categoryEntity});
  ApiResultModel<bool> deleteCategory({required int id});

  ApiResultModel<bool> updateCategory({required CategoryEntity categoryEntity});
  ApiResultModel<CategoryEntity> getCategory({required int id});
  ApiResultModel<List<CategoryEntity>> getAllPaymentCategories();
}
