extension EnumListExtension<T extends Enum> on List<T> {
  T fromString(String value) {
    return firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => this.first,
    );
  }
}
