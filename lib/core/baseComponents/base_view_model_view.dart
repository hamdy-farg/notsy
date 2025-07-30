import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'base_view_model.dart';

class BaseViewModelView<T> extends StatefulWidget {
  BaseViewModelView({
    Key? key,
    this.onInitState,
    this.needLoader,
    required this.buildWidget,
  }) : super(key: key);
  final void Function(T provider)? onInitState;
  final Widget Function(T provider) buildWidget;
  bool? needLoader = true;

  @override
  State<BaseViewModelView<T>> createState() => _BaseViewModelView<T>();
}

class _BaseViewModelView<T> extends State<BaseViewModelView<T>> {
  bool _showLoader = false;
  @override
  void initState() {
    super.initState();
    final T _provider = Provider.of<T>(context, listen: false);
    toggleLoadingWidget(_provider);
    if (widget.onInitState != null) {
      widget.onInitState!(_provider);
    }
  }

  void toggleLoadingWidget(T provider) {
    (provider as BaseViewModel).toggleLoading.stream.listen((bool show) {
      if (!mounted) {
        return;
      }
      _showLoader = show;
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
            widget.needLoader != false && _showLoader == true
                ? Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.black.withOpacity(0.1),
                    child: const BlockingLoaderOverlay(),
                  )
                : Container(),
          ],
        );
      },
    );
  }
}

class MiniLoader extends StatelessWidget {
  const MiniLoader({super.key, this.size = 40});
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      // color: Colors.red,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            offset: const Offset(0, 2),
            color: Colors.black.withOpacity(0.08),
          ),
        ],
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
          backgroundColor: theme.colorScheme.primary.withOpacity(0.15),
        ),
      ),
    );
  }
}

class BlockingLoaderOverlay extends StatelessWidget {
  const BlockingLoaderOverlay({super.key, this.blur = false});

  /// Set to true if you want a frosted-glass blur behind the spinner.
  final bool blur;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1️⃣ Captures all taps.  Color transparent keeps visuals unchanged.
        const ModalBarrier(dismissible: false, color: Colors.transparent),

        // 2️⃣ Optional backdrop filter (subtle blur/fade)
        if (blur)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: const SizedBox(),
            ),
          ),

        // 3️⃣ Center-on-screen spinner (your existing MiniLoader)
        const Center(child: MiniLoader()),
      ],
    );
  }
}
