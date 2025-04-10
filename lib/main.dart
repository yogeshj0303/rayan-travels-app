import 'package:driver_application/auth/splash_screen.dart';
import 'package:driver_application/screens/main_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DriverApplication());
}

class DriverApplication extends StatelessWidget {
  const DriverApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Driver Application',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashScreen(),
    );
  }
}
