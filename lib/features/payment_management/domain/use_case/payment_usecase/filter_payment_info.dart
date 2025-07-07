import 'package:injectable/injectable.dart';
import 'package:notsy/core/commondomain/entities/based_api_result_models/api_result_model.dart';
import 'package:notsy/core/commondomain/usecase/base_param_usecase.dart';
import 'package:notsy/features/payment_management/domain/entities/payment_entities/payment_info_entity.dart';

import '../../repositories/payment_management_repository/payment_repository.dart';

@injectable
class FilterPaymentInfo
    extends
        BaseParamsUseCase<List<PaymentInfoEntity>, FilterPaymentParamsEntity> {
  FilterPaymentInfo(this.repository);
  final PaymentRepository repository;
  @override
  Future<ApiResultModel<List<PaymentInfoEntity>>> call(
    FilterPaymentParamsEntity filters,
  ) async {
    return repository.filterPaymentInfo(filters: filters);
  }
}

class FilterPaymentParamsEntity {
  final String? input;
  final List<String>? categoryList;
  final int? page;
  final DateTime? to;
  final DateTime? from;

  FilterPaymentParamsEntity({
    this.input,
    this.categoryList,
    this.page,
    this.to,
    this.from,
  });
}
