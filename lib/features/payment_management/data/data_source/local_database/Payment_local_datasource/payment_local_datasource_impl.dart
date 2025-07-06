import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:notsy/core/commondomain/entities/based_api_result_models/api_result_model.dart';
import 'package:notsy/core/commondomain/entities/based_api_result_models/error_result_model.dart';
import 'package:notsy/features/payment_management/data/data_source/local_database/Payment_local_datasource/payment_local_datasource.dart';
import 'package:notsy/features/payment_management/data/data_source/local_database/local_database.dart';
import 'package:notsy/features/payment_management/data/models/payment_local_models/payment_local_info_model.dart';
import 'package:notsy/features/payment_management/domain/entities/payment_entities/category_entity.dart';
import 'package:notsy/features/payment_management/domain/entities/payment_entities/payment_info_entity.dart';
import 'package:notsy/objectbox.g.dart';

import '../../../models/payment_local_models/category_local_model.dart';

@LazySingleton(as: PaymentLocalDatasource)
class PaymentLocalDataSourceImpl implements PaymentLocalDatasource {
  final AppLocalDatabase db;
  PaymentLocalDataSourceImpl({required this.db});

  @override
  ApiResultModel<bool> deletePaymentInfo({required int paymentId}) {
    try {
      // final all_payment = db.getAll<PaymentInfoLocalModel>();
      // for (final payment in all_payment!) {
      //   db.delete<PaymentInfoLocalModel>(payment.id);
      // }

      final result = db.delete<PaymentInfoLocalModel>(paymentId);
      final all_category = db.getAll<CategoryLocalModel>();

      for (final category in all_category!) {
        if (category.paymentInfo.isEmpty || category.paymentInfo == null) {
          db.delete<CategoryLocalModel>(category.id);
        }
      }
      return ApiResultModel.success(data: result);
    } catch (e, stackTrace) {
      return ApiResultModel.failure(
        message: ErrorResultModel(message: e.toString()),
      );
    }
  }

  @override
  ApiResultModel<List<PaymentInfoEntity>> filterPaymentInfo({
    String? input,
    List<String>? categoryNames,
    int? page,
  }) {
    try {
      // deletePaymentInfo(paymentId: 1);

      // for (int i in [0, 1, 2, 4, 5]) {
      //   savePaymentInfo(
      //     paymentInfoEntity: PaymentInfoEntity(
      //       name: "hamdy$i",
      //       phone_number: "$i$i$i$i$i$i$i$i",
      //       date: DateTime.now(),
      //       payment_method: PaymentMethodEnum.cash,
      //       description: "description$i",
      //       category_list: [
      //         CategoryEntity(
      //           name: "category$i",
      //           cost: 100,
      //           amount_paid: 12,
      //           color_value: "#EA580C",
      //           description: "description$i",
      //           quantity: 2,
      //         ),
      //       ],
      //     ),
      //   );
      // }
      Set<int>? allowedPaymentIds;
      final _paymentBox = db.getBox<PaymentInfoLocalModel>();
      final _categoryBox = db.getBox<CategoryLocalModel>();
      QueryBuilder<PaymentInfoLocalModel> builder;
      if (categoryNames != null && categoryNames.isNotEmpty) {
        var matchCategories;
        if (categoryNames.contains('All')) {
          // If "all" is selected, fetch all categories
          matchCategories = _categoryBox!.getAll();
        } else {
          // Otherwise, fetch only the matching categories
          matchCategories = _categoryBox!
              .query(CategoryLocalModel_.name.oneOf(categoryNames))
              .build()
              .find();
        }

        allowedPaymentIds = {
          for (final category in matchCategories)
            for (final payment in category.paymentInfo)
              if (payment.id != 0) payment.id,
        };
        if (allowedPaymentIds.isEmpty)
          return ApiResultModel.success(data: []); // early exit
      }
      if (input != null) {
        final isNumber = int.tryParse(input ?? '') != null;
        if (isNumber) {
          builder = allowedPaymentIds != null
              ? _paymentBox!.query(
                  PaymentInfoLocalModel_.phone_number
                      .startsWith(input)
                      .or(PaymentInfoLocalModel_.phone_number.contains(input))
                      .and(
                        PaymentInfoLocalModel_.id.oneOf(
                          allowedPaymentIds.toList(),
                        ),
                      ),
                )
              : _paymentBox!.query(
                  PaymentInfoLocalModel_.phone_number.startsWith(input),
                );
        } else {
          builder = allowedPaymentIds != null
              ? _paymentBox!.query(
                  PaymentInfoLocalModel_.name
                      .startsWith(input, caseSensitive: false)
                      .or(PaymentInfoLocalModel_.phone_number.contains(input))
                      .and(
                        PaymentInfoLocalModel_.id.oneOf(
                          allowedPaymentIds.toList(),
                        ),
                      ),
                )
              : _paymentBox!.query(
                  PaymentInfoLocalModel_.name
                      .startsWith(input, caseSensitive: false)
                      .or(PaymentInfoLocalModel_.phone_number.contains(input)),
                );
        }
      } else if (allowedPaymentIds != null) {
        builder = _paymentBox!.query(
          PaymentInfoLocalModel_.id.oneOf(allowedPaymentIds.toList()),
        );
      } else {
        builder = _paymentBox!.query(PaymentInfoLocalModel_.id.notNull());
      }
      int pageSize = 10;
      log("dididdid${db.getAll<PaymentInfoLocalModel>()!.length}");
      final query = builder.build()
        ..limit = pageSize
        ..offset = (page ?? 0) * pageSize;

      final result = query.find();

      return ApiResultModel.success(
        data: result.map((e) => e.mapToEntity()).toList(),
      );
    } catch (e, stackTrace) {
      //
      return ApiResultModel.failure(
        message: ErrorResultModel(message: e.toString()),
      );
    }
  }

