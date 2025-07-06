import 'package:equatable/equatable.dart';

import 'category_entity.dart';

class PaymentInfoEntity extends Equatable {
  PaymentInfoEntity({
    this.id,
    this.name,
    this.phone_number,
    this.date,
    this.category_list,
    this.payment_method,
    this.description,
  });
  final int? id;
  String? name;
  String? phone_number;
  DateTime? date;
  List<CategoryEntity>? category_list;
  PaymentMethodEnum? payment_method;
  String? description;
  @override
  // TODO: implement props
  List<Object?> get props => <Object?>[
    id,
    name,
    phone_number,
    date,
    category_list,
    payment_method,
  ];
}

enum PaymentMethodEnum { cash, vodafone_cash }
