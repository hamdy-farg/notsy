import 'package:notsy/features/payment_management/data/models/payment_local_models/payment_local_info_model.dart';
import 'package:objectbox/objectbox.dart';

import '../../../domain/entities/person_entity/dart/person_Entity.dart';

@Entity()
class PersonLocalModel {
  @Id()
  int id = 0;

  String? name;
  String? phoneNumber;
  @Property(type: PropertyType.date)
  DateTime? latestUpdateAt; // ① new

  @Backlink()
  final ToMany<PaymentInfoLocalModel> payments =
      ToMany<PaymentInfoLocalModel>();
  PersonLocalModel({this.name, this.phoneNumber});
  factory PersonLocalModel.fromEntity(PersonEntity entity) {
    return PersonLocalModel(name: entity.name, phoneNumber: entity.phoneNumber)
      ..id = entity.id ?? 0;
  }
  PersonEntity mapToEntity() {
    return PersonEntity(
      id: id,
      name: name,
      phoneNumber: phoneNumber,
      payments: payments.map((e) => e.mapToEntity()).toList(),
    );
  }
}
