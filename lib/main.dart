import 'dart:async';
import 'package:flutter/material.dart';
import 'pages/register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/login.dart';
import 'pages/poll.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  return runZonedGuarded(() async {
    runApp(const MyApp());
  }, ((error, stack) {
    print(error);
    print(stack);
  }));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RegisterPage(
        title: 'Register Page',
      ),
    );
  }
}
