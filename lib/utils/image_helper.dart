import "dart:io";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:esim_open_source/utils/display_message_helper.dart";
import "package:flutter_image_compress/flutter_image_compress.dart";
import "package:gal/gal.dart";
import "package:share_plus/share_plus.dart";

Future<XFile?> compressImage(File file) async {
  final String filePath = file.absolute.path;
  final int lastIndex = filePath.lastIndexOf(RegExp(r".png|.jp"));
  final String splitted = filePath.substring(0, lastIndex);
  final String outPath = "${splitted}_out${filePath.substring(lastIndex)}";

  if (lastIndex == filePath.lastIndexOf(RegExp(r".png"))) {
    final XFile? compressedImage =
        await FlutterImageCompress.compressAndGetFile(
      filePath,
      outPath,
      minWidth: 500,
      minHeight: 500,
      quality: 50,
      format: CompressFormat.png,
    );
    return compressedImage;
  } else {
    final XFile? compressedImage =
        await FlutterImageCompress.compressAndGetFile(
      filePath,
      outPath,
      minWidth: 500,
      minHeight: 500,
      quality: 50,
    );
    return compressedImage;
  }
}

Future<dynamic> shareImage({required String imagePath}) async {
  if (imagePath.isNotEmpty) {
    await SharePlus.instance.share(
      ShareParams(
        files: <XFile>[XFile(imagePath)],
      ),
    );
  }
}

// Gal.putImage requests gallery access itself and throws GalException when access
// is denied or the save fails, so the success toast only shows after a real save.
Future<dynamic> saveImageToGallery({
  required String imagePath,
  String? toastMessage,
}) async {
  if (imagePath.isEmpty) {
    return;
  }

  try {
    await Gal.putImage(imagePath);
  } on GalException {
    DisplayMessageHelper.toast(LocaleKeys.image_save_failed.tr());
    return;
  }
  DisplayMessageHelper.toast(toastMessage ?? LocaleKeys.image_saved.tr());
}
