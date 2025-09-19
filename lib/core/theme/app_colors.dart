import 'package:flutter/material.dart';

class AppColors {
  // Cores primárias baseadas no logo
  static const Color primary = Color(0xFF5D4065); // Roxo principal do logo
  static const Color primaryLight = Color(0xFF8B6BAA);
  static const Color primaryDark = Color(0xFF4A356A);

  // Cores secundárias
  static const Color secondary = Color(0xFFB19CD9);
  static const Color secondaryLight = Color(0xFFD1C4E9);
  static const Color secondaryDark = Color(0xFF9575CD);

  // Cores neutras
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color greyLight = Color(0xFFF5F5F5);
  static const Color greyDark = Color(0xFF424242);

  // Cores de estado
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE57373);
  static const Color warning = Color(0xFFFFB74D);
  static const Color info = Color(0xFF64B5F6);

  // Gradientes
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFFF8F6FC), Color(0xFFEDE7F6)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}