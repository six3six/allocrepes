import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:order_repository/entities/place_entity.dart';

enum Place {
  UNKNOWN,
  Ampere_A,
  Ampere_B,
  Ampere_C,
  Arago,
  Kley,
  Kley_2,
  ESIEE,
}

class PlaceUtils {
  static Color placeToColor(Place place) {
    switch (place) {
      case Place.UNKNOWN:
        return Colors.deepPurple;
      case Place.Ampere_A:
      case Place.Ampere_B:
      case Place.Ampere_C:
        return Colors.blue;
      case Place.Arago:
        return Colors.red;
      case Place.Kley:
        return Colors.orange;
      case Place.Kley_2:
        return Colors.green;
      case Place.ESIEE:
        return Colors.grey;
    }
  }

  static String placeToString(Place place) {
    switch (place) {
      case Place.Ampere_A:
        return "Ampère A";
      case Place.Ampere_B:
        return "Ampère B";
      case Place.Ampere_C:
        return "Ampère C";
      case Place.Arago:
        return "Arago";
      case Place.Kley:
        return "Kley";
      case Place.Kley_2:
        return "Kley 2";
      case Place.ESIEE:
        return "ESIEE";
      case Place.UNKNOWN:
        return "UNKNOWN";
    }
  }
}
