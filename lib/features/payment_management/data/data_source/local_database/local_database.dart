import 'dart:io';

import 'package:notsy/objectbox.g.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class AppLocalDatabase {
  static Store? _store;

  static Future<AppLocalDatabase> create() async {
    final Directory docsDir = await getApplicationDocumentsDirectory();
    _store = await openStore(directory: p.join(docsDir.path, 'object'));
    return AppLocalDatabase();
  }

  Box<T>? getBox<T>() {
    return _store?.box<T>();
  }

  int? insert<T>(T object) {
    final Box<T>? box = _store?.box<T>();
    return box?.put(object);
  }

  bool update<T>(T object) {
    final Box<T>? box = _store?.box<T>();
    return box?.put(object) != null;
  }

  bool delete<T>(int id) {
    final Box<T>? box = _store?.box<T>();
    return box?.remove(id) ?? false;
  }

  T? get<T>(int id) {
    final Box<T>? box = _store?.box<T>();
    return box?.get(id);
  }

  List<T>? getAll<T>() {
    final Box<T>? box = _store?.box<T>();
    return box?.getAll();
  }
}
