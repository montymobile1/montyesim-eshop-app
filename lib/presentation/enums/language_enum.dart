enum LanguageEnum {
  english,
  french,
  arabic;

  static LanguageEnum fromString(String language) {
    if (language.toLowerCase() == LanguageEnum.english.languageText.toLowerCase()) {
      return LanguageEnum.english;
    } else if (language.toLowerCase() == LanguageEnum.french.languageText.toLowerCase()) {
      return LanguageEnum.french;
    } else if (language.toLowerCase() == LanguageEnum.arabic.languageText.toLowerCase()) {
      return LanguageEnum.arabic;
    } else {
      return LanguageEnum.english;
    }
  }

  static LanguageEnum fromCode(String languageCode) {
    if (languageCode.toLowerCase() == LanguageEnum.english.code.toLowerCase()) {
      return LanguageEnum.english;
    } else if (languageCode.toLowerCase() == LanguageEnum.french.code.toLowerCase()) {
      return LanguageEnum.french;
    } else if (languageCode.toLowerCase() == LanguageEnum.arabic.code.toLowerCase()) {
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
