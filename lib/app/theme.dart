import 'package:flutter/material.dart';

ThemeData getApplicationThemeData() {
  return ThemeData(
    colorScheme: ColorScheme.fromSwatch(
      // For OverScroll Glow Effect
      accentColor: const Color(0xFFF1F1F1),
    ),
    fontFamily: "Poppins",
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: const Color(0xFF111111),
    primaryColor: Colors.cyan,
    primaryColorLight: Colors.cyan[400],
    primaryColorDark: Colors.cyan[600],
    disabledColor: HexColor.fromHex("#707070"),
    useMaterial3: true,
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Colors.white54,
    ),
    appBarTheme: const AppBarTheme(
      surfaceTintColor: Colors.transparent,
      color: Color(0xFF111111),
      elevation: 0,
      shadowColor: Colors.transparent,
      titleTextStyle: TextStyle(
        fontFamily: "Poppins",
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.w400,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.cyan,
        textStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(8),
      hintStyle: const TextStyle(
        fontSize: 12,
        color: Colors.white10,
        fontWeight: FontWeight.normal,
      ),
      labelStyle: const TextStyle(
        fontSize: 12,
        color: Colors.white10,
        fontWeight: FontWeight.normal,
      ),
      errorStyle: TextStyle(
        fontSize: 12,
        color: Colors.red[400]!,
        fontWeight: FontWeight.normal,
      ),

      //Focus border
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.cyan[400]!, width: 5),
          borderRadius: const BorderRadius.all(Radius.circular(12))),
      // error border
      errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red[400]!, width: 5),
          borderRadius: const BorderRadius.all(Radius.circular(12))),
      focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.cyan[400]!, width: 5),
          borderRadius: const BorderRadius.all(Radius.circular(12))),
      // enabled border
      enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white10, width: 5),
          borderRadius: BorderRadius.all(Radius.circular(12))),
    ),
  );
}

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll('#', '');
    if (hexColorString.length == 6) {
      hexColorString = "FF$hexColorString"; // 8 char with opacity 100%
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}
