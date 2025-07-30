import 'package:injectable/injectable.dart';
import 'package:notsy/core/common_data/data_source/local/local/local_database.dart';
import 'package:notsy/core/commondomain/entities/based_api_result_models/api_result_model.dart';
import 'package:notsy/core/commondomain/entities/based_api_result_models/error_result_model.dart';
import 'package:notsy/features/payment_management/data/data_source/local_database/category_local_datasource/category_local_datasource.dart';
import 'package:notsy/features/payment_management/data/models/payment_local_models/payment_local_info_model.dart';
import 'package:notsy/features/payment_management/domain/entities/payment_entities/category_entity.dart';

import '../../../models/payment_local_models/category_local_model.dart';

@LazySingleton(as: CategoryLocalDatasource)
class CategoryDataSourceImpl implements CategoryLocalDatasource {
  final AppLocalDatabase db;
  CategoryDataSourceImpl({required this.db});

  @override
  ApiResultModel<bool> deleteCategory({required int categoryId}) {
    try {
      final result = db.delete<PaymentInfoLocalModel>(categoryId);
      return ApiResultModel.success(data: result);
    } catch (e, stackTrace) {
      return ApiResultModel.failure(
        message: ErrorResultModel(message: e.toString()),
      );
    }
  }

  @override
  ApiResultModel<List<CategoryEntity>> getAllCategory() {
    try {
      // Fetch all local models from the database
      final result = db.getAll<CategoryLocalModel>();
      // log("Raw result from DB: $result");
      // log("Raw result from DBlen: ${result?.length}");

      // Use a map to ensure uniqueness based on a unique field like 'name'
      final uniqueMap = <String, CategoryLocalModel>{};
      for (final e in result ?? []) {
        uniqueMap[e.name] = e; // or use e.id if it's the unique field
      }

      // Convert only the unique values to entities
      final uniqueEntities = uniqueMap.values
          .map((e) => e.mapToEntity())
          .toList();

      // Return success
      return ApiResultModel.success(data: uniqueEntities);
    } catch (e, stackTrace) {
      return ApiResultModel.failure(
        message: ErrorResultModel(message: e.toString()),
      );
    }
  }

  @override
  ApiResultModel<CategoryEntity> getCategory({required int categoryId}) {
    try {
      final result = db.get<CategoryLocalModel>(categoryId)?.mapToEntity();
      return ApiResultModel.success(data: result!);
    } catch (e, stackTrace) {
      return ApiResultModel.failure(
        message: ErrorResultModel(message: e.toString()),
      );
    }
  }

  @override
  ApiResultModel<int> addNewCategory({required CategoryEntity categoryEntity}) {
    try {
      if (categoryEntity.name != null ||
          categoryEntity.description != null ||
          categoryEntity.cost != null ||
          categoryEntity.originalColorValue != null) {
        final result = db.insert<CategoryLocalModel>(
          CategoryLocalModel.fromEntity(categoryEntity),
        );
        return ApiResultModel.success(data: result ?? 4);
      } else {
        throw Exception("you Enter un completed data");
      }
    } catch (e, stackTrace) {
      return ApiResultModel.failure(
        message: ErrorResultModel(message: e.toString()),
      );
    }
  }

  @override
  ApiResultModel<bool> updateCategory({
    required CategoryEntity categoryEntity,
  }) {
    try {
      if (categoryEntity.name == null ||
          categoryEntity.description == null ||
          categoryEntity.cost == null ||
          categoryEntity.originalColorValue != null ||
          categoryEntity.id == null) {
        throw Exception("you Enter un completed data");
      }
      final result = db.update<CategoryLocalModel>(
        CategoryLocalModel.fromEntity(categoryEntity),
      );
      return ApiResultModel.success(data: result);
    } catch (e, stackTrace) {
      return ApiResultModel.failure(
        message: ErrorResultModel(message: e.toString()),
      );
    }
  }
}
