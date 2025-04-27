import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moodapp/constant/common_button.dart'; // Custom button widget
import 'package:moodapp/constant/constant.dart'; // Constant variables like colors
import 'package:moodapp/constant/text_widget.dart'; // Custom text widget
import 'package:moodapp/screens/joural_screen.dart'; // Journal screen
import 'package:page_transition/page_transition.dart'; // For page transition effects
import 'package:moodapp/database/database_helper.dart'; // Database helper for data handling

import '../database/database_helper.dart'; // Import the database helper

class UpdateDairyScreen extends StatefulWidget {
  final VoidCallback onToggleTheme; // Function to toggle theme between light and dark mode
  final bool isDarkMode; // Boolean flag to indicate if dark mode is enabled
  final String userName; // User's name to personalize greeting

  const UpdateDairyScreen({
    Key? key,
    required this.onToggleTheme, // Initialize the theme toggle function
    required this.isDarkMode, // Initialize dark mode flag
    required this.userName, // Initialize the user's name
  }) : super(key: key);

  @override
  State<UpdateDairyScreen> createState() => _UpdateDairyScreenState();
}

class _UpdateDairyScreenState extends State<UpdateDairyScreen> {
  int selectedIndex = 0; // To track the selected mood index
  late String currentDate; // Store the current date in the format 'Today - DD MMM'

  double stressLevel = 0; // Default stress level
  double selfEsteem = 0; // Default self-esteem level

  TextEditingController _descriptionController = TextEditingController(); // Controller for the description text field

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    currentDate = 'Today - ${_formatDate(now)}'; // Format the current date to display
  }

  // Function to save the mood data to the database
  void saveMoodData() async {
    String mood = moodList[selectedIndex].name ?? 'Unknown'; // Get the selected mood name
    Map<String, dynamic> moodData = {
      'date': currentDate,
      'mood': mood,
      'stressLevel': stressLevel,
      'selfEsteem': selfEsteem,
      'description': _descriptionController.text, // User's description of their state of mind
    };

    await DatabaseHelper.instance.insertMoodData(moodData); // Insert mood data into the database

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Mood data saved successfully!'),
      backgroundColor: Colors.green, // Show success message
    ));
  }

  // Helper function to format the date
  String _formatDate(DateTime date) {
    final day = date.day;
    final month = _monthName(date.month); // Get the month name
    return '$day $month';
  }

  // Helper function to get the month name from the month number
  String _monthName(int monthNumber) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[monthNumber - 1];
  }

  // Function to return the text color based on the theme (dark or light)
  Color getTextColor() {
    return widget.isDarkMode ? Colors.white : Colors.black;
  }

  // Function to return the secondary text color based on the theme (dark or light)
  Color getSecondaryTextColor() {
    return widget.isDarkMode ? Colors.white : Colors.black45;
  }

  // Custom widget to build a slider for stress level and self-esteem
  Widget buildSlider({
    required String title,
    required String lowLabel,
    required String highLabel,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            title,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: getTextColor(), // Set text color based on theme
          ),
          Slider(
            value: value,
            onChanged: onChanged, // Handle slider value change
            min: 0,
            max: 10,
            divisions: 10, // Divide the slider into 10 parts
            activeColor: kPurpleColor, // Active color of the slider
            inactiveColor: Colors.grey[300], // Inactive color of the slider
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(lowLabel, style: TextStyle(color: getSecondaryTextColor(), fontSize: 12.sp)),
              Text(highLabel, style: TextStyle(color: getSecondaryTextColor(), fontSize: 12.sp)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60.h), // Space at the top

            Padding(
              padding: EdgeInsets.only(right: 15.w),
              child: Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(
                    widget.isDarkMode ? Icons.dark_mode : Icons.light_mode, // Toggle icon based on theme
                    color: kPurpleColor,
                  ),
                  onPressed: widget.onToggleTheme, // Call the toggle theme function
                ),
              ),
            ),

            Align(
              alignment: Alignment.center,
              child: CustomText(
                currentDate, // Display current date
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: getSecondaryTextColor(),
              ),
            ),

            SizedBox(height: 30.h), // Add space

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0.w),
              child: CustomText(
                'Hello, ${widget.userName} 👋', // Personalized greeting
                fontWeight: FontWeight.bold,
                fontSize: 22.sp,
                color: getTextColor(),
              ),
            ),
            SizedBox(height: 10.h),

            Padding(
              padding: EdgeInsets.only(left: 15.0.w, right: 15.0.w, bottom: 25.h),
              child: CustomText(
                'How are you feeling today?', // Ask the user how they are feeling
                fontWeight: FontWeight.w500,
                fontSize: 20.sp,
                color: getTextColor(),
              ),
            ),

            SizedBox(
              height: 105.h,
              child: ListView.builder(
                itemCount: moodList.length, // Build a list of mood options
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index; // Set the selected mood
                      });
                    },
                    child: Container(
                      height: 105.h,
                      width: 105.w,
                      margin: EdgeInsets.only(left: index == 0 ? 15.w : 0.0, right: 15.w),
                      padding: EdgeInsets.all(15.r),
                      decoration: BoxDecoration(
                        color: selectedIndex == index ? kPurpleColor : kBackgroundColor, // Highlight the selected mood
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 45.h,
                            width: 45.h,
                            child: Image.asset(
                              'assets/images/${moodList[index].image}', // Display mood image
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          CustomText(
                            moodList[index].name!, // Display mood name
                            fontSize: 12.sp,
                            color: selectedIndex == index ? kWhiteColor : getSecondaryTextColor(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            buildSlider(
              title: 'Stress Level', // Slider for stress level
              lowLabel: 'Low',
              highLabel: 'High',
              value: stressLevel,
              onChanged: (val) => setState(() => stressLevel = val), // Update stress level
            ),
            buildSlider(
              title: 'Self-esteem level', // Slider for self-esteem level
              lowLabel: 'Insecurity',
              highLabel: 'Confidence',
              value: selfEsteem,
              onChanged: (val) => setState(() => selfEsteem = val), // Update self-esteem level
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0.w, vertical: 30.h),
              child: CustomText(
                'Describe your state of mind', // Prompt to describe state of mind
                fontWeight: FontWeight.w500,
                fontSize: 19.sp,
                color: getTextColor(),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0.w),
              child: TextField(
                controller: _descriptionController, // Text field for description
                minLines: 10,
                maxLines: 10,
                keyboardType: TextInputType.text,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  height: 1.6.h,
                  fontSize: 14.sp,
                ),
                autofocus: false,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: widget.isDarkMode ? Colors.grey[850] : kBackgroundColor, // Background color based on theme
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.r)),
                    borderSide: BorderSide.none,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),

            SizedBox(height: 25.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0.w),
              child: CustomButton(
                onTap: () {
                  saveMoodData(); // Save mood data when button is pressed
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.bottomToTop, // Transition to the next screen
                      duration: const Duration(milliseconds: 400),
                      child: JournalScreen(isDarkMode: widget.isDarkMode), // Navigate to journal screen
                    ),
                  );
                },
                text: 'Go to my journal',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
