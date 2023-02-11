import 'dart:ui';

import 'package:flutter/material.dart';

enum Place {
  UNKNOWN,
  ESIEE,
  Ampere_A,
  Ampere_B,
  Ampere_C,
  Campusea,
  Arago,
  Kley,
  Kley_2,
}

class PlaceUtils {
  static Color placeToColor(Place place) {
    switch (place) {
      case Place.UNKNOWN:
        return Colors.deepPurple;
      case Place.Ampere_A:
      case Place.Ampere_B:
      case Place.Ampere_C:
        return Colors.orangeAccent[200]!;
      case Place.Arago:
        return Colors.red;
      case Place.Kley:
        return Colors.blue;
      case Place.Kley_2:
        return Colors.blue;
      case Place.Campusea:
        return Colors.orangeAccent[100]!;
      case Place.ESIEE:
        return Colors.grey;
    }
  }

  static String placeToString(Place place) {
    switch (place) {
      case Place.ESIEE:
        return 'ESIEE';
      case Place.Ampere_A:
        return 'Olympère (Ampère) A';
      case Place.Ampere_B:
        return 'Olympère (Ampère) B';
      case Place.Ampere_C:
        return 'Olympère (Ampère) C';
      case Place.Arago:
        return 'Sparago (Arago)';
      case Place.Campusea:
        return 'Campusea';
      case Place.Kley:
        return 'Akleytide (Kley)';
      case Place.Kley_2:
        return 'Akleytide (Kley) 2';
      case Place.UNKNOWN:
        return 'UNKNOWN';
    }
  }
}
