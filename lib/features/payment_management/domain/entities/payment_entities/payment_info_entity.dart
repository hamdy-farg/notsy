import 'package:equatable/equatable.dart';
import 'package:notsy/features/payment_management/domain/entities/person_entity/dart/person_Entity.dart';

import 'category_entity.dart';

class PaymentInfoEntity extends Equatable {
  PaymentInfoEntity({
    this.id,
    this.date,
    this.category,
    this.paymentMethodEnum,
    this.amountPaid,
    this.quantity,
    this.colorValue,
    this.paymentStatusEnum,
    this.description,
    this.person,
  });

  final int? id;
  PaymentMethodEnum? paymentMethodEnum;
  DateTime? date;
  CategoryEntity? category;
  double? quantity;
  double? amountPaid;
  String? colorValue;
  PaymentStatusEnum? paymentStatusEnum;

  String? description;
  PersonEntity? person;
  @override
  // TODO: implement props
  List<Object?> get props => <Object?>[
    id,

    date,
    category,
    paymentMethodEnum,
    quantity,
    amountPaid,
    person,
    category,
  ];
}

enum PaymentMethodEnum { cash, vodafone_cash }
