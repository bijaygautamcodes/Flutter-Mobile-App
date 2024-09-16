import 'package:flutter/material.dart';

class RootNodeFontStyle {
  static TextStyle get title => const TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w700,
      overflow: TextOverflow.ellipsis,
      fontFamily: 'Poppins',
      height: 0,
      color: Colors.white70,
      decoration: TextDecoration.none);

  static TextStyle get header => const TextStyle(
      fontSize: 22.0,
      fontWeight: FontWeight.w600,
      overflow: TextOverflow.ellipsis,
      fontFamily: 'Poppins',
      height: 0,
      color: Colors.white70,
      decoration: TextDecoration.none);

  static TextStyle get body => const TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      fontFamily: 'Poppins',
      height: 1.8,
      color: Colors.white70,
      decoration: TextDecoration.none);
  static TextStyle get subtitle => const TextStyle(
      fontSize: 14.0,
      fontFamily: 'Poppins',
      overflow: TextOverflow.ellipsis,
      height: 0,
      fontWeight: FontWeight.w400,
      color: Colors.white70,
      decoration: TextDecoration.none);
  static TextStyle get caption => const TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
      fontFamily: 'Poppins',
      height: 0,
      color: Colors.white70,
      decoration: TextDecoration.none);
  static TextStyle get captionDefault => const TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
      fontFamily: 'Poppins',
      color: Colors.white70,
      decoration: TextDecoration.none);
  static TextStyle get label => const TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
      fontFamily: 'Poppins',
      height: 1.8,
      color: Colors.white54,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);
  static TextStyle get labelSmall => const TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.w300,
      fontFamily: 'Poppins',
      height: 0,
      color: Colors.white54,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);
}
