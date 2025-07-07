import 'package:injectable/injectable.dart';

import '../../common_data/data_source/local/local/local_database.dart';

@module
abstract class AppModule {
  @preResolve
  Future<AppLocalDatabase> get prefs => AppLocalDatabase.create();
}
