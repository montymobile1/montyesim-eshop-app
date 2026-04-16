class BundleCategoryResponseModel {
  BundleCategoryResponseModel({
    this.type,
    this.code,
    this.title,
  });

  factory BundleCategoryResponseModel.fromJson(Map<String, dynamic> json) {
    return BundleCategoryResponseModel(
      type: json["type"],
      title: json["title"],
      code: json["code"],
    );
  }

  bool get isCruise => type == "CRUISE";

  final String? type;
  final String? code;
  final String? title;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "type": type,
      "title": title,
      "code": code,
    };
  }
}
