import 'package:equatable/equatable.dart';

import '../entities/based_api_result_models/api_result_model.dart';

abstract class BaseParamsUseCase<Type, Request> {
  ApiResultModel<Type> call(Request params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => <Object>[];
}
