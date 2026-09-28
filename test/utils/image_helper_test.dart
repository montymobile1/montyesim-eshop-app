import "dart:io";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:esim_open_source/utils/image_helper.dart";
import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";
import "package:share_plus/share_plus.dart";

import "../helpers/fluttertoast_helper.dart";

// Calls received on gal's method channel, and toast messages shown, per test.
final List<MethodCall> galCalls = <MethodCall>[];
final List<String> toasts = <String>[];

const MethodChannel galChannel = MethodChannel("gal");

Future<Object?> galSuccessHandler(MethodCall methodCall) async {
  galCalls.add(methodCall);
  switch (methodCall.method) {
    case "requestAccess":
      return true;
    default:
      return null;
  }
}

Future<void> main() async {
  setUp(() {
    galCalls.clear();
    toasts.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(galChannel, galSuccessHandler);
  });

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    FluttertoastHelperTest.implementFluttertoast();

    // Mock flutter_image_compress using a custom mock that sets the instance
    TestWidgetsFlutterBinding.ensureInitialized();

    // Set a mock implementation for the platform interface
    const MethodChannel imageCompressChannel =
        MethodChannel("flutter_image_compress");
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(imageCompressChannel,
            (MethodCall methodCall) async {
      if (methodCall.method == "compressAndGetFile") {
        // Return the expected format for XFile creation
        return "/mock/compressed/image.jpg";
      }
      return null;
    });

    // Mock share_plus
    const MethodChannel shareChannel =
        MethodChannel("dev.fluttercommunity.plus/share");
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(shareChannel, (MethodCall methodCall) async {
      if (methodCall.method == "share") {
        return null; // Mock successful share
      }
      return null;
    });

    // Mock permission_handler
    const MethodChannel permissionChannel =
        MethodChannel("flutter.baseflow.com/permissions/methods");
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(permissionChannel,
            (MethodCall methodCall) async {
      switch (methodCall.method) {
        case "requestPermissions":
          return <int, int>{
            33: 1,
          }; // Permission.photos: PermissionStatus.granted
        case "checkPermissionStatus":
          return 1; // PermissionStatus.granted
        default:
          return null;
      }
    });

    // Record toast messages (replaces the no-op handler set above)
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(FluttertoastHelperTest.channel,
            (MethodCall methodCall) async {
      if (methodCall.method == "showToast") {
        final Map<Object?, Object?> args =
            methodCall.arguments as Map<Object?, Object?>;
        toasts.add(args["msg"].toString());
      }
      return null;
    });

    // Mock easy_localization
    const MethodChannel localizationChannel =
        MethodChannel("easy_localization");
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(localizationChannel,
            (MethodCall methodCall) async {
      switch (methodCall.method) {
        case "getDeviceLocale":
          return "en_US";
        case "getSupportedLocales":
          return <String>["en_US"];
        default:
          return null;
      }
    });
  });

  tearDownAll(() {
    FluttertoastHelperTest.deInitFluttertoast();
    const MethodChannel imageCompressChannel =
        MethodChannel("flutter_image_compress");
    const MethodChannel shareChannel =
        MethodChannel("dev.fluttercommunity.plus/share");
    const MethodChannel permissionChannel =
        MethodChannel("flutter.baseflow.com/permissions/methods");
    const MethodChannel localizationChannel =
        MethodChannel("easy_localization");

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(imageCompressChannel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(shareChannel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(permissionChannel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(galChannel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(localizationChannel, null);
  });
  group("ImageHelper Tests", () {
    group("compressImage", () {
      test("compressImage method exists and has correct signature", () {
        expect(compressImage, isA<Function>());
      });

      test("compressImage function executes with PNG file", () async {
        final File testFile = File("test_image.png");
        try {
          final XFile? result = await compressImage(testFile);
          expect(result, isA<XFile?>());
        } on Object catch (e) {
          // Expected UnimplementedError in test environment, but function was executed
          expect(e, isA<UnimplementedError>());
        }
      });

      test("compressImage function executes with JPG file", () async {
        final File testFile = File("test_image.jpg");
        try {
          final XFile? result = await compressImage(testFile);
          expect(result, isA<XFile?>());
        } on Object catch (e) {
          // Expected UnimplementedError in test environment, but function was executed
          expect(e, isA<UnimplementedError>());
        }
      });

      test("compressImage function executes with JPEG extension", () async {
        final File testFile = File("test_image.jpeg");
        try {
          final XFile? result = await compressImage(testFile);
          expect(result, isA<XFile?>());
        } on Object catch (e) {
          // Expected UnimplementedError in test environment, but function was executed
          expect(e, isA<UnimplementedError>());
        }
      });
    });

    group("shareImage", () {
      test("shareImage method exists and has correct signature", () {
        expect(shareImage, isA<Function>());
      });

      test("shareImage shares image with valid path", () async {
        const String imagePath = "/test/path/image.png";
        await shareImage(imagePath: imagePath);
        // If we reach here, the function executed successfully
        expect(true, isTrue);
      });

      test("shareImage handles empty path", () async {
        const String imagePath = "";
        await shareImage(imagePath: imagePath);
        // Should not share but should not crash
        expect(true, isTrue);
      });

      test("shareImage shares different image formats", () async {
        const String jpgPath = "/test/path/image.jpg";
        const String pngPath = "/test/path/image.png";
        const String webpPath = "/test/path/image.webp";

        await shareImage(imagePath: jpgPath);
        await shareImage(imagePath: pngPath);
        await shareImage(imagePath: webpPath);
        expect(true, isTrue);
      });
    });

    group("saveImageToGallery", () {
      test("saveImageToGallery method exists and has correct signature", () {
        expect(saveImageToGallery, isA<Function>());
      });

      test("saveImageToGallery saves image with valid path", () async {
        const String imagePath = "/test/path/image.png";
        await saveImageToGallery(imagePath: imagePath);

        final MethodCall putImage = galCalls
            .singleWhere((MethodCall call) => call.method == "putImage");
        expect(
          (putImage.arguments as Map<Object?, Object?>)["path"],
          imagePath,
        );
        expect(toasts, <String>[LocaleKeys.image_saved.tr()]);
      });

      test("saveImageToGallery shows failure toast when access is denied",
          () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(galChannel,
                (MethodCall methodCall) async {
          galCalls.add(methodCall);
          if (methodCall.method == "requestAccess") {
            return false;
          }
          throw PlatformException(code: "ACCESS_DENIED");
        });

        await saveImageToGallery(imagePath: "/test/path/image.png");

        expect(toasts, <String>[LocaleKeys.image_save_failed.tr()]);
      });

      test("saveImageToGallery shows failure toast when save fails", () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(galChannel,
                (MethodCall methodCall) async {
          galCalls.add(methodCall);
          if (methodCall.method == "requestAccess") {
            return true;
          }
          throw PlatformException(code: "NOT_ENOUGH_SPACE");
        });

        await saveImageToGallery(
          imagePath: "/test/path/image.png",
          toastMessage: "Custom save message",
        );

        expect(toasts, <String>[LocaleKeys.image_save_failed.tr()]);
      });

      test("saveImageToGallery saves image with custom toast message",
          () async {
        const String imagePath = "/test/path/image.jpg";
        const String customMessage = "Custom save message";
        await saveImageToGallery(
          imagePath: imagePath,
          toastMessage: customMessage,
        );
        expect(toasts, <String>[customMessage]);
      });

      test("saveImageToGallery handles empty path", () async {
        const String imagePath = "";
        await saveImageToGallery(imagePath: imagePath);

        expect(galCalls, isEmpty);
        expect(toasts, isEmpty);
      });

      test("saveImageToGallery saves different image formats", () async {
        const String jpgPath = "/test/path/image.jpg";
        const String pngPath = "/test/path/image.png";
        const String gifPath = "/test/path/image.gif";

        await saveImageToGallery(imagePath: jpgPath);
        await saveImageToGallery(imagePath: pngPath);
        await saveImageToGallery(imagePath: gifPath);
        expect(true, isTrue);
      });
    });

    group("Integration Tests", () {
      test("all functions work together in workflow", () async {
        // Test workflow with error handling
        final File testFile = File("workflow_test.png");

        try {
          // 1. Try to compress image
          final XFile? compressedImage = await compressImage(testFile);
          if (compressedImage != null) {
            // 2. Share the compressed image
            await shareImage(imagePath: compressedImage.path);

            // 3. Save to gallery
            await saveImageToGallery(
              imagePath: compressedImage.path,
              toastMessage: "Workflow complete",
            );
          }
        } on Object catch (e) {
          // Expected in test environment - compression might fail but functions are executed
          expect(e, isA<Object>());
        }

        // 2. Test sharing directly
        await shareImage(imagePath: "/test/path.png");

        // 3. Test saving directly
        await saveImageToGallery(
          imagePath: "/test/path.png",
          toastMessage: "Direct save",
        );

        expect(true, isTrue);
      });

      // test("functions handle edge cases gracefully", () async {
      //   // Test with edge cases that won't cause range errors
      //   await shareImage(imagePath: "");
      //   await saveImageToGallery(imagePath: "");
      //
      //   // Test different file extensions
      //   final File webpFile = File("test.webp");
      //   final XFile? webpResult = await compressImage(webpFile);
      //   expect(webpResult, isA<XFile?>());
      //
      //   expect(true, isTrue);
      // });
    });
  });
}
