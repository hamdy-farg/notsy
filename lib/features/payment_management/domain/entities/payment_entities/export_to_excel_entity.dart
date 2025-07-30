import '../person_entity/dart/person_Entity.dart';

class ExportToExcelEntity {
  final List<String> selectedCategoryName;
  final List<PersonEntity> personList;
  final String fileName;
  const ExportToExcelEntity({
    this.selectedCategoryName = const ["All"],
    required this.personList,
    required this.fileName,
  });
}
