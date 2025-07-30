import 'package:notsy/features/payment_management/data/models/payment_local_models/payment_local_info_model.dart';
import 'package:objectbox/objectbox.dart';

import '../../../../../core/commondomain/utils/mapper/data_mapper.dart';
import '../../../domain/entities/payment_entities/category_entity.dart';

@Entity()
class CategoryLocalModel extends DataMapper<CategoryEntity> {
  CategoryLocalModel({
    this.name,
    this.cost,
    this.description,
    this.originalColorValue,
  });
  @Id()
  int id = 0;
  final String? name;
  final String? originalColorValue;
  final double? cost;
  final String? description;

  @Backlink()
  final ToMany<PaymentInfoLocalModel> payments =
      ToMany<PaymentInfoLocalModel>();

  factory CategoryLocalModel.fromEntity(CategoryEntity entity) {
    // if ((entity.cost ?? 0) * (entity.quantity ?? 0) >
    //     (entity.amount_paid ?? 0)) {
    //   entity.category_status = CategoryStatus.underpaid;
    //   entity.color_value = "C2410C"; // yellow color
    // } else if (entity.amount_paid != null && (entity.amount_paid ?? 0) == 0) {
    //   entity.category_status = CategoryStatus.unpaid;
    //   entity.color_value = "EF4444";
    // } else {
    //   entity.category_status = CategoryStatus.paid;
    //   entity.color_value = null;
    // }

    return CategoryLocalModel(
      name: entity.name,
      cost: entity.cost ?? 0,
      description: entity.description,
      originalColorValue: entity.originalColorValue,
    )..id = entity.id ?? 0;
  }
  @override
  CategoryEntity mapToEntity() {
    return CategoryEntity(
      id: id,
      originalColorValue: originalColorValue,
      name: name,
      cost: cost,
      description: description,
    );
  }
}
