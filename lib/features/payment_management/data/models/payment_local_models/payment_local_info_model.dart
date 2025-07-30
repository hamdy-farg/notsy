import 'package:notsy/core/commondomain/utils/mapper/data_mapper.dart';
import 'package:notsy/features/payment_management/data/models/payment_local_models/person_local_model.dart';
import 'package:notsy/features/payment_management/domain/entities/payment_entities/category_entity.dart';
import 'package:notsy/features/payment_management/domain/entities/payment_entities/payment_info_entity.dart';
import 'package:objectbox/objectbox.dart';

import '../../../../../core/commondomain/utils/extenstion/payment_method_enum_extension.dart';
import 'category_local_model.dart';

@Entity()
class PaymentInfoLocalModel extends DataMapper<PaymentInfoEntity> {
  @Id()
  int id = 0;
  // String? name;
  // String? phoneNumber;
  DateTime? date;
  String? paymentMethod;
  String? colorValue;
  String? paymentStatus;
  double? amountPaid;
  double? quantity;
  String? description;
  final category = ToOne<CategoryLocalModel>();
  final person = ToOne<PersonLocalModel>();

  PaymentInfoLocalModel({
    this.paymentMethod,
    this.amountPaid,
    this.colorValue,
    this.paymentStatus,
    this.quantity,
    this.date,
    this.description,
  });
  factory PaymentInfoLocalModel.fromEntity(
    PaymentInfoEntity entity,
    PersonLocalModel personModel,
    CategoryLocalModel categoryModel,
  ) {
    if (entity.amountPaid == 0) {
      entity.paymentStatusEnum = PaymentStatusEnum.unpaid;
      entity.colorValue = "EF4444"; // red color
    } else if ((entity.amountPaid ?? 0) <
        ((entity.category?.cost ?? 0) * (entity.quantity ?? 0))) {
      entity.paymentStatusEnum = PaymentStatusEnum.unpaid;
      entity.colorValue = "C2410C"; // yellow color
    }

    return PaymentInfoLocalModel()
      ..id = entity.id ?? 0
      ..date = entity.date ?? DateTime.now()
      ..paymentMethod = entity.paymentMethodEnum?.name ?? "cash"
      ..amountPaid = entity.amountPaid
      ..quantity = entity.quantity
      ..description = entity.description
      ..paymentStatus = entity.paymentStatusEnum?.name ?? "paid"
      ..colorValue = entity.colorValue
      ..person.target = personModel
      ..category.target = categoryModel;
  }
  @override
  PaymentInfoEntity mapToEntity({bool includePerson = false}) {
    // log("category.target?.mapToEntity()");
    return PaymentInfoEntity(
      id: id,
      date: date,
      amountPaid: amountPaid,
      quantity: quantity,
      description: description,
      category: category.target?.mapToEntity(),
      paymentStatusEnum: PaymentStatusEnum.values.fromString(
        paymentStatus ?? "cash",
      ),
      colorValue: colorValue,
      paymentMethodEnum: PaymentMethodEnum.values.fromString(
        paymentMethod ?? "",
      ),
    );
  }
}
