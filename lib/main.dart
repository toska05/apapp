import 'package:apapp/themes/app_theme.dart';
import 'package:apapp/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:apapp/auth/main_page.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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

  runApp(const ProviderScope(child:  const MyApp()));
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThemeState = ref.watch(appThemeStateNotifier);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: appThemeState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
    );
  }
}