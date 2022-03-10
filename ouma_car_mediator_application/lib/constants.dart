
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Basic Text Colors
const White = Color(0xFFFFFFFF);
const Black = Color(0xFF000000);
Color greenText = DarkGreenButton.withOpacity(0.5);

// Basic Gradient Colors
const Gradient1 = Color(0xFF3D663F); //90%
const Gradient2 = Color(0xFF006466); //72%

// Intro Pages Gradients: Black + Gradient1*90% + Gradient2*72%
const LinearGradient IntroPagesGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.2, 0.4, 0.9],
    colors: [Black, Gradient1, Gradient2]
);

// Registration Pages Gradients: DarkGreenButton*0% + White*0% + White*100%
const LinearGradient RegisterGradient = LinearGradient(
  begin:Alignment.topCenter,
  end:Alignment.bottomCenter,
  stops:[0.0,0.5],
  colors:[DarkGreenButton, White],
);

// Buttons Main Colors
const DarkGreenButton = Color(0xFF182F28); // used for icons as well
Color lightGreenButton = Gradient1.withOpacity(0.4);

// Fonts used
const MainTextFontEn = GoogleFonts.audiowide;
