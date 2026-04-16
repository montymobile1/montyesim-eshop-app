// ignore_for_file: avoid_single_cascade_in_expression_statements

import "dart:developer";
import "dart:io";

import "package:esim_open_source/data/services/local_notification_service.dart";
import "package:esim_open_source/domain/repository/services/push_notification_service.dart";
import "package:esim_open_source/main.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter_local_notifications/flutter_local_notifications.dart";

typedef HandlePushData = void Function({
  required bool isInitial,
  required bool isClicked,
  Map<String, dynamic>? handlePushData,
});

class PushNotificationServiceImpl implements PushNotificationService {
  PushNotificationServiceImpl._privateConstructor();

  static PushNotificationServiceImpl? _instance;
  static PushNotificationServiceImpl getInstance() {
    _instance ??= PushNotificationServiceImpl._privateConstructor();
    return _instance!;
  }

  HandlePushData? _handlePushData;

  static const String _channelID = "high_importance_channel"; // id
  static const String _channelTitle = "High Importance Notifications"; // title
  // static const String _channelDescription = "High Importance Notifications"; // title

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    _channelID, // id
    _channelTitle, // title
    importance: Importance.max,
  );

  @override
  Future<void> initialise({
    required void Function({
      required bool isClicked,
      required bool isInitial,
      Map<String, dynamic>? handlePushData,
    }) handlePushData,
  }) async {
    _handlePushData = handlePushData;
    await _requestPlatformPermissions();
    await _configureForegroundPresentation();
    _setupForegroundNotificationHandler();
    await _setupLocalNotificationListener();
    await _setupBackgroundAndInitialMessageHandlers();
  }

  Future<void> _requestPlatformPermissions() async {
    if (Platform.isIOS) {
      await _requestIOSPermission();
    } else if (Platform.isAndroid) {
      await _requestAndroidPermission();
    }
  }

  Future<void> _requestIOSPermission() async {
    final NotificationSettings settings = await _messaging.requestPermission();
    _logPermissionStatus(settings.authorizationStatus);
  }

  void _logPermissionStatus(AuthorizationStatus status) {
    if (status == AuthorizationStatus.authorized) {
      log("User granted permission");
    } else if (status == AuthorizationStatus.provisional) {
      log("User granted provisional permission");
    } else {
      log("User declined or has not accepted permission");
    }
  }

  Future<void> _requestAndroidPermission() async {
    final bool? accepted = await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    if (accepted ?? false) {
      log("User granted permission");
      await _setupAndroidNotificationChannel();
    } else {
      log("User declined or has not accepted permission");
    }
  }

  Future<void> _setupAndroidNotificationChannel() async {
    await LocalNotificationService.getInstance();
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  Future<void> _configureForegroundPresentation() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void _setupForegroundNotificationHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log("Got a message whilst in the foreground!");
      log("Message data: ${message.data}");

      if (message.notification != null) {
        log("Message also contained a notification: ${message.notification}");
        await _displayForegroundNotification(message);
      }
    });
  }

  Future<void> _displayForegroundNotification(RemoteMessage message) async {
    final RemoteNotification? notification = message.notification;
    final AndroidNotification? android = message.notification?.android;

    _serialiseAndNavigate(message.data, false, false);

    if (notification != null && android != null) {
      await _showAndroidNotification(notification, android, message.data);
    }
  }

  Future<void> _showAndroidNotification(
    RemoteNotification notification,
    AndroidNotification android,
    Map<String, dynamic> data,
  ) async {
    final Future<LocalNotificationService> localNotificationService = LocalNotificationService.getInstance();

    if (android.imageUrl != null) {
      await localNotificationService
        ..showBigPictureNotificationHiddenLargeIcon(
          id: notification.hashCode,
          iconURL: android.imageUrl!,
          largeIconURL: android.imageUrl!,
          title: notification.title,
          summaryText: notification.body,
          payload: data,
        );
    } else {
      await localNotificationService
        ..showBigTextNotification(
          id: notification.hashCode,
          title: notification.title,
          bigText: notification.body,
          summaryText: notification.body,
          payload: data,
        );
    }
  }

  Future<void> _setupLocalNotificationListener() async {
    final LocalNotificationService localNotificationService = await LocalNotificationService.getInstance();
    localNotificationService.selectNotificationSubject.stream.listen(
      (Map<String, dynamic>? payload) async {
        _serialiseAndNavigate(payload, false, true);
      },
    );
  }

  Future<void> _setupBackgroundAndInitialMessageHandlers() async {
    FirebaseMessaging.onBackgroundMessage(
      (RemoteMessage message) => _firebaseMessagingBackgroundHandler(
        message,
        false,
        true,
      ),
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) => _firebaseMessagingBackgroundHandler(
        message,
        false,
        true,
      ),
    );

    await _handleInitialMessage();
  }

  Future<void> _handleInitialMessage() async {
    final RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _firebaseMessagingBackgroundHandler(initialMessage, true, true);
    }
  }

  @override
  Future<String?> getFcmToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    log("FCM Token ====> $token");
    return token;
  }

  void _serialiseAndNavigate(
    Map<String, dynamic>? message,
    bool isInitial,
    bool isClicked,
  ) {
    log("Service: Push redirection triggered ==>> $message");
    _handlePushData?.call(
      handlePushData: message,
      isInitial: isInitial,
      isClicked: isClicked,
    );
  }
}

@pragma("vm:entry-point")
Future<void> _firebaseMessagingBackgroundHandler(
  RemoteMessage message,
  bool isInitial,
  bool isClicked,
) async {
  await initializeFirebaseApp();

  log("Handling a background message: ${message.messageId}");
  PushNotificationServiceImpl.getInstance()
    .._serialiseAndNavigate(message.data, isInitial, isClicked);
}
