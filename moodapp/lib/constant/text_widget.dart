import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // For responsive screen size adjustments
import 'package:moodapp/constant/constant.dart'; // Importing the constant colors defined elsewhere in the app

// CustomText widget is a reusable text widget with customizable styling
class CustomText extends StatelessWidget {
  String text; // The text to be displayed
  Color? color; // Optional parameter to define the text color, defaults to kBlackColor if not provided
  double? fontSize; // Optional parameter to define the font size, defaults to 14.sp if not provided
  double? height; // Optional parameter to define the line height for the text, defaults to 1.0.h if not provided
  String? fontFamily; // Optional parameter to specify the font family, defaults to 'Poppins'
  FontWeight? fontWeight; // Optional parameter to define the font weight, defaults to FontWeight.w400

  // Constructor with named optional parameters for customization
  CustomText(
      this.text, {
        this.color,
        this.fontSize,
        this.fontWeight,
        this.height,
        this.fontFamily,
        Key? key,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Building a Text widget with the provided or default style parameters
    return Text(
      text, // Display the provided text
      style: TextStyle(
        color: color ?? kBlackColor, // Use provided color or default to black
        fontFamily: fontFamily ?? 'Poppins', // Use provided font family or default to 'Poppins'
        height: height ?? 1.0.h, // Use provided height or default to 1.0.h
        letterSpacing: 0, // Set letterSpacing to 0 for standard spacing between letters
        fontSize: fontSize ?? 14.sp, // Use provided fontSize or default to 14.sp for responsive scaling
        fontWeight: fontWeight ?? FontWeight.w400, // Use provided font weight or default to regular weight
      ),
    );
  }
}
