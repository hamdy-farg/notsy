import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  CategoryEntity({
    this.id,
    this.name,
    this.description,
    this.originalColorValue,
    this.cost,
  });
  final int? id;
  double? cost;
  String? originalColorValue;
  String? name;
  String? description;
  @override
  // TODO: implement props
  List<Object?> get props => <Object?>[name];
}

enum PaymentStatusEnum { paid, unpaid, underpaid }

extension PaymentStatusEnumExtension on PaymentStatusEnum {
  static PaymentStatusEnum fromString(String? status) {
    switch (status?.toLowerCase()) {
      case 'paid':
        return PaymentStatusEnum.paid;
      case 'unpaid':
        return PaymentStatusEnum.unpaid;
      case 'underpaid':
        return PaymentStatusEnum.underpaid;
      default:
        return PaymentStatusEnum.paid; // or throw error or use a fallback
    }
  }

  String get name => toString().split('.').last;
}
