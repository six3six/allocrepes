import 'package:flutter/material.dart';

const Color primaryColor = Color(0xffa6ced3);
const Color primaryColorLight = Color(0xffd8ffff);
const Color primaryColorDark = Color(0xff769da2);
const Color accentColor = Color(0xff7b8b8d);
const Color lightColor = Color(0xfffffff5);
const Color blue = Color(0xffa6ced3);
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
