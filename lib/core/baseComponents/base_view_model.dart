import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../commondomain/entities/based_api_result_models/api_result_model.dart';
import '../commondomain/usecase/base_param_usecase.dart';

class BaseViewModel extends ChangeNotifier {
  final StreamController<bool> _toggleLoading =
      StreamController<bool>.broadcast();
  StreamController<bool> get toggleLoading => _toggleLoading;

  Future<ApiResultModel<Type>?> executeParamsUseCase<Type, Params>({
    required BaseParamsUseCase<Type, Params> useCase,
    required Params query,
    bool launchLoader = true,
  }) async {
    showLoadingIndicator(launchLoader);
    final ApiResultModel<Type> _apiResultModel = await useCase(query);
    await Future.delayed(Duration(milliseconds: 400));
    if (_apiResultModel is Success) {
      showLoadingIndicator(false);
      return _apiResultModel;
    } else {
      showLoadingIndicator(false);
      return _apiResultModel is Failure ? _apiResultModel : null;
    }
  }

  void showLoadingIndicator(bool show) {
    _toggleLoading.add(show);
    notifyListeners();
  }

  void onDispose() {}

  @override
  void dispose() {
    _toggleLoading.close();
    onDispose();
    super.dispose();
  }
}
