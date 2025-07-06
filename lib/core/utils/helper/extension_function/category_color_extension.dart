import 'package:notsy/features/payment_management/domain/entities/payment_entities/category_entity.dart';

extension CategoryListExtension on List<CategoryEntity> {
  CategoryEntity getEffectiveCategory({
    List<String> highPriorityNames = const ['unpaid', 'underpaid'],
  }) {
    // Try to find a high-priority category like "Unpaid" or "Underpaid"

    final index = indexWhere(
      (cat) => highPriorityNames.contains(cat.category_status?.name),
    );

    // Return the matching category if found, or first category, or fallback
    if (index != -1) {
      return this[index];
    } else if (isNotEmpty) {
      return first;
    } else {
      return CategoryEntity(name: 'Default', color_value: 'D1D5DB');
    }
  }

  int getEffectiveCategoryColor() {
    final effective = getEffectiveCategory();
    if (effective.color_value == null) {
      return int.tryParse(
            "0xff${effective.original_color_value?.replaceAll('#', '')}",
          ) ??
          0xffD1D5DB;
    } else {
      return int.tryParse(
            "0xff${effective.color_value?.replaceAll('#', '')}",
          ) ??
          0xffD1D5DB;
    }
  }

  String getEffectiveCategoryAmount() {
    final unpaid_index = indexWhere(
      (cat) => cat.category_status?.name == "unpaid",
    );
    final underpaid_index = indexWhere(
      (cat) => cat.category_status?.name == "underpaid",
    );

    if (unpaid_index != -1) {
      return "\$${this[unpaid_index].amount_paid ?? 0}// ";
    } else if (underpaid_index != -1) {
      return "\$${this[underpaid_index].amount_paid ?? 0}/ //${this[underpaid_index].cost}";
    } else {
      return "\$${this[0].amount_paid ?? 0}// ";
    }
  }

  String getEffectiveCategoryDescription() {
    final unpaid_index = indexWhere(
      (cat) => cat.category_status?.name == "unpaid",
    );
    final underpaid_index = indexWhere(
      (cat) => cat.category_status?.name == "underpaid",
    );

    if (unpaid_index != -1) {
      return "Need \$${this[unpaid_index].amount_paid ?? 0}";
    } else if (underpaid_index != -1) {
      return "-\$${(this[underpaid_index].cost ?? 0) - (this[underpaid_index].amount_paid?.toDouble() ?? 0)}";
    } else {
      return "";
    }
  }
}

extension CategoryEntityExtension on CategoryEntity {
  int getEffectiveCategoryColor() {
    return int.tryParse(
          "0xff${this.original_color_value?.replaceAll('#', '')}",
        ) ??
        0xffD1D5DB;
  }
}
