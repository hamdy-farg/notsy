import 'package:notsy/core/commondomain/utils/extenstion/payment_method_enum_extension.dart';
import 'package:notsy/features/payment_management/data/models/payment_local_models/payment_local_info_model.dart';
import 'package:objectbox/objectbox.dart';

import '../../../../../core/commondomain/utils/mapper/data_mapper.dart';
import '../../../domain/entities/payment_entities/category_entity.dart';

@Entity()
class CategoryLocalModel extends DataMapper<CategoryEntity> {
  CategoryLocalModel({
    this.name,
    this.cost,
    this.category_status,
    this.amount_paid,
    this.quantity,
    this.description,
    this.color_value,
    this.original_color_value,
  });
  @Id()
  int id = 0;
  final String? name;
  final String? original_color_value;
  final String? color_value;
  @Backlink("category_list")
  final ToMany<PaymentInfoLocalModel> paymentInfo =
      ToMany<PaymentInfoLocalModel>();
  final double? quantity;
  final double? cost;
  final String? category_status;
  final double? amount_paid;
  final String? description;

  factory CategoryLocalModel.fromEntity(CategoryEntity entity) {
    final model = CategoryLocalModel(
      name: entity.name,
      cost: entity.cost ?? 0,
      category_status: entity.category_status?.name ?? "paid",
      amount_paid: entity.amount_paid ?? 0,
      quantity: entity.quantity ?? 1,
      description: entity.description,
      color_value: entity.color_value,
      original_color_value: entity.original_color_value,
    );

    model.id = entity.id ?? 0;
    return model;
  }
  @override
  CategoryEntity mapToEntity() {
    return CategoryEntity(
      original_color_value: original_color_value,
      color_value: color_value,
      name: name,
      quantity: quantity,
      cost: cost,
      category_status: CategoryStatus.values.fromString(category_status ?? ""),
      amount_paid: amount_paid,
      description: description,
    );
  }
}
