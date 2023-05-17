import 'package:flutter/material.dart';

const Color primaryColor = Color(0xffa58c71);
const Color primaryColorLight = Color(0xffF3EFCC);
const Color primaryColorDark = Color(0xff42210B);

final theme = ThemeData(
// Define the default brightness and colors.
  brightness: Brightness.light,
  colorSchemeSeed: primaryColorLight,
  useMaterial3: true,

  visualDensity: VisualDensity.adaptivePlatformDensity,
);
