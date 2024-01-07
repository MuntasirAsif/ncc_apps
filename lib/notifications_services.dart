import 'dart:io';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ncc_apps/Full%20View/notification_screen.dart';
import 'package:ncc_apps/Users%20UI/home_screen.dart';
import 'package:ncc_apps/Users%20UI/news_feed.dart';
import 'package:ncc_apps/Users%20UI/profile_screen.dart';


class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  DatabaseReference ref = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: 'https://ncc-apps-47109-default-rtdb.firebaseio.com')
      .ref("user");


  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print("Permission granted");
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print("Permission granted");
      }
    } else {
      if (kDebugMode) {
        print("permission denied");
      }
    }
  }

  void initLocalNotifications(BuildContext context, RemoteMessage message)async{
    var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();
    var initializationSettings =InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );
    await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
      onDidReceiveNotificationResponse: (payload){
          handleMessage(context, message);
      }
    );
  }

  void firebaseInit(BuildContext context){
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        print(message.notification?.title.toString());
        print(message.notification?.body.toString());
        print(message.data['type'].toString());
        print(message.data['id'].toString());
      }
      if(Platform.isAndroid){
        initLocalNotifications(context, message);
        storeNotification(message);
        showNotifications(message);
      }else{
        storeNotification(message);
        showNotifications(message);
      }
    });
  }

  Future<void> showNotifications(RemoteMessage message)async{

    AndroidNotificationChannel channel=AndroidNotificationChannel(
        Random.secure().nextInt(1000).toString(),
        'High Importance Notifications',
      importance: Importance.max,
    );
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: 'Your channel description',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
      icon: '@mipmap/ic_launcher'
    );

    DarwinNotificationDetails darwinNotificationDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      presentBanner: true,
      presentList: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: darwinNotificationDetails,
    );
    Future.delayed(Duration.zero,(){
      _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title.toString(),
      message.notification?.body.toString(),
      notificationDetails);
    }
    );
  }

  Future<String> getDeviceToken()async{
    try {
      String? token = await messaging.getToken();
      if (token != null) {
        return token;
      } else {
        throw Exception('Failed to retrieve device token');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting device token: $e');
      }
      // Handle the error appropriately (e.g., show a message to the user)
      return '';
    }
  }

  void isTokenRefresh()async{
    messaging.onTokenRefresh.listen((event) {
      event.toString();
    });
  }

  Future<void> setInteractMessage(BuildContext context)async{

    //when app is terminated
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if(initialMessage!=null){
      handleMessage(context, initialMessage);
    }

    //when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }

  void handleMessage(BuildContext context, RemoteMessage message){
    final User? user = FirebaseAuth.instance.currentUser;
    final uId = user?.uid;
    if(message.data['type']=='post'){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>const NewsFeed(isAdmin: false)));
    }else if(message.data['type']=='Achievement'){
      Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
    }else if(message.data['type']=='comment'|| message.data['type']=='like'){
      Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfileScreen(isAdmin: false,  uid: uId.toString(),)));
    }else{
      Navigator.push(context, MaterialPageRoute(builder: (context)=> const NotificationScreen(isAdmin: false,)));
    }
  }
  storeNotification(RemoteMessage message){
    final User? user = FirebaseAuth.instance.currentUser;
    final uId = user?.uid;
    ref.child(uId.toString()).child('notifications').child(DateTime.now().microsecondsSinceEpoch.toString()).update({
      'title': message.notification?.title.toString(),
      'body' : message.notification?.body.toString(),
      'type' : message.data['type'].toString(),
    }).then((value) {
      if (kDebugMode) {
        print('Store Notifications');
      }
    }).onError((e, stackTrace) {
      if (kDebugMode) {
        print('Store Notifications Error $e');
      }
    });
  }

}
