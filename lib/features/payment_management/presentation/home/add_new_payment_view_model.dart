import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:notsy/core/baseComponents/base_view_model.dart';
import 'package:notsy/core/commondomain/entities/based_api_result_models/api_result_model.dart';
import 'package:notsy/core/commondomain/entities/based_api_result_models/error_result_model.dart';
import 'package:notsy/core/commondomain/usecase/base_param_usecase.dart';
import 'package:notsy/features/payment_management/domain/entities/payment_entities/category_entity.dart';
import 'package:notsy/features/payment_management/domain/entities/payment_entities/payment_info_entity.dart';
import 'package:notsy/features/payment_management/domain/use_case/category_usecase/add_new_category.dart';
import 'package:notsy/features/payment_management/domain/use_case/category_usecase/get_all_category.dart';
import 'package:notsy/features/payment_management/domain/use_case/payment_usecase/get_payment.dart';
import 'package:notsy/features/payment_management/domain/use_case/payment_usecase/update_payment.dart';

import '../../domain/use_case/payment_usecase/insert_payment.dart';

@injectable
class AddNewPaymentViewModel extends BaseViewModel {
  final UpdatePayment updatePayment;
  final AddNewPayment addNewPayment;
  final GetAllPaymentCategories getAllPaymentCategories;
  final AddNewCategory addNewCategory;
  final GetPayment getPaymentInfo;

  AddNewPaymentViewModel({
    required this.updatePayment,
    required this.addNewPayment,
    required this.addNewCategory,
    required this.getPaymentInfo,
    required this.getAllPaymentCategories,
  });
  void addCategoryField() {
    quantityControllerList.add(TextEditingController());
    amountPaidControllerList.add(TextEditingController());
    categoryEntityList.add(CategoryEntity());
    log("len${categoryEntityList.length}");
    if (categoryEntityList.length != 1) {
      notifyListeners();
    }
  }

  double getTotalAmountPaid() {
    double total = 0;

    for (CategoryEntity i in categoryEntityList) {
      if (i.amount_paid == null) {
        continue;
      }
      total += i.amount_paid!;
    }
    return total;
  }

  double getTotalCost() {
    double total = 0;

    for (CategoryEntity i in categoryEntityList) {
      if (i.cost == null || i.quantity == null) {
        continue;
      }
      total += i.cost! * i.quantity!;
    }

    return total;
  }

  double getTotalRemaining() {
    double total = 0;

    for (CategoryEntity i in categoryEntityList) {
      if (i.cost == null || i.quantity == null || i.amount_paid == null) {
        continue;
      }
      total += ((i.cost! * i.quantity!) - i.amount_paid!);
    }
    return total;
  }

  void removeCategoryField({required int index}) {
    if (categoryEntityList.length == 1) {
    } else {
      quantityControllerList.removeAt(index);
      amountPaidControllerList.removeAt(index);
      categoryEntityList.removeAt(index);
      log("len${categoryEntityList.length}");
      notifyListeners();
    }
  }

  //
  List<TextEditingController> quantityControllerList = [];
  List<TextEditingController> amountPaidControllerList = [];
  List<CategoryEntity> categoryEntityList = [];
  //
  String? originalColorValue = "";

  //
  TextEditingController newCategoryDescriptionController =
      TextEditingController();
  TextEditingController newCategoryCostController = TextEditingController();
  TextEditingController newCategoryNameController = TextEditingController();

  //
  TextEditingController nameController = TextEditingController();
  //
  TextEditingController phoneNumberController = TextEditingController();
  //
  PaymentMethodEnum paymentMethodEnum = PaymentMethodEnum.cash;
  //
  DateTime dateTime = DateTime.now();
  //
  CategoryEntity? newCategoryEntity = null;
  //
  List<CategoryEntity> fitchedCategoryList = [];
  //

  //
  void setCategoryName({required int index, required String name}) {
    categoryEntityList[index].name = name;
    notifyListeners();
  }

  void setQuantity(int index, String value) {
    categoryEntityList[index].quantity = double.tryParse(value);
    notifyListeners();
  }

  void setAmountPaid(int index, String value) {
    categoryEntityList[index].amount_paid = double.tryParse(value);
    notifyListeners();
  }

  //
  setNewCategoryEntity({
    required int index,
    required String? name,
    required String? description,
    required String? original_color_value,
    required double? cost,
  }) {
    categoryEntityList[index].name = name;
    categoryEntityList[index].description = description;
    categoryEntityList[index].original_color_value = original_color_value;
    categoryEntityList[index].cost = cost;
    notifyListeners();
  }

