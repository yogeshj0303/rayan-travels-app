import 'package:flutter/material.dart';

class ThemeConstants {
  static const Color primaryOrange = Color(0xFFD88226);
  static const Color secondaryBlue = Color(0xFF0B192E);

  static BoxDecoration gradientBackground = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        secondaryBlue,
        secondaryBlue.withOpacity(0.8),
        secondaryBlue,
      ],
    ),
  );
}
