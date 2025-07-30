import 'package:injectable/injectable.dart' as inject;
import 'package:notsy/core/common_data/data_source/local/local/local_database.dart';
import 'package:notsy/core/commondomain/entities/based_api_result_models/api_result_model.dart';
import 'package:notsy/core/commondomain/entities/based_api_result_models/error_result_model.dart';
import 'package:notsy/features/payment_management/data/data_source/local_database/Payment_local_datasource/payment_local_datasource.dart';
import 'package:notsy/features/payment_management/data/models/payment_local_models/payment_local_info_model.dart';
import 'package:notsy/features/payment_management/domain/entities/payment_entities/category_entity.dart';
import 'package:notsy/features/payment_management/domain/entities/payment_entities/payment_info_entity.dart';
import 'package:notsy/objectbox.g.dart';

import '../../../../domain/entities/person_entity/dart/person_Entity.dart';
import '../../../models/payment_local_models/category_local_model.dart';
import '../../../models/payment_local_models/person_local_model.dart';

@inject.LazySingleton(as: PaymentLocalDatasource)
class PaymentLocalDataSourceImpl implements PaymentLocalDatasource {
  final AppLocalDatabase db;

  PaymentLocalDataSourceImpl({required this.db});

  @override
  ApiResultModel<bool> deletePerson({required int personId}) {
    try {
      final personBox = db.getBox<PersonLocalModel>()!;
      final paymentBox = db.getBox<PaymentInfoLocalModel>()!;
      final categoryBox = db.getBox<CategoryLocalModel>()!;

      final person = personBox.get(personId);
      if (person == null) {
        return ApiResultModel.failure(
          message: ErrorResultModel(message: 'Person not found.'),
        );
      }

      // 🧹 Delete all their payments first
      final paymentIds = person.payments.map((p) => p.id).toList();
      if (paymentIds.isNotEmpty) {
        paymentBox.removeMany(paymentIds);
      }

      // ❌ Now delete the person
      final result = personBox.remove(personId);

      // 🧼 Clean up any categories that no longer have payments
      final allCategories = categoryBox.getAll();
      for (final category in allCategories) {
        if (category.payments.isEmpty) {
          categoryBox.remove(category.id);
        }
      }

      return ApiResultModel.success(data: result);
    } catch (e) {
      return ApiResultModel.failure(
        message: ErrorResultModel(message: e.toString()),
      );
    }
  }

