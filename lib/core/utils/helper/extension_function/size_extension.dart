import 'package:notsy/core/di/app_component/app_component.dart';
import 'package:notsy/core/utils/helper/extension_function/responsive_ui_helper/responsive_config.dart';

extension ExtensionOnNum on num {
  static final ResponsiveUiConfig _responsiveUiConfig =
      locator<ResponsiveUiConfig>();

  double get w => _responsiveUiConfig.setWidth(this);

  double get h => _responsiveUiConfig.setHeight(this);
}
