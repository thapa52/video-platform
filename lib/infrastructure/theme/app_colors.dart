import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color black = Color(0xff000000);
  static const Color white = Color(0xffffffff);
  static const Color offwhite = Color(0xffFDFDFD);

  /// Gray
  static const MaterialColor brand = MaterialColor(0xff8BC53F, {
    50: Color(0xffF3F9EC),
    100: Color(0xffE3f1d1),
    200: Color(0xffCDE6AC),
    300: Color(0xffB6DA86),
    400: Color(0xffA0CF62),
    500: Color(0xff8BC53F),
    600: Color(0xff76A736),
    700: Color(0xff638C2D),
    800: Color(0xff4F7024),
    900: Color(0xff3F591C),
  });

  /// Brand
  static const MaterialColor red = MaterialColor(0xffEC1C23, {
    50: Color(0xffFDE8E9),
    100: Color(0xffFAC9CA),
    150: Color(0xffF96264),
    200: Color(0xffF79DA0),
    300: Color(0xffF37074),
    400: Color(0xffEF454B),
    500: Color(0xffEC1C23),
    550: Color(0xFFE7000B),
    600: Color(0xffC9181E),
    700: Color(0xffA81419),
    800: Color(0xff871014),
    900: Color(0xff6A0D10),
  });

  /// Gray
  static const MaterialColor gray = MaterialColor(0xffECECEC, {
    50: Color(0xffFDFDFD),
    100: Color(0xffFAFAFA),
    200: Color(0xffF7F7F7),
    300: Color(0xffF3F3F3),
    400: Color(0xffEFEFEF),
    500: Color(0xffECECEC),
    600: Color(0xffC9C9C9),
    700: Color(0xffA8A8A8),
    800: Color(0xff878787),
    900: Color(0xff6A6A6A),
  });

  ///text
  static const MaterialColor text = MaterialColor(0xff6C6C6C, {
    50: Color(0xffF0F0F0),
    100: Color(0xffDCDCDC),
    200: Color(0xffC0C0C0),
    300: Color(0xffA2A2A2),
    400: Color(0xff868686),
    500: Color(0xff6C6C6C),
    600: Color(0xff5C5C5C),
    700: Color(0xff4D4D4D),
    800: Color(0xff3E3E3E),
    900: Color(0xff313131),
  });

  ///yellow
  static const MaterialColor yellow = MaterialColor(0xffFED402, {
    50: Color(0xffFFFBE6),
    100: Color(0xffFFF562),
    200: Color(0xffFFED92),
    300: Color(0xffFEE460),
    400: Color(0xffFEDC30),
    500: Color(0xffFED402),
    600: Color(0xffD8B402),
    700: Color(0xffB49701),
    800: Color(0xff917901),
    900: Color(0xff725F01),
  });

  //indigo
  static const MaterialColor skyblue = MaterialColor(0xff00AEEF, {
    50: Color(0xffE6F7FD),
    100: Color(0xffC2ECFB),
    200: Color(0xff91DCF8),
    300: Color(0xff5ECCF5),
    400: Color(0xff2EBDF2),
    500: Color(0xff00AEEF),
    600: Color(0xff0094CB),
    700: Color(0xff007CAA),
    800: Color(0xff006388),
    900: Color(0xff004E6C),
  });
}
