import 'package:flutter/material.dart';
import 'package:maid_app/screens/bottom_navigationbar.dart';
// import 'screens/onboarding_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color primaryPurple = Color(0xFF7D42F1);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ghra Saathi App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF7D42F1),
          primary: Color(0xFF7D42F1),
        ),
        useMaterial3: true,
      ),
      home: MainScreen(),
    );
  }
}
