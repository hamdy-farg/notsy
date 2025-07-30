import '../../../../features/payment_management/domain/entities/payment_entities/category_entity.dart';

extension CategoryEntityColorExtension on CategoryEntity {
  int originalColorToColorValue() {
    return int.tryParse("0xff$originalColorValue") ?? 0xffD1D5DB;
  }
}
