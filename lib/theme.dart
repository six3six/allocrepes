import 'package:flutter/material.dart';

const Color primaryColor = Color(0xffffdc81);
const Color primaryColorLight = Color(0xffffffb2);
const Color primaryColorDark = Color(0xffcaab52);
const Color accentColor = Color(0xff7b8b8d);
const Color lightColor = Color(0xfffffff5);
const Color blue = Color(0xff6bafb8);
const Color lightBlue = Color(0xffa7f5ff);

final theme = ThemeData(
// Define the default brightness and colors.
  brightness: Brightness.light,
  primaryColor: primaryColor,
  primaryColorLight: primaryColorLight,
  primaryColorDark: primaryColorDark,
  accentColor: accentColor,

  visualDensity: VisualDensity.adaptivePlatformDensity,
);
