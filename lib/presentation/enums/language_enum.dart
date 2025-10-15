enum LanguageEnum {
  english,
  french,
  arabic;

  static LanguageEnum fromString(String language) {
    if (language == LanguageEnum.english.languageText) {
      return LanguageEnum.english;
    } else if (language == LanguageEnum.french.languageText) {
      return LanguageEnum.french;
    } else if (language == LanguageEnum.arabic.languageText) {
      return LanguageEnum.arabic;
    } else {
      return LanguageEnum.english;
    }
  }

  static LanguageEnum fromCode(String languageCode) {
    if (languageCode == LanguageEnum.english.code) {
      return LanguageEnum.english;
    } else if (languageCode == LanguageEnum.french.code) {
      return LanguageEnum.french;
    } else if (languageCode == LanguageEnum.arabic.code) {
      return LanguageEnum.arabic;
    } else {
      return LanguageEnum.english;
    }
  }

  String get code {
    switch (this) {
      case LanguageEnum.arabic:
        return "ar";
      case LanguageEnum.english:
        return "en";
      case LanguageEnum.french:
        return "fr";
    }
  }

  String get languageText {
    switch (this) {
      case LanguageEnum.english:
        return "English";
      case LanguageEnum.french:
        return "French";
      case LanguageEnum.arabic:
        return "العربية";
    }
  }

  bool get isRTL {
    switch (this) {
      case LanguageEnum.arabic:
        return true;
      case LanguageEnum.french:
      case LanguageEnum.english:
        return false;
    }
  }
}
