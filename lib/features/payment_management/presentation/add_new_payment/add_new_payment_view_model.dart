import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:notsy/core/baseComponents/base_view_model.dart';
import 'package:notsy/core/commondomain/entities/based_api_result_models/api_result_model.dart';
import 'package:notsy/core/commondomain/entities/based_api_result_models/error_result_model.dart';
import 'package:notsy/core/commondomain/usecase/base_param_usecase.dart';
import 'package:notsy/features/payment_management/domain/entities/payment_entities/category_entity.dart';
import 'package:notsy/features/payment_management/domain/entities/payment_entities/payment_info_entity.dart';
import 'package:notsy/features/payment_management/domain/entities/person_entity/dart/person_Entity.dart';
import 'package:notsy/features/payment_management/domain/use_case/category_usecase/add_new_category.dart';
import 'package:notsy/features/payment_management/domain/use_case/category_usecase/get_all_category.dart';
import 'package:notsy/features/payment_management/domain/use_case/payment_usecase/delete_payment.dart';
import 'package:notsy/features/payment_management/domain/use_case/payment_usecase/get_payment.dart';
import 'package:notsy/features/payment_management/domain/use_case/payment_usecase/update_payment.dart';

import '../../domain/use_case/payment_usecase/insert_payment.dart';

@injectable
class AddNewPaymentViewModel extends BaseViewModel {
  final UpdatePersonData _updatePersonData;
  final AddNewPayment _addNewPayment;
  final DeletePerson _deletePayment;
  final GetAllPaymentCategories _getAllPaymentCategories;
  final AddNewCategory _addNewCategory;
  final GetPayment _getPaymentInfo;

  AddNewPaymentViewModel(
    this._updatePersonData,
    this._addNewPayment,
    this._addNewCategory,
    this._getPaymentInfo,
    this._getAllPaymentCategories,
    this._deletePayment,
  );

  Future<ApiResultModel<bool>> deletePaymentInfo({required int id}) async {
    final result = await executeParamsUseCase(
      useCase: _deletePayment,
      query: id,
    );
    return result!;
  }

  //
  List<TextEditingController> quantityControllerList = [];
  List<TextEditingController> amountPaidControllerList = [];
  List<CategoryEntity> categoryEntityList = [];
  //
  List<PaymentInfoEntity> paymentEntities = [];

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

  void readyToUpdate({required PersonEntity personEntity}) {
    paymentEntities = personEntity.payments ?? [];
    // log("controller = ${paymentInfoEntity}");
    nameController.text = personEntity.name ?? "";

    phoneNumberController.text = personEntity.phoneNumber ?? "";

    for (PaymentInfoEntity payment in paymentEntities) {
      dateTime = payment.date ?? DateTime.now();
      paymentMethodEnum = payment.paymentMethodEnum ?? PaymentMethodEnum.cash;

      for (final i in paymentEntities) {
        quantityControllerList.add(TextEditingController());
        amountPaidControllerList.add(TextEditingController());
      }

      for (int i = 0; i < paymentEntities.length; i++) {
        quantityControllerList[i].text = paymentEntities[i].quantity.toString();
        amountPaidControllerList[i].text = paymentEntities[i].amountPaid
            .toString();
      }
      // log("amount ${paymentEntities[0].amountPaid}");
      // notifyListeners();
    }
  }

  Future<void> addPaymentField() async {
    await getAllCategory();
    quantityControllerList.add(TextEditingController());
    amountPaidControllerList.add(TextEditingController());
    paymentEntities.add(
      PaymentInfoEntity(person: PersonEntity(), category: CategoryEntity()),
    );
    // log("len${categoryEntityList.length}");
    if (categoryEntityList.length != 1) {
      // notifyListeners();
    }
  }

  double getTotalAmountPaid() {
    double total = 0;

    for (PaymentInfoEntity i in paymentEntities) {
      if (i.amountPaid == null) {
        continue;
      }
      total += i.amountPaid!;
    }
    return total;
  }

  double getTotalCost() {
    double total = 0;

    for (PaymentInfoEntity i in paymentEntities) {
      if (i.category?.cost == null || i.quantity == null) {
        continue;
      }
      total += (i.category?.cost ?? 0) * i.quantity!;
    }

    return total;
  }

  double getTotalRemaining() {
    double total = 0;

    for (PaymentInfoEntity i in paymentEntities) {
      if (i.category?.cost == null ||
          i.quantity == null ||
          i.amountPaid == null) {
        continue;
      }
      total += (((i.category?.cost ?? 0) * i.quantity!) - i.amountPaid!);
    }
    return total;
  }

  void removePaymentField({required int index}) {
    if (categoryEntityList.length == 1) {
    } else {
      quantityControllerList.removeAt(index);
      amountPaidControllerList.removeAt(index);
      paymentEntities.removeAt(index);

      // log("len${categoryEntityList.length}");
      getAllCategory();
      // notifyListeners();
    }
  }

  //
  void setPaymentName({required int index, required String? name}) {
    paymentEntities[index].category?.name = name;
    notifyListeners();
  }

  void setQuantity(int index, String value) {
    paymentEntities[index].quantity = double.tryParse(value);
    notifyListeners();
  }

