import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Used for responsive sizing based on screen size
import 'package:moodapp/constant/constant.dart'; // Imports constant values (e.g., kPurpleColor)
import 'package:moodapp/constant/text_widget.dart'; // Imports CustomText widget for text styling

// CustomButton is a reusable button widget that allows customization of its appearance and behavior.
class CustomButton extends StatelessWidget {
  // Constructor to initialize the CustomButton with various optional parameters
  CustomButton({
    Key? key,
    required this.text,        // The text to display on the button
    this.height,              // The height of the button, default is 50.h (responsive sizing)
    this.width,               // The width of the button, optional parameter
    this.textColor,           // The color of the button's text, optional parameter
    this.color,               // The background color of the button, optional parameter
    required this.onTap,      // The callback function to be executed when the button is tapped
  }) : super(key: key);

  // Declare class properties for text, colors, dimensions, and onTap callback
  String text;
  Color? color;
  Color? textColor;
  double? height;
  double? width;
  VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // GestureDetector is used to detect taps and execute the onTap callback
    return GestureDetector(
      onTap: onTap, // Trigger the onTap callback when the button is tapped
      child: Container(
        width: width, // Set the width of the button
        height: height ?? 50.h, // Use provided height or default to 50.h if not specified
        decoration: BoxDecoration(
          color: color ?? kPurpleColor, // Use provided background color or default to kPurpleColor
          borderRadius: BorderRadius.all(Radius.circular(15.r)), // Rounded corners with a radius of 15.r
          boxShadow: [  // Add a shadow effect to give the button a 3D appearance
            BoxShadow(
              color: Colors.black26.withOpacity(0.16),  // Light shadow with opacity
              offset: Offset(0, 3.h),                   // Vertical offset for the shadow
              blurRadius: 6.0,                          // Blur radius for the shadow
              spreadRadius: 0.3,                        // Spread radius for the shadow
            ),
          ],
        ),
        // Center the text inside the button container
        child: Center(
          child: CustomText(  // CustomText widget is used to display the button text
            text,              // Pass the text to be displayed
            fontWeight: FontWeight.w500, // Set the font weight to 500 (medium)
            color: textColor ?? kWhiteColor, // Use provided text color or default to white
          ),
        ),
      ),
    );
  }
}
