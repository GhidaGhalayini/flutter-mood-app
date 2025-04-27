import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moodapp/screens/welcome_screen.dart';
import 'package:moodapp/database/db_utils.dart';

void main() {
  // Entry point of the application
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;  // Variable to track the current theme mode (light/dark)

  // Function to toggle between dark and light theme
  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;  // Toggle the theme mode
    });
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtilInit for responsive design and screen size adaptation
    return ScreenUtilInit(
      designSize: const Size(360, 690),  // Design size for screen adaptation
      minTextAdapt: true,  // Minimize text resizing on small screens
      splitScreenMode: true,  // Enable split screen support for larger devices
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,  // Hide the debug banner in the app
          title: 'Mood App',  // Title of the app
          theme: ThemeData.light(),  // Light theme configuration
          darkTheme: ThemeData.dark(),  // Dark theme configuration
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,  // Apply dark/light theme based on isDarkMode
          home: WelcomeScreen(
            // Passing the theme toggle function and current theme mode to the WelcomeScreen
            onToggleTheme: toggleTheme,
            isDarkMode: isDarkMode,
          ),
        );
      },
    );
  }
}
