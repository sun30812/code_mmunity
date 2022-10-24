enum ProgrammingLanguage {
  rust,
  cpp,
  csharp,
  kotlin,
  python,
  swift,
  go,
  dart,
}

extension ProgrammingLanguageExtension on ProgrammingLanguage {
  String get stringValue {
    switch (this) {
      case ProgrammingLanguage.rust:
        return 'Rust';

      case ProgrammingLanguage.cpp:
        return 'C/C++';

      case ProgrammingLanguage.csharp:
        return 'C#';

      case ProgrammingLanguage.kotlin:
        return 'Kotlin';

      case ProgrammingLanguage.python:
        return 'Python';

      case ProgrammingLanguage.swift:
        return 'Swift';

      case ProgrammingLanguage.go:
        return 'Go';

      case ProgrammingLanguage.dart:
        return 'Dart';
    }
  }
}
