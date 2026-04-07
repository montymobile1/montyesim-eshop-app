import "package:easy_localization/easy_localization.dart" as localization;
import "package:esim_open_source/presentation/enums/language_enum.dart";
import "package:flutter/material.dart";

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(this);
  }
}

extension SearchValidator on String {
  String get normalizeString {
    // Remove diacritics/accents from the string
    const Map<String, String> diacriticsMap = <String, String>{
      "á": "a",
      "à": "a",
      "ä": "a",
      "â": "a",
      "ã": "a",
      "å": "a",
      "ā": "a",
      "é": "e",
      "è": "e",
      "ë": "e",
      "ê": "e",
      "ē": "e",
      "ė": "e",
      "ę": "e",
      "í": "i",
      "ì": "i",
      "ï": "i",
      "î": "i",
      "ī": "i",
      "į": "i",
      "ó": "o",
      "ò": "o",
      "ö": "o",
      "ô": "o",
      "õ": "o",
      "ō": "o",
      "ø": "o",
      "ú": "u",
      "ù": "u",
      "ü": "u",
      "û": "u",
      "ū": "u",
      "ų": "u",
      "ý": "y",
      "ÿ": "y",
      "ñ": "n",
      "ń": "n",
      "ç": "c",
      "ć": "c",
      "č": "c",
      "ś": "s",
      "š": "s",
      "ź": "z",
      "ż": "z",
      "ž": "z",
      "Á": "A",
      "À": "A",
      "Ä": "A",
      "Â": "A",
      "Ã": "A",
      "Å": "A",
      "Ā": "A",
      "É": "E",
      "È": "E",
      "Ë": "E",
      "Ê": "E",
      "Ē": "E",
      "Ė": "E",
      "Ę": "E",
      "Í": "I",
      "Ì": "I",
      "Ï": "I",
      "Î": "I",
      "Ī": "I",
      "Į": "I",
      "Ó": "O",
      "Ò": "O",
      "Ö": "O",
      "Ô": "O",
      "Õ": "O",
      "Ō": "O",
      "Ø": "O",
      "Ú": "U",
      "Ù": "U",
      "Ü": "U",
      "Û": "U",
      "Ū": "U",
      "Ų": "U",
      "Ý": "Y",
      "Ÿ": "Y",
      "Ñ": "N",
      "Ń": "N",
      "Ç": "C",
      "Ć": "C",
      "Č": "C",
      "Ś": "S",
      "Š": "S",
      "Ź": "Z",
      "Ż": "Z",
      "Ž": "Z",
    };

    String normalized = toLowerCase();
    diacriticsMap.forEach((String key, String value) {
      normalized = normalized.replaceAll(key.toLowerCase(), value);
    });
    return normalized;
  }
}

extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    int i = 0;
    return map((dynamic e) => f(e, i++));
  }
}

extension CompactMap<K, V> on Map<K, V> {
  Map<K2, V2> compactMap<K2, V2>(
    MapEntry<K2, V2>? Function(MapEntry<K, V>) f,
  ) {
    final Map<K2, V2> result = <K2, V2>{};
    for (final MapEntry<K, V> entry in entries) {
      final MapEntry<K2, V2>? newEntry = f(entry);
      if (newEntry != null) {
        result[newEntry.key] = newEntry.value;
      }
    }
    return result;
  }
}

extension RTLExtension on Widget {
  Widget imageSupportsRTL(BuildContext context) {
    final String langCode =
        localization.EasyLocalization.of(context)?.locale.languageCode ?? "en";

    final bool isRTL = LanguageEnum.fromCode(langCode).isRTL;

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..scaleByDouble(isRTL ? -1.0 : 1.0, 1, 1, 1),
      child: this,
    );

  }

  Widget textSupportsRTL(BuildContext context, {bool reverse = false}) {
    final String langCode =
        localization.EasyLocalization.of(context)?.locale.languageCode ?? "en";

    bool isRTL = LanguageEnum.fromCode(langCode).isRTL;

    if (reverse) {
      isRTL = !isRTL;
    }

    return Align(
      alignment: isRTL ? Alignment.centerRight : Alignment.centerLeft,
      child: this,
    );
  }
}

bool isRTL(BuildContext context) {
  final String langCode =
      localization.EasyLocalization.of(context)?.locale.languageCode ?? "en";

  return LanguageEnum.fromCode(langCode).isRTL;
}
