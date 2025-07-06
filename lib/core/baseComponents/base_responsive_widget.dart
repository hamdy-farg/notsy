import 'package:flutter/cupertino.dart';
import 'package:notsy/core/di/app_component/app_component.dart';

import '../utils/helper/extension_function/responsive_ui_helper/responsive_config.dart';

class BaseResponsiveWidget extends StatelessWidget {
  const BaseResponsiveWidget({
    super.key,
    required this.buildWidget,
    this.initializeConfig = false,
  });
  final Widget Function(
    BuildContext context,
    ResponsiveUiConfig responsiveUiConfig,
  )
  buildWidget;

  final bool initializeConfig;

  @override
  Widget build(BuildContext context) {
    final ResponsiveUiConfig responsiveUiConfig = locator<ResponsiveUiConfig>();
    if (initializeConfig) {
      responsiveUiConfig.initialize(context);
    }
    return buildWidget(context, responsiveUiConfig);
  }
}
