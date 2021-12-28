import 'package:flutter/material.dart';

Map<int, Color> salmonOpacity = {
  50: const Color.fromRGBO(255, 116, 101, .1),
  100: const Color.fromRGBO(255, 116, 101, .2),
  200: const Color.fromRGBO(255, 116, 101, .3),
  300: const Color.fromRGBO(255, 116, 101, .4),
  400: const Color.fromRGBO(255, 116, 101, .5),
  500: const Color.fromRGBO(255, 116, 101, .6),
  600: const Color.fromRGBO(255, 116, 101, .7),
  700: const Color.fromRGBO(255, 116, 101, .8),
  800: const Color.fromRGBO(255, 116, 101, .9),
  900: const Color.fromRGBO(255, 116, 101, 1),
};
MaterialColor salmon = MaterialColor(0xffFF7465, salmonOpacity);
ColorScheme appColorScheme = const ColorScheme(
    primary: Color(0xffFF7465),
    primaryVariant: Color(0xffFF7465),
    secondary: Colors.blue,
    secondaryVariant: Colors.blueAccent,
    surface: Colors.white,
    background: Colors.transparent,
    error: Colors.red,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Color(0xffFF7465),
    onBackground: Colors.grey,
    onError: Colors.white,
    brightness: Brightness.light);
