import 'package:flutter/material.dart';

const Color primaryColor = Color(0xffC69C6D);
const Color primaryColorLight = Color(0xffF3EFCC);
const Color primaryColorDark = Color(0xff42210B);

final theme = ThemeData(
// Define the default brightness and colors.
  brightness: Brightness.light,
  colorSchemeSeed: primaryColor,
  useMaterial3: true,
  scaffoldBackgroundColor: primaryColorLight,

  visualDensity: VisualDensity.adaptivePlatformDensity,
);

bool isBigScreen(BuildContext context){
  return MediaQuery.of(context).size.width >= 700;
}