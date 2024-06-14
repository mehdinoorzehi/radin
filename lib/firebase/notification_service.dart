import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../graphql/graphql_config.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

class NotificationService2 {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initialize() async {
    // Request permissions for iOS
    _firebaseMessaging.requestPermission();

    // Initialize Flutter Local Notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleMessage(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle when app is opened from notification
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    _handleMessage(message);
  }

  static Future<void> _handleMessage(RemoteMessage message) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    final String senderId = message.data['sender_id'];

    final QueryOptions options = QueryOptions(
      document: gql("""
        query GetSenderInfo(\$senderId: uuid!) {
          users_by_pk(id: \$senderId) {
            full_name
            profile_picture
          }
        }
      """),
      variables: {
        'senderId': senderId,
      },
    );

    final QueryResult result = await GraphQLConfig.client().query(options);

    if (result.hasException) {
      Fluttertoast.showToast(
        msg: "خطا در دریافت اطلاعات: ${result.exception.toString()}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }

    final senderInfo = result.data!['users_by_pk'];
    final String fullName = senderInfo['full_name'];
    final String profilePicture = senderInfo['profile_picture'];

    Uint8List? imageData;
    // ignore: unnecessary_null_comparison
    if (profilePicture != null && profilePicture.isNotEmpty) {
      // Get the image data from the network
      final response = await http.get(Uri.parse(profilePicture));
      if (response.statusCode == 200) {
        imageData = response.bodyBytes;
      }
    }

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      largeIcon: imageData != null
          ? ByteArrayAndroidBitmap(imageData)
          : const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
    );
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      fullName,
      message.data['content'],
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  void showNotification(
      String fullName, String content, String profilePicture) async {
    Uint8List? imageData;
    if (profilePicture.isNotEmpty) {
      final response = await http.get(Uri.parse(profilePicture));
      if (response.statusCode == 200) {
        imageData = response.bodyBytes;
      }
    }

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      largeIcon: imageData != null
          ? ByteArrayAndroidBitmap(imageData)
          : const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
    );
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0,
      fullName,
      content,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }
}