  //
  void setDateTime(DateTime date) {
    dateTime = date;
    notifyListeners();
  }

  void setOriginalColorValue(String? value) {
    originalColorValue = value;
    notifyListeners();
  }

  void setNewCategoryCost(String? value) {
    newCategoryCostController.text;
    notifyListeners();
  }

  void setNewCategoryDescription(String? value) {
    newCategoryDescriptionController.text;
    notifyListeners();
  }

  void setNewCategoryName(String? value) {
    newCategoryDescriptionController.text;
    notifyListeners();
  }

  void setName(String value) {
    nameController.text = value;
    notifyListeners();
  }

  void setPhoneNumber(String value) {
    phoneNumberController.text = value;
    notifyListeners();
  }

  void setPaymentMethod(PaymentMethodEnum method) {
    paymentMethodEnum = method;
    notifyListeners();
  }

  // void setCategoryList(List<CategoryEntity> list) {
  //   categoryList = list;
  //   notifyListeners();
  // }

  //

  //
  Future<ApiResultModel<int>> addPayment() async {
    if (nameController.text.isEmpty ||
        phoneNumberController.text.isEmpty ||
        dateTime.toString().isEmpty ||
        categoryEntityList.isEmpty ||
        paymentMethodEnum.toString().isEmpty) {
      return ApiResultModel.failure(
        message: ErrorResultModel(
          message: "you add Uncompleted data in new category",
        ),
      );
    }
    for (CategoryEntity i in categoryEntityList) {
      if (i.name == null ||
          i.amount_paid == null ||
          i.quantity == null ||
          i.cost == null) {
        return ApiResultModel.failure(
          message: ErrorResultModel(
            message: "you add Uncompleted data in new category",
          ),
        );
      } else if (i.name!.isEmpty ||
          i.amount_paid.toString().isEmpty ||
          i.quantity.toString().isEmpty ||
          i.cost.toString().isEmpty) {
        return ApiResultModel.failure(
          message: ErrorResultModel(
            message: "you add Uncompleted data in new category",
          ),
        );
      }
    }
    final result = await executeParamsUseCase(
      useCase: addNewPayment,
      query: PaymentInfoEntity(
        name: nameController.text,
        phone_number: phoneNumberController.text,
        payment_method: paymentMethodEnum,
        date: dateTime,
        category_list: categoryEntityList,
      ),
    );

    return result!;
  }

  //
  Future<ApiResultModel<List<CategoryEntity>>> getAllCategory() async {
    final result = await executeParamsUseCase(
      useCase: getAllPaymentCategories,
      query: NoParams(),
    );
    if (result is Success<List<CategoryEntity>>) {
      fitchedCategoryList = result.data;
    }
    notifyListeners();
    return result!;
  }
  //

  //
  addNewCategoryField() {
    newCategoryEntity = CategoryEntity();
    notifyListeners();
  }

  removeNewCategoryField() {
    newCategoryCostController.text = "";
    newCategoryNameController.text = "";
    newCategoryDescriptionController.text = "";
    originalColorValue = "";
    newCategoryEntity = null;
    notifyListeners();
  }

  ////////////////////////
  Future<ApiResultModel<int>> addNewCategory_() async {
    if (newCategoryCostController.text.isEmpty ||
        newCategoryNameController.text.isEmpty ||
        (originalColorValue?.isEmpty == null) ||
        newCategoryEntity == null) {
      return ApiResultModel.failure(
        message: ErrorResultModel(
          message: "you add Uncompleted data in new category",
        ),
      );
    }
    if (originalColorValue!.isEmpty) {
      return ApiResultModel.failure(
        message: ErrorResultModel(
          message: "you add Uncompleted data in new category",
        ),
      );
    }
    newCategoryEntity!.name = newCategoryNameController.text;
    newCategoryEntity!.cost = double.tryParse(newCategoryCostController.text);
    newCategoryEntity!.original_color_value = originalColorValue;
    newCategoryEntity!.description = newCategoryDescriptionController.text;
    final result = await executeParamsUseCase(
      useCase: addNewCategory,
      query: newCategoryEntity!,
    );
    if (result is Success<int>) {
      newCategoryCostController.text = "";
      newCategoryNameController.text = "";
      newCategoryDescriptionController.text = "";
      originalColorValue = "";
      newCategoryEntity = null;
    }
    notifyListeners();
    return result!;
  }

  @override
  void onDispose() {
    log("disposedddddddd");
    newCategoryCostController.dispose();
    newCategoryNameController.dispose();

    newCategoryDescriptionController.dispose();
    nameController.dispose();
    phoneNumberController.dispose();
    // TODO: implement dispose
  }
}
