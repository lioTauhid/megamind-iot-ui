import 'package:flutter/material.dart';

const Color primaryColor = Colors.blue;
const Color accentColor = Colors.blueAccent;
const Color secondaryColor = Colors.blueGrey;

Color primaryText = const Color(0xff1D1D1D);
Color textSecondary = const Color(0xff606060);
Color primaryBackground = const Color(0xffF1F4F8);
Color secondaryBackground = const Color(0xffFFFFFF);
// Color alternate = const Color(0xff434343);

const Color red = Color(0xffFB180D);
const Color white = Colors.white;
const Color black = Colors.black;

void applyThem(bool dark) {
  if (dark) {
    primaryText = const Color(0xffFFFFFF);
    textSecondary = const Color(0xffD9D9D9);
    primaryBackground = const Color(0xff121212);
    secondaryBackground = const Color(0xff262626);
    // alternate = const Color(0xff434343);
  } else {
    primaryText = const Color(0xff262626);
    textSecondary = const Color(0xff7B7B7B);
    primaryBackground = const Color(0xffF1F4F8);
    secondaryBackground = const Color(0xffFFFFFF);
    // alternate = const Color(0xffF5F5F5);
  }
}
