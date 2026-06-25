import 'dart:ui';

enum AppLanguage {
  english('en'),
  japanese('ja'),
  spanish('es'),
  german('de'),
  french('fr'),
  chinese('zh'),
  vietnamese('vi');

  const AppLanguage(this.code);

  final String code;

  Locale get locale => Locale(code);

  static AppLanguage fromCode(String? code) {
    return AppLanguage.values.firstWhere(
      (e) => e.code == code,
      orElse: () => .english,
    );
  }
}
