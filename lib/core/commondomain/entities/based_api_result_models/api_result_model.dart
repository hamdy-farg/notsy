import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:notsy/features/payment_management/domain/entities/payment_entities/payment_info_entity.dart';

import 'error_result_model.dart';

part "api_result_model.freezed.dart";

@freezed
class ApiResultModel<T> with _$ApiResultModel<T> {
  const factory ApiResultModel.success({required T data}) = Success<T>;
  const factory ApiResultModel.failure({required ErrorResultModel message}) =
      Failure<T>;
}
