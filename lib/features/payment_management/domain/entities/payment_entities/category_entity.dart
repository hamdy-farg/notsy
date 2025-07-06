import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  CategoryEntity({
    this.id,
    this.name,
    this.cost,
    this.category_status,
    this.amount_paid,
    this.quantity,
    this.description,
    this.original_color_value,
    this.color_value,
  });
  final int? id;
  String? original_color_value;
  String? color_value;
  String? name;
  CategoryStatus? category_status = CategoryStatus.paid;
  double? quantity = 1;
  double? cost = 0;
  double? amount_paid = 0;
  String? description;
  @override
  // TODO: implement props
  List<Object?> get props => <Object?>[name];
}

enum CategoryStatus { paid, unpaid, underpaid }
