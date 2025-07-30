import 'package:injectable/injectable.dart';
import 'package:notsy/core/commondomain/entities/based_api_result_models/api_result_model.dart';
import 'package:notsy/features/payment_management/data/data_source/local_database/category_local_datasource/category_local_datasource.dart';
import 'package:notsy/features/payment_management/domain/entities/payment_entities/category_entity.dart';
import 'package:notsy/features/payment_management/domain/entities/payment_entities/payment_info_entity.dart';

import '../../domain/repositories/Category_management_repository/dart/category_repository.dart';

@Singleton(as: CategoryRepository)
class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryLocalDatasource localDataSource;
  CategoryRepositoryImpl({required this.localDataSource});

  @override
  ApiResultModel<int> addNewCategory({required CategoryEntity categoryEntity}) {
    return localDataSource.addNewCategory(categoryEntity: categoryEntity);
  }

  @override
  ApiResultModel<bool> deleteCategory({required int id}) {
    return localDataSource.deleteCategory(categoryId: id);
  }

  @override
  ApiResultModel<List<CategoryEntity>> getAllPaymentCategories() {
    return localDataSource.getAllCategory();
  }

  @override
  ApiResultModel<CategoryEntity> getCategory({required int id}) {
    return localDataSource.getCategory(categoryId: id);
  }

  @override
  ApiResultModel<bool> updateCategory({
    required CategoryEntity categoryEntity,
  }) {
    return localDataSource.updateCategory(categoryEntity: categoryEntity);
  }
}
