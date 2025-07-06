import 'package:notsy/core/commondomain/utils/mapper/data_mapper.dart';
import 'package:notsy/features/payment_management/domain/entities/payment_entities/payment_info_entity.dart';
import 'package:objectbox/objectbox.dart';

import '../../../../../core/commondomain/utils/extenstion/payment_method_enum_extension.dart';
import 'category_local_model.dart';

@Entity()
class PaymentInfoLocalModel extends DataMapper<PaymentInfoEntity> {
  @Id()
  int id = 0;
  String? name;
  String? phone_number;
  DateTime? date;
  ToMany<CategoryLocalModel> category_list = ToMany<CategoryLocalModel>();
  String? payment_method;
  String? description;
  PaymentInfoLocalModel({
    this.name,
    this.phone_number,
    this.date,
    this.payment_method,
    this.description,
  });
  factory PaymentInfoLocalModel.fromEntity(PaymentInfoEntity entity) {
    final model = PaymentInfoLocalModel(
      name: entity.name,
      phone_number: entity.phone_number,
      date: entity.date ?? DateTime.now(),
      payment_method: entity.payment_method?.name ?? "cash",
      description: entity.description,
    );
    model.id = entity.id ?? 0;

    if (entity.category_list != null) {
      model.category_list.addAll(
        entity.category_list!.map((e) => CategoryLocalModel.fromEntity(e)),
      );
    }
    return model;
  }
  @override
  PaymentInfoEntity mapToEntity() {
    return PaymentInfoEntity(
      id: id,
      name: name,
      phone_number: phone_number,
      date: date,
      category_list: category_list.map((e) => e.mapToEntity()).toList(),
      payment_method: PaymentMethodEnum.values.fromString(payment_method ?? ""),
      description: description,
    );
  }
}
