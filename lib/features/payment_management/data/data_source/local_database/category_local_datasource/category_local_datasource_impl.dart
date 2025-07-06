import 'package:injectable/injectable.dart';
import 'package:notsy/core/commondomain/entities/based_api_result_models/api_result_model.dart';
import 'package:notsy/core/commondomain/entities/based_api_result_models/error_result_model.dart';
import 'package:notsy/features/payment_management/data/data_source/local_database/category_local_datasource/category_local_datasource.dart';
import 'package:notsy/features/payment_management/data/data_source/local_database/local_database.dart';
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
      final result = db
          .getAll<CategoryLocalModel>()
          ?.map((e) => e.mapToEntity())
          .toSet();

      ApiResultModel<List<CategoryEntity>> _result = ApiResultModel.success(
        data: result!.toList(),
      );
      return _result;
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
          categoryEntity.original_color_value != null) {
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
          categoryEntity.original_color_value != null ||
          categoryEntity.quantity == null ||
          categoryEntity.amount_paid == null ||
          categoryEntity.id == null) {
        throw Exception("you Enter un completed data");
      }
      if (categoryEntity.amount_paid == categoryEntity.cost) {
        categoryEntity.category_status = CategoryStatus.paid;
        categoryEntity.color_value = null;
      } else if (categoryEntity.amount_paid! < categoryEntity.cost! &&
          categoryEntity.amount_paid! > 0) {
        categoryEntity.category_status = CategoryStatus.underpaid;
        categoryEntity.color_value = "C2410C"; // yellow color
      } else if (categoryEntity.amount_paid! == 0) {
        categoryEntity.category_status = CategoryStatus.unpaid;
        categoryEntity.color_value = "EF4444";
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
