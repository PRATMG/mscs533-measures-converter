import 'package:flutter/material.dart';

/// Minimal app-wide Material theme; we keep it neutral because the page
/// uses custom iOS tokens. Primary color is used by SnackBars, etc.
ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    colorSchemeSeed: const Color(0xFF3B5CCC),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  );
}
