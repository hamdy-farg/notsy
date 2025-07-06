import 'package:injectable/injectable.dart';

import '../../../features/payment_management/data/data_source/local_database/local_database.dart';

@module
abstract class AppModule {
  @preResolve
  Future<AppLocalDatabase> get prefs => AppLocalDatabase.create();
}