  @override
  ApiResultModel<List<CategoryEntity>> getAllPaymentCategory() {
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
  ApiResultModel<PaymentInfoEntity> getPaymentInfo({required int paymentId}) {
    try {
      final result = db.get<PaymentInfoLocalModel>(paymentId)?.mapToEntity();
      return ApiResultModel.success(data: result!);
    } catch (e, stackTrace) {
      return ApiResultModel.failure(
        message: ErrorResultModel(message: e.toString()),
      );
    }
  }

  @override
  ApiResultModel<int> savePaymentInfo({
    required PaymentInfoEntity paymentInfoEntity,
  }) {
    try {
      paymentInfoEntity.category_list = paymentInfoEntity.category_list!.map((
        e,
      ) {
        if (paymentInfoEntity.category_list!.isEmpty ||
            paymentInfoEntity.category_list == null ||
            e.quantity == null ||
            e.quantity == 0 ||
            e.amount_paid == null) {
          throw Exception("you Enter un completed data");
        }
        if (e.amount_paid == 0) {
          e.category_status = CategoryStatus.unpaid;
          e.color_value = "EF4444"; // red color
          return e;
        } else if (e.amount_paid! < e.cost!) {
          e.category_status = CategoryStatus.underpaid;
          e.color_value = "C2410C"; // yellow color
          return e;
        }
        return e;
      }).toList();

      log("${paymentInfoEntity.category_list}");

      final result = db.insert<PaymentInfoLocalModel>(
        PaymentInfoLocalModel.fromEntity(paymentInfoEntity),
      );

      return ApiResultModel.success(data: result ?? 4);
    } catch (e, stackTrace) {
      return ApiResultModel.failure(
        message: ErrorResultModel(message: e.toString()),
      );
    }
  }

  @override
  ApiResultModel<bool> updatePaymentInfo({
    required PaymentInfoEntity paymentInfoEntity,
  }) {
    try {
      final result = db.update<PaymentInfoLocalModel>(
        PaymentInfoLocalModel.fromEntity(paymentInfoEntity),
      );
      return ApiResultModel.success(data: result);
    } catch (e, stackTrace) {
      return ApiResultModel.failure(
        message: ErrorResultModel(message: e.toString()),
      );
    }
  }
}
