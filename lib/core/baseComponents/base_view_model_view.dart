import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'base_view_model.dart';

class BaseViewModelView<T> extends StatefulWidget {
  const BaseViewModelView({
    Key? key,
    this.onInitState,
    required this.buildWidget,
  }) : super(key: key);
  final void Function(T provider)? onInitState;
  final Widget Function(T provider) buildWidget;

  @override
  State<BaseViewModelView<T>> createState() => _BaseViewModelView<T>();
}

class _BaseViewModelView<T> extends State<BaseViewModelView<T>> {
  bool _showLoader = false;
  @override
  void initState() {
    super.initState();
    final T _provider = Provider.of<T>(context, listen: false);
    if (widget.onInitState != null) {
      widget.onInitState!(_provider);
    }
  }

  void toggleLoadingWidget(T provider) {
    (provider as BaseViewModel).toggleLoading.stream.listen((bool show) {
      if (!mounted) {
        return;
      }
      setState(() {
        _showLoader = show;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (BuildContext context, T provider, Widget? child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            widget.buildWidget(provider),
            if (_showLoader)  CircularProgressIndicator(),
          ],
        );
      },
    );
  }
}
