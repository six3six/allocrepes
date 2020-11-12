import 'package:flutter/material.dart';

const Color primaryColor = Color(0xffeacdc2);
const Color accentColor = Color(0xffb79c92);
const Color lightColor = Color(0xfffffff5);

final theme = ThemeData(
// Define the default brightness and colors.
  brightness: Brightness.light,
  primaryColor: primaryColor,
  accentColor: accentColor,
  bottomAppBarColor: lightColor,

  visualDensity: VisualDensity.adaptivePlatformDensity,
);
