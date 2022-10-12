enum ProgrammingLanguage {
  rust,
  cpp,
  dart,
}

extension ProgrammingLanguageExtension on ProgrammingLanguage {
  String get stringValue {
    switch (this) {
      case ProgrammingLanguage.rust:
        return 'Rust';

      case ProgrammingLanguage.cpp:
        return 'C++';

      case ProgrammingLanguage.dart:
        return 'Dart';
    }
  }
}
