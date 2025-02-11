import 'package:apapp/themes/dark_mode.dart';
import 'package:apapp/themes/light_mode.dart';
import 'package:flutter/material.dart';
import 'package:apapp/auth/main_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: FirebaseOptions(
      apiKey: "AIzaSyA3FiBlBdEwonpf6aejKYIv-xMiKrAE3tE", 
      appId: "1:583574317109:android:ec0e876f4f79fba623e97c", 
      messagingSenderId: "583574317109", 
      projectId: "projectapapp",
    )
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
      theme: lightMode,
      darkTheme: darkMode,
    );
  }
}