/// A wrapper to distinguish "set field to null" from "leave field unchanged"
/// in [copyWith] methods.
class Nullable<T> {
  final T? value;
  const Nullable(this.value);
}