  void setAmountPaid(int index, String value) {
    paymentEntities[index].amountPaid = double.tryParse(value);
    notifyListeners();
  }

  //
  setNewPaymentEntity({
    // TODO !!!!!!!!!!!!!!!!!!!!!!!!!!!!
    required int index,
    required CategoryEntity category,
  }) {
    paymentEntities[index].category = category;
    notifyListeners();
  }

  //
  void setDateTime(DateTime date) {
    dateTime = date;
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
    for (int index = 0; index < paymentEntities.length; index++) {
      paymentEntities[index].paymentMethodEnum = method;
      // log("payment method ${paymentEntities[index].paymentMethodEnum}");
    }
    paymentMethodEnum = method;
    notifyListeners();
  }

  // void setCategoryList(List<CategoryEntity> list) {
  //   categoryList = list;
  //   notifyListeners();
  // }

  //

  //
  ApiResultModel? paymentInfoValidation() {
    if (nameController.text.isEmpty ||
        phoneNumberController.text.isEmpty ||
        dateTime.toString().isEmpty ||
        paymentEntities.isEmpty ||
        paymentMethodEnum.toString().isEmpty) {
      return ApiResultModel.failure(
        message: ErrorResultModel(
          message: "you add Uncompleted data in new category111",
        ),
      );
    }

    for (PaymentInfoEntity i in paymentEntities) {
      if (i.amountPaid == null ||
          i.quantity == null ||
          i.category?.cost == null) {
        return ApiResultModel.failure(
          message: ErrorResultModel(
            message:
                """${i.person} ||
          ${i.amountPaid == null} ||
              ${i.quantity == null} ||
              ${i.category?.cost == null}""",
          ),
        );
      } else if (i.person?.name == "" ||
          i.amountPaid.toString().isEmpty ||
          i.quantity.toString().isEmpty ||
          (i.category?.cost).toString().isEmpty) {
        return ApiResultModel.failure(
          message: ErrorResultModel(
            message: "you add Uncompleted data in new category3333",
          ),
        );
      }
    }
    return null;
  }

  Future<ApiResultModel<bool>> updatePersonData({
    required PersonEntity person,
  }) async {
    person.payments = paymentEntities;
    person.name = nameController.text;
    person.phoneNumber = phoneNumberController.text;
    final paymentInfoValidation_ = paymentInfoValidation();
    if (paymentInfoValidation_ != null) {
      return ApiResultModel.failure(
        message: (paymentInfoValidation_ as Failure).message,
      );
    }

    final result = await executeParamsUseCase(
      useCase: _updatePersonData,
      query: person,
      // PaymentInfoEntity(
      //   id: id,
      //   person: payment.person,
      //   paymentMethodEnum: paymentMethodEnum,
      //   date: dateTime,
      //   category: payment.category,
      // ),
    );
    return result!;
  }

  Future<ApiResultModel<List<int>>> addPayment() async {
    // for (int index = 0; index < 20000; index++) {
    for (int i = 0; i < paymentEntities.length; i++) {
      paymentEntities[i].person?.name = nameController.text;
      paymentEntities[i].person?.phoneNumber = phoneNumberController.text;
      log(
        "hi5${paymentEntities[i].person?.name}\n ${paymentEntities[i].person?.phoneNumber}",
      );
    }
    final paymentInfoValidation_ = paymentInfoValidation();
    if (paymentInfoValidation_ != null) {
      return ApiResultModel.failure(
        message: (paymentInfoValidation_ as Failure).message,
      );
    }

    // log("payments :\n  \n ${paymentEntities.length}");
    final result = await executeParamsUseCase(
      useCase: _addNewPayment,
      query: paymentEntities,
    );
    // }

    return result!;
  }

  //
  Future<ApiResultModel<List<CategoryEntity>>> getAllCategory() async {
    final result = await executeParamsUseCase(
      useCase: _getAllPaymentCategories,
      query: NoParams(),
    );
    if (result is Success<List<CategoryEntity>>) {
      fitchedCategoryList = result.data;
      fitchedCategoryList.removeWhere((item) {
        return paymentEntities.any((element) => element.category == item);
      });
      // log("fitched category ${fitchedCategoryList}  data${categoryEntityList}");
    }
    // notifyListeners();
    return result!;
  }
  //

  //

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
    newCategoryEntity?.name = newCategoryNameController.text;
    newCategoryEntity?.cost = double.tryParse(newCategoryCostController.text);
    newCategoryEntity?.originalColorValue = originalColorValue;
    newCategoryEntity?.description = newCategoryDescriptionController.text;
    final result = await executeParamsUseCase(
      useCase: _addNewCategory,
      query: newCategoryEntity!,
    );
    if (result is Success<int>) {
      newCategoryCostController.text = "";
      newCategoryNameController.text = "";
      newCategoryDescriptionController.text = "";
      originalColorValue = "";
      newCategoryEntity = null;
    }
    // notifyListeners();
    return result!;
  }

  @override
  void onDispose() {
    // log("disposedddddddd");
    newCategoryCostController.dispose();
    newCategoryNameController.dispose();

    newCategoryDescriptionController.dispose();
    nameController.dispose();
    phoneNumberController.dispose();
    // TODO: implement dispose
  }
}
