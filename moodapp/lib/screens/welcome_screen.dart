import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moodapp/constant/common_button.dart';
import 'package:moodapp/constant/constant.dart';
import 'package:moodapp/constant/text_widget.dart';
import 'package:moodapp/screens/SignInSignUpPage.dart';
import 'package:page_transition/page_transition.dart';

// WelcomeScreen widget that allows users to toggle themes and navigate to the SignIn/SignUp page.
class WelcomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;  // Function to toggle theme
  final bool isDarkMode;  // Boolean to check if dark mode is enabled

  const WelcomeScreen({
    Key? key,
    required this.onToggleTheme,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Full screen container for background decoration
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          // Gradient background based on theme (dark or light)
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: widget.isDarkMode
                ? [
              Colors.black,
              Colors.grey[900]!,
              Colors.grey[850]!,
              Colors.grey[800]!,
              Colors.grey[700]!,
            ]
                : const [
              kBlackColor,
              Color(0xff212023),
              Color(0xff2b2937),
              Color(0xff393652),
              Color(0xff4d4a7b),
              Color(0xff6762af),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section with theme toggle button
            SizedBox(height: 70.h),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(
                  widget.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: Colors.white,
                ),
                onPressed: widget.onToggleTheme,  // Call theme toggle function
              ),
            ),
            // Stack to overlay multiple elements (mood images)
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // Left and Right mood images at an angle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Left mood image with "cheerful" label
                    Transform.rotate(
                      angle: -0.25,
                      child: Container(
                        height: 180.h,
                        width: 140.w,
                        padding: EdgeInsets.all(20.r),
                        decoration: BoxDecoration(
                          color: kWhiteColor,
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/memoji_4.png',
                              height: 110.h,
                              fit: BoxFit.fill,
                            ),
                            SizedBox(height: 5.h),
                            CustomText(
                              'cheerful',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            )
                          ],
                        ),
                      ),
                    ),
                    // Right mood image with "Shocked" label
                    Transform.rotate(
                      angle: 0.25,
                      child: Container(
                        height: 180.h,
                        width: 140.w,
                        padding: EdgeInsets.all(20.r),
                        decoration: BoxDecoration(
                          color: kWhiteColor,
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/memoji_1.png',
                              height: 110.h,
                              fit: BoxFit.fill,
                            ),
                            SizedBox(height: 5.h),
                            CustomText(
                              'Shocked',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // Central mood image with box shadow
                Container(
                  height: 220.h,
                  width: 180.w,
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(
                    color: kWhiteColor,
                    borderRadius: BorderRadius.circular(25.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black45,
                        offset: Offset(0, 0),
                        blurRadius: 10,
                        spreadRadius: 3,
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/memoji_2.png',
                        height: 150.h,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(height: 5.h),
                      CustomText(
                        'cheerful',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 60.h),
            // Text section with mood app description and Sign In button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    'mood',
                    color: Colors.white,
                    fontSize: 50.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  CustomText(
                    'diary',
                    color: kWhiteColor.withOpacity(0.6),
                    fontSize: 50.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 30.h),
                  CustomText(
                    'Use the mood diary to track your state. Sign in to start your journey',
                    color: kWhiteColor.withOpacity(0.6),
                    fontSize: 13.sp,
                    height: 1.5,
                  ),
                  SizedBox(height: 50.h),
                  // Sign In button that navigates to SignIn/SignUp page
                  CustomButton(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.theme,
                          duration: Duration(seconds: 1),
                          child: const SignInSignUpPage(),
                        ),
                      );
                    },
                    text: 'Sign in',
                    color: kWhiteColor,
                    textColor: kPurpleColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
