import 'package:flutter/material.dart';

class AppRadius {
  AppRadius._();

  static const double s = 4.0;
  static const double m = 8.0;
  static const double l = 12.0;
  static const double xl = 16.0;
  static const double round = 999.0;

  static const BorderRadius borderS = BorderRadius.all(Radius.circular(s));
  static const BorderRadius borderM = BorderRadius.all(Radius.circular(m));
  static const BorderRadius borderL = BorderRadius.all(Radius.circular(l));
  static const BorderRadius borderXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius borderRound =
      BorderRadius.all(Radius.circular(round));
}
