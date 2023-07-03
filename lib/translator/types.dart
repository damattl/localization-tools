class TranslatorConfig {
  final String authKey;
  final Map<String, String> lang;
  TranslatorConfig(this.authKey, this.lang);

  factory TranslatorConfig.fromJson(Map<String, dynamic> json) {
    return TranslatorConfig(
      json["auth_key"] as String,
      (json["lang"] as Map<String, dynamic>).map((key, value) => MapEntry(key, value as String)),
    );
  }
}