  @override
  ApiResultModel<List<PersonEntity>> filterPersonPayments({
    String? input,
    List<String>? categoryNames,
    int? page,
    DateTime? from,
    DateTime? to,
  }) {
    // final res = db.getAll<CategoryLocalModel>();
    // for (final category in res!) {
    //   db.delete(category.id);
    // }
    // db.deleteDatabase();
    try {
      // deletePaymentInfo(paymentId: 1);

      // for (int i = 0; i < 1000; i++) {
      //   savePaymentInfo(
      //     paymentInfoEntity: PaymentInfoEntity(
      //       name: "hamdy$i",
      //       phone_number: "$i$i$i$i$i$i$i$i",
      //       date: DateTime.now(),
      //       payment_method: PaymentMethodEnum.cash,
      //       description: "description$i",
      //       category_list: [
      //         CategoryEntity(
      //           name: "category",
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
      //     Set<int>? allowedPaymentIds;
      //
      //     final _paymentBox = db.getBox<PaymentInfoLocalModel>();
      //     final _categoryBox = db.getBox<CategoryLocalModel>();
      //     QueryBuilder<PaymentInfoLocalModel> builder;
      //
      //     if (categoryNames != null && categoryNames.isNotEmpty) {
      //       var matchCategories;
      //       if (categoryNames.contains('All')) {
      //         // If "all" is selected, fetch all categories
      //         matchCategories = _categoryBox!.getAll();
      //       } else {
      //         // Otherwise, fetch only the matching categories
      //         matchCategories = _categoryBox!
      //             .query(CategoryLocalModel_.name.oneOf(categoryNames))
      //             .build()
      //             .find();
      //       }
      //
      //       allowedPaymentIds = {
      //         for (final category in matchCategories)
      //           for (final payment in category.paymentInfo)
      //             if (payment.id != 0) payment.id,
      //       };
      //       if (allowedPaymentIds.isEmpty)
      //         return ApiResultModel.success(data: []); // early exit
      //     }
      //     if (input != null) {
      //       final isNumber = int.tryParse(input ?? '') != null;
      //       if (isNumber) {
      //         builder = allowedPaymentIds != null
      //             ? _paymentBox!.query(
      //                 PaymentInfoLocalModel_.phone_number
      //                     .startsWith(input)
      //                     .or(PaymentInfoLocalModel_.phone_number.contains(input))
      //                     .and(
      //                       PaymentInfoLocalModel_.id.oneOf(
      //                         allowedPaymentIds.toList(),
      //                       ),
      //                     ),
      //               )
      //             : _paymentBox!.query(
      //                 PaymentInfoLocalModel_.phone_number.startsWith(input),
      //               );
      //       } else {
      //         builder = allowedPaymentIds != null
      //             ? _paymentBox!.query(
      //                 PaymentInfoLocalModel_.name
      //                     .startsWith(input, caseSensitive: false)
      //                     .or(PaymentInfoLocalModel_.phone_number.contains(input))
      //                     .and(
      //                       PaymentInfoLocalModel_.id.oneOf(
      //                         allowedPaymentIds.toList(),
      //                       ),
      //                     ),
      //               )
      //             : _paymentBox!.query(
      //                 PaymentInfoLocalModel_.name
      //                     .startsWith(input, caseSensitive: false)
      //                     .or(PaymentInfoLocalModel_.phone_number.contains(input)),
      //               );
      //       }
      //     } else if (allowedPaymentIds != null) {
      //       builder = _paymentBox!.query(
      //         PaymentInfoLocalModel_.id.oneOf(allowedPaymentIds.toList()),
      //       );
      //     } else {
      //       builder = _paymentBox!.query(PaymentInfoLocalModel_.id.notNull());
      //     }
      //     int pageSize = 10;
      //     // log("dididdid${db.getAll<PaymentInfoLocalModel>()!.length}");
      //
      //     final query = builder.build();
      //     if (from == null && to == null) {
      //       query
      //         ..limit = pageSize
      //         ..offset = (page ?? 0) * pageSize;
      //     }
      //
      //     final result = query.find();
      //
      //     List<PaymentInfoLocalModel> filtered = result;
      //
      //     if (from != null && to != null) {
      //       filtered = result.where((e) {
      //         final date = e.date;
      //         if (date == null) return false;
      //         return date.isAfter(from) && date.isBefore(to);
      //       }).toList();
      //     }
      //
      //     return ApiResultModel.success(
      //       data: filtered.map((e) => e.mapToEntity()).toList(),
      //     );
      //   } catch (e, stackTrace) {
      //   //
      //   return ApiResultModel.failure(
      //     message: ErrorResultModel(message: e.toString()),
      //   )
      // }
      // i need same logic but with new propersty nothing more
      Set<int>? allowedPersonIds = {};

      final _paymentBox = db.getBox<PaymentInfoLocalModel>();
      final _categoryBox = db.getBox<CategoryLocalModel>();
      final _personBox = db.getBox<PersonLocalModel>();

      QueryBuilder<PaymentInfoLocalModel> paymentBuilder;
      QueryBuilder<PersonLocalModel> personBuilder;

      if (categoryNames != null && categoryNames.isNotEmpty) {
        List<CategoryLocalModel> matchCategories;
        if (categoryNames.contains('All')) {
          // If "all" is selected, fetch all categories
          matchCategories = _categoryBox!.getAll();
        } else {
          // Otherwise, fetch only the matching categories
          matchCategories = _categoryBox!
              .query(CategoryLocalModel_.name.oneOf(categoryNames))
              .build()
              .find();
          // log("match${matchCategories}");
        }

        allowedPersonIds = {
          for (final category in matchCategories)
            for (final payment in category.payments)
              if (payment.id != 0) payment.person.targetId,
        };
        // log("alloweed $allowedPersonIds");
        if (allowedPersonIds.isEmpty)
          return ApiResultModel.success(data: []); // early exit
      }

      if (input != null && input.isNotEmpty) {
        final isNumber = int.tryParse(input ?? '') != null;
        final personQueryBuilder = _personBox?.query(
          isNumber
              ? PersonLocalModel_.phoneNumber
                    .startsWith(input, caseSensitive: false)
                    .or(PersonLocalModel_.phoneNumber.contains(input))
                    .and(PersonLocalModel_.id.oneOf(allowedPersonIds.toList()))
              : PersonLocalModel_.name
                    .startsWith(input, caseSensitive: false)
                    .or(PersonLocalModel_.name.contains(input))
                    .and(PersonLocalModel_.id.oneOf(allowedPersonIds.toList())),
        );
        final matchedPersons = personQueryBuilder?.build().find();
        allowedPersonIds.clear();
        for (final person in matchedPersons!) {
          for (final payment in person.payments) {
            if (payment.id != 0) allowedPersonIds.add(payment.person.targetId);
          }
        }

        if (allowedPersonIds.isEmpty) {
          return ApiResultModel.success(data: []);
        }

        // if (isNumber) {
        //   personBuilder = allowedPaymentIds != null
        //       ? _personBox!.query(
        //           PersonLocalModel_.phoneNumber
        //               .startsWith(input)
        //               .or(PersonLocalModel_.phoneNumber.contains(input))
        //               .and(
        //                 PersonLocalModel_.payments.oneOf(allowedPaymentIds.toList()),
        //               ),
        //         )
        //       : _personBox!.query(
        //           PersonLocalModel_.phoneNumber.startsWith(input),
        //         );
        //   personBuilder.build().find();
        //
        // } else {
        //   // builder =
        //   personBuilder = allowedPaymentIds != null
        //       ? _personBox!.query(
        //           PersonLocalModel_.name
        //               .startsWith(input, caseSensitive: false)
        //               .or(PersonLocalModel_.name.contains(input))
        //               .and(
        //                 PersonLocalModel_.id.oneOf(allowedPaymentIds.toList()),
        //               ),
        //         )
        //       : _personBox?.query(
        //           PersonLocalModel_.name
        //               .startsWith(input, caseSensitive: false)
        //               .or(PersonLocalModel_.name.contains(input)),
        //         );
        // }
      }
      // log("alloweed $allowedPersonIds");

      if (allowedPersonIds.isNotEmpty) {
        personBuilder = _personBox!.query(
          PersonLocalModel_.id.oneOf(allowedPersonIds.toList()),
        );
        // log("builder $personBuilder");

        //    paymentBuilder.build().find();
      } else {
        personBuilder = _personBox!.query(PersonLocalModel_.id.notNull());
      }
      personBuilder.order(
        PersonLocalModel_.latestUpdateAt,
        flags: Order.descending,
      );
      int pageSize = 20;

      final query = personBuilder.build();
      if (from == null && to == null) {
        query
          ..limit = pageSize
          ..offset = ((page ?? 0) - 1) * pageSize;
      }

      final result = query.find();
      // log("resss $result page $page");

      List<PersonLocalModel> filtered = result;

      if (from != null && to != null) {
        filtered = result.where((person) {
          return person.payments.any((payment) {
            final date = payment.date;
            if (date == null) return false;
            return !date.isBefore(from) && !date.isAfter(to);
          });
        }).toList();
      }
      // log("enter res ");

      final res = ApiResultModel.success(
        data: filtered.map((e) => e.mapToEntity()).toList(),
      );
      // log("end res ");

      return res;
    } catch (e, stackTrace) {
      //
      // log("errrrror $e $stackTrace");

      return ApiResultModel.failure(
        message: ErrorResultModel(message: e.toString()),
      );
    }
    // try {
    //   final _paymentBox = db.getBox<PaymentInfoLocalModel>()!;
    //   QueryBuilder<PaymentInfoLocalModel> builder;
    //
    //   builder = _paymentBox.query(PaymentInfoLocalModel_.id.notNull());
    //
    //   if (input != null && input.isNotEmpty) {
    //     builder = builder
    //         .link(PaymentInfoLocalModel_.person)
    //         .filter(
    //           (person) =>
    //               person.name?.toLowerCase().contains(input.toLowerCase()) ==
    //                   true ||
    //               person.phone_number?.contains(input) == true,
    //         );
    //   }
    //
    //   if (categoryNames != null && categoryNames.isNotEmpty) {
    //     builder = builder
    //         .link(PaymentInfoLocalModel_.category)
    //         .filter((cat) => categoryNames.contains(cat.name));
    //   }
    //
    //   final query = builder.build();
    //   List<PaymentInfoLocalModel> result = query.find();
    //
    //   if (from != null && to != null) {
    //     result = result.where((e) {
    //       final date = e.date;
    //       return date != null && date.isAfter(from) && date.isBefore(to);
    //     }).toList();
    //   }
    //
    //   final paged = result.skip((page ?? 0) * 10).take(10).toList();
    //   return ApiResultModel.success(
    //     data: paged.map((e) => e.mapToEntity()).toList(),
    //   );
    // } catch (e) {
    //   return ApiResultModel.failure(
    //     message: ErrorResultModel(message: e.toString()),
    //   );
    // }
  }

