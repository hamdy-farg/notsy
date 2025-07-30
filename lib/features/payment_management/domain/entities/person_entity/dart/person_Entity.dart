import 'package:equatable/equatable.dart';
import 'package:notsy/features/payment_management/domain/entities/payment_entities/payment_info_entity.dart';

class PersonEntity extends Equatable {
  final int? id;
  String? name;
  String? phoneNumber;
  List<PaymentInfoEntity>? payments; // 👈 Add this

  PersonEntity({this.id, this.name, this.phoneNumber, this.payments});

  @override
  // TODO: implement props
  List<Object?> get props => <Object?>[id, name, phoneNumber, payments];
}
