import "dart:convert";

import "package:esim_open_source/utils/parsing_helper.dart";

/// title : "Refer Your Friends"
/// description : "Invite your friends to experience"
/// image : "https://oqonyfelpyoexoqlesic.supabase.co/storage/v1/object/public/media/banners-web/refer-your-friends.png"
/// action : "REFER_NOW"

class BannerResponseModel {
  BannerResponseModel({
    String? title,
    String? description,
    String? image,
    String? action,
  }) {
    _title = title;
    _description = description;
    _image = image;
    _action = action;
  }

  BannerResponseModel.fromJson({dynamic json}) {
    _title = json["title"];
    _description = json["description"];
    _image = json["image"];
    _action = json["action"];
  }

  String? _title;
  String? _description;
  String? _image;
  String? _action;

  BannerResponseModel copyWith({
    String? title,
    String? description,
    String? image,
    String? action,
  }) =>
      BannerResponseModel(
        title: title ?? _title,
        description: description ?? _description,
        image: image ?? _image,
        action: action ?? _action,
      );

  String? get title => _title;

  String? get description => _description;

  String? get image => _image;

  String? get action => _action;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["title"] = _title;
    map["description"] = _description;
    map["image"] = _image;
    map["action"] = _action;
    return map;
  }

  static List<BannerResponseModel> fromJsonList({dynamic json}) {
    return fromJsonListTyped(
      parser: BannerResponseModel.fromJson,
      json: json,
    );
  }

  static String toJsonListString(List<BannerResponseModel> models) {
    final List<Map<String, dynamic>> jsonList =
        models.map((BannerResponseModel model) => model.toJson()).toList();
    return jsonEncode(jsonList);
  }

  static List<BannerResponseModel> fromJsonListString(
    String jsonString,
  ) {
    final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
    return jsonList
        .map((dynamic json) => BannerResponseModel.fromJson(json: json))
        .toList();
  }
}