  @override
  ApiResultModel<List<CategoryEntity>> getAllPaymentCategory() {
    try {
      var result = db.getAll<CategoryLocalModel>();
      // log("$result");
      final result1 = result?.map((e) => e.mapToEntity()).toSet();

      ApiResultModel<List<CategoryEntity>> _result = ApiResultModel.success(
        data: result1!.toList(),
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
  ApiResultModel<List<int>> addPersonAndPayments({
    required List<PaymentInfoEntity> payments,
  }) {
    final personBox = db.getBox<PersonLocalModel>()!;
    final categoryBox = db.getBox<CategoryLocalModel>()!;
    final paymentBox = db.getBox<PaymentInfoLocalModel>()!;

    try {
      List<int> ids = [];

      // --- Person ---
      for (PaymentInfoEntity payment in payments) {
        PersonLocalModel personModel;
        // TODO!!!!!!!!!!!!!!!!
        final personQuery = personBox
            .query(
              PersonLocalModel_.name
                  .equals(payment.person?.name ?? '')
                  .and(
                    PersonLocalModel_.phoneNumber.equals(
                      payment.person?.phoneNumber ?? '',
                    ),
                  ),
            )
            .build();

        final foundPerson = personQuery.findFirst();
        personQuery.close();
        if (foundPerson != null) {
          personModel = foundPerson;
        } else {
          personModel = PersonLocalModel(
            name: payment.person?.name,
            phoneNumber: payment.person?.phoneNumber,
          );
          personModel.latestUpdateAt = DateTime.now();
          personModel.id = personBox.put(personModel);
        }

        // --- Category ---
        final categoryEntity = payment.category!;
        CategoryLocalModel categoryModel;
        final categoryQuery = categoryBox
            .query(CategoryLocalModel_.name.equals(categoryEntity.name ?? ''))
            .build();
        final foundCategory = categoryQuery.findFirst();
        categoryQuery.close();
        if (foundCategory != null) {
          categoryModel = foundCategory;
        } else {
          categoryModel = CategoryLocalModel.fromEntity(categoryEntity);
          categoryModel.id = categoryBox.put(categoryModel);
        }

        // --- Create Payment ---
        final paymentModel = PaymentInfoLocalModel.fromEntity(
          payment,
          personModel,
          categoryModel,
        );

        final id = paymentBox.put(paymentModel);
        ids.add(id);
        // --- prev ---
        // paymentInfoEntity.category_list = paymentInfoEntity.category_list!.map((
        //   e,
        // ) {
        //   if (paymentInfoEntity.category_list!.isEmpty ||
        //       paymentInfoEntity.category_list == null ||
        //       e.quantity == null ||
        //       e.quantity == 0 ||
        //       e.amount_paid == null) {
        //     throw Exception("you Enter un completed data");
        //   }
        //   if (e.amount_paid == 0) {
        //     e.category_status = CategoryStatus.unpaid;
        //     e.color_value = "EF4444"; // red color
        //     return e;
        //   } else if (e.amount_paid! < ((e.cost ?? 0) * (e.quantity ?? 0))) {
        //     e.category_status = CategoryStatus.underpaid;
        //     e.color_value = "C2410C"; // yellow color
        //     return e;
        //   }
        //   return e;
        // }).toList();

        // log("${paymentInfoEntity.category_list}");
        //
        // final result = db.insert<PaymentInfoLocalModel>(
        //   PaymentInfoLocalModel.fromEntity(
        //     paymentInfoEntity,
        //     db.getBox<CategoryLocalModel>(),
        //   ),
        // );
      }
      return ApiResultModel.success(data: ids ?? []);
    } catch (e, stackTrace) {
      return ApiResultModel.failure(
        message: ErrorResultModel(message: e.toString()),
      );
    }
  }

  @override
  ApiResultModel<bool> updatePersonData({required PersonEntity person}) {
    try {
      /* 1. Boxes */
      final personBox = db.getBox<PersonLocalModel>()!;
      final paymentBox = db.getBox<PaymentInfoLocalModel>()!;
      final categoryBox = db.getBox<CategoryLocalModel>()!;

      /* 2. Existing person */
      final personData = personBox.get(person.id ?? 0);
      if (personData == null) {
        return ApiResultModel.failure(
          message: ErrorResultModel(message: 'Person not found.'),
        );
      }
      personData
        ..name = person.name
        ..phoneNumber = person.phoneNumber;

      /* 3. Remove ALL old payments, whether or not they are still linked */
      final oldPaymentIds = paymentBox
          .query(PaymentInfoLocalModel_.person.equals(personData.id))
          .build()
          .findIds();
      if (oldPaymentIds.isNotEmpty) paymentBox.removeMany(oldPaymentIds);

      /* 3b. Clear link (now definitely empty) */
      personData.payments.clear();

      /* 4. Re-insert each incoming PaymentInfoEntity */
      for (final payEntity in person.payments ?? <PaymentInfoEntity>[]) {
        // 4a. Category
        final catEnt = payEntity.category;
        if (catEnt == null) {
          return ApiResultModel.failure(
            message: ErrorResultModel(message: 'Payment missing category.'),
          );
        }
        final catQuery = categoryBox
            .query(CategoryLocalModel_.name.equals(catEnt.name ?? ''))
            .build();
        CategoryLocalModel? catModel = catQuery.findFirst();
        catQuery.close();
        catModel ??= CategoryLocalModel.fromEntity(catEnt)
          ..id = categoryBox.put(CategoryLocalModel.fromEntity(catEnt));

        // 4b. Payment
        final payModel = PaymentInfoLocalModel.fromEntity(
          payEntity,
          personData,
          catModel,
        );
        _applyStatusAndColor(payModel);

        /* Link → put parent → put child */
        personData.payments.add(payModel);
        personData.latestUpdateAt = DateTime.now();
        personBox.put(personData); // persists link
        payModel.id = paymentBox.put(payModel);
      }
      /* 5. Clean up empty categories */
      for (final cat in categoryBox.getAll()) {
        if (cat.payments.isEmpty) categoryBox.remove(cat.id);
      }

      return const ApiResultModel.success(data: true);
    } catch (e) {
      return ApiResultModel.failure(
        message: ErrorResultModel(message: e.toString()),
      );
    }
  }

  /// Centralised rule so model & service stay in sync
  void _applyStatusAndColor(PaymentInfoLocalModel p) {
    final total = (p.category.target?.cost ?? 0) * (p.quantity ?? 0);
    final paid = p.amountPaid ?? 0;

    if (paid == 0) {
      p
        ..paymentStatus = PaymentStatusEnum.unpaid.name
        ..colorValue = 'EF4444'; // red
    } else if (paid < total) {
      p
        ..paymentStatus = PaymentStatusEnum.underpaid.name
        ..colorValue = 'C2 410C'; // yellow
    } else {
      p
        ..paymentStatus = PaymentStatusEnum.paid.name
        ..colorValue = null; // fully paid
    }
  }

  // @override
  // ApiResultModel<bool> updatePersonData({required PersonEntity person}) {
  //   // try {
  //   //   final payment = db.get<PaymentInfoLocalModel>(paymentInfoEntity.id!);
  //   //   if (payment == null) {
  //   //     return ApiResultModel.failure(
  //   //       message: ErrorResultModel(message: "Payment not found."),
  //   //     );
  //   //   }
  //   //   payment. = paymentInfoEntity.name;
  //   //   payment.phone_number = paymentInfoEntity.phone_number;
  //   //   payment.date = paymentInfoEntity.date;
  //   //   payment.payment_method = paymentInfoEntity.payment_method?.name ?? "cash";
  //   //   payment.description = paymentInfoEntity.description;
  //   //   payment.category_list.clear();
  //   //
  //   //   // Map and add updated categories
  //   //   for (final cat in paymentInfoEntity.category_list ?? []) {
  //   //     payment.category_list.add(CategoryLocalModel.fromEntity(cat));
  //   //   }
  //   //   final result = db.update<PaymentInfoLocalModel>(payment);
  //   //   return ApiResultModel.success(data: result);
  //   try {
  //     final paymentBox = db.getBox<PaymentInfoLocalModel>()!;
  //     final personBox = db.getBox<PersonLocalModel>()!;
  //     final categoryBox = db.getBox<CategoryLocalModel>()!;
  //
  //     final personData = personBox.get(person.id!);
  //     if (personData == null) {
  //       return ApiResultModel.failure(
  //         message: ErrorResultModel(message: "Payment not found."),
  //       );
  //     }
  //
  //     // --- Update Person ---
  //     PersonLocalModel personModel;
  //     final personQuery = personBox
  //         .query(
  //           PersonLocalModel_.name
  //               .equals(personData.name ?? '')
  //               .and(
  //                 PersonLocalModel_.phoneNumber.equals(
  //                   personData.phoneNumber ?? '',
  //                 ),
  //               ),
  //         )
  //         .build();
  //
  //     final existingPerson = personQuery.findFirst();
  //     personQuery.close();
  //
  //     if (existingPerson != null) {
  //       personModel = existingPerson;
  //     } else {
  //       personModel = PersonLocalModel(
  //         name: personData.name,
  //         phoneNumber: personData.phoneNumber,
  //       );
  //       personModel.id = personBox.put(personModel);
  //     }
  //
  //     // --- Update Category ---
  //     List<PaymentInfoEntity> payments = [];
  //     for (int index = 0; index < (person.payments?.length ?? 0); index++) {
  //       final categoryEntity = person.payments?[index].category;
  //       CategoryLocalModel categoryModel;
  //       final catQuery = categoryBox
  //           .query(CategoryLocalModel_.name.equals(categoryEntity?.name ?? ''))
  //           .build();
  //       final existingCategory = catQuery.findFirst();
  //       catQuery.close();
  //
  //       if (existingCategory != null) {
  //         categoryModel = existingCategory;
  //       } else if (categoryEntity != null) {
  //         categoryModel = CategoryLocalModel.fromEntity(categoryEntity);
  //         categoryModel.id = categoryBox.put(categoryModel);
  //       }
  //
  //       // --- Update Payment ---
  //
  //       personModel.payments[index].date = person.payments?[index].date;
  //       personModel.payments[index].paymentMethod =
  //           person.payments?[index].paymentMethodEnum?.name;
  //       personModel.payments[index].description =
  //           person.payments?[index].description;
  //       personModel.payments[index].amountPaid =
  //           person.payments?[index].amountPaid;
  //       personModel.payments[index].quantity = person.payments?[index].quantity;
  //
  //       final totalCost =
  //           ((person.payments?[index].category?.cost ?? 0) *
  //           (person.payments?[index].quantity ?? 0));
  //       final amountPaid = (person.payments?[index].amountPaid ?? 0);
  //
  //       if (amountPaid == totalCost) {
  //         personModel.payments[index].paymentStatus =
  //             PaymentStatusEnum.paid.name;
  //         personModel.payments[index].colorValue = null;
  //       } else if (amountPaid < totalCost && amountPaid > 0) {
  //         personModel.payments[index].paymentStatus =
  //             PaymentStatusEnum.underpaid.name;
  //         personModel.payments[index].colorValue = "C2410C"; // yellow color
  //       } else if (amountPaid == 0) {
  //         personModel.payments[index].paymentStatus =
  //             PaymentStatusEnum.unpaid.name;
  //         personModel.payments[index].colorValue = "EF4444";
  //       }
  //     }
  //     payments.target = personModel;
  //     category.target = categoryModel;
  //
  //     final result = paymentBox.put(payment);
  //     return ApiResultModel.success(data: result > 0);
  //   } catch (e, stackTrace) {
  //     return ApiResultModel.failure(
  //       message: ErrorResultModel(message: e.toString()),
  //     );
  //   }
  // }

  @override
  ApiResultModel<List<PaymentInfoEntity>> getAllPayments() {
    try {
      final result = db.getAll<PaymentInfoLocalModel>();

      return ApiResultModel.success(
        data: result!.map((e) => e.mapToEntity()).toList(),
      );
    } catch (e, stackTrace) {
      return ApiResultModel.failure(
        message: ErrorResultModel(message: e.toString()),
      );
    }
  }
}
