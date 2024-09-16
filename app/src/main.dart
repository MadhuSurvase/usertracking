import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tracksystem/registration.dart';
import 'package:tracksystem/trackingscreen.dart';

import 'firebase_options.dart';
import 'loginscreen.dart';

void main()async {
WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tracking System',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/register',
      routes: {
        '/register': (context) => RegistrationScreen(),
        '/login': (context) => LoginScreen(),
        '/tracking': (context) => TracingScreen(),
      },
    );
  }
}


