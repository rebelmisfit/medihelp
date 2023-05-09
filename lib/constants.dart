import 'package:flutter/material.dart';
import 'package:medihelp/screens/home.dart';

const primaryColor = Color(0xFF375AB4);
const textColor = Color(0xFF35364F);
const backgroundColor = Color(0xFFE6EFF9);
const redColor = Color(0xFFE85050);

const defaultPadding = 16.0;

OutlineInputBorder textFieldBorder = OutlineInputBorder(
  borderSide: BorderSide(
    color: primaryColor.withOpacity(0.1),
  ),
);

const emailError = 'Enter a valid email address';
const requiredField = "This field is required";
