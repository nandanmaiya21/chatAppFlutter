import 'dart:collection';

import 'package:chat/screens/auth_acreen.dart';
import 'package:chat/screens/chat.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:material_color_generator/material_color_generator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import './notificationservice/local_notification_service.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  LocalNotificationService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<FirebaseApp> future() async {
    WidgetsFlutterBinding.ensureInitialized();
    var f = Firebase.initializeApp();
    f.whenComplete(() => print('complete'));

    return f;
  }

  Widget app() {
    return MaterialApp(
      title: 'FlutterChat',
      theme: ThemeData(
        primarySwatch: generateMaterialColor(
            color: const Color.fromRGBO(157, 192, 139, 1)),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color.fromRGBO(157, 192, 139, 1),
          secondary: const Color.fromRGBO(96, 153, 102, 1),
          background: const Color.fromRGBO(237, 241, 214, 1),
          //brightness: Brightness.dark,
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            textStyle: const MaterialStatePropertyAll(
                TextStyle(color: Color.fromRGBO(96, 153, 102, 1))),
            padding: const MaterialStatePropertyAll(
                EdgeInsets.only(left: 20, right: 20)),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        textTheme: TextTheme(headlineLarge: TextStyle(color: Colors.white)),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            padding:
                MaterialStatePropertyAll(EdgeInsets.only(left: 20, right: 20)),
            backgroundColor:
                MaterialStatePropertyAll(Color.fromRGBO(96, 153, 102, 1)),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, userSnapShot) {
          if (userSnapShot.hasData) {
            return ChatScreen();
          }
          return AuthScreen();
        },
      ),
    );
  }

  Widget loading() {
    return MaterialApp(
      home: Scaffold(
          body: Center(
        child: CircularProgressIndicator(),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went worng!!');
          }

          return MaterialApp(
            home: Scaffold(
                body: Center(
              child: snapshot.connectionState == ConnectionState.done
                  ? app()
                  : loading(),
            )),
          );
        });
  }
}
