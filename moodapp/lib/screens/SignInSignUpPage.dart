import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moodapp/constant/text_widget.dart';
import 'package:moodapp/screens/update_diary_screen.dart';
import '../database/database_helper.dart';

class SignInSignUpPage extends StatefulWidget {
  const SignInSignUpPage({Key? key}) : super(key: key);

  @override
  State<SignInSignUpPage> createState() => _SignInSignUpPageState();
}

class _SignInSignUpPageState extends State<SignInSignUpPage> {
  // Boolean to toggle between Sign In and Sign Up
  bool _isSignIn = true;
  bool isDarkMode = false;

  // Text controllers for form inputs
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    // Dispose of controllers to free memory
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Function to toggle theme between light and dark mode
  void onToggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  // Function to validate form input and submit the form
  void _submitForm() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      // Display error message if email or password is empty
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Please fill all fields!"),
        backgroundColor: Colors.red,
      ));
    } else if (!_isSignIn && _nameController.text.isEmpty) {
      // Display error message if name is empty during Sign Up
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Please enter your name!"),
        backgroundColor: Colors.red,
      ));
    } else if (!_isSignIn && _passwordController.text != _confirmPasswordController.text) {
      // Display error message if passwords do not match during Sign Up
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Passwords do not match!"),
        backgroundColor: Colors.red,
      ));
    } else {
      if (_isSignIn) {
        // Check if user credentials are correct during Sign In
        final user = await DatabaseHelper.instance.getUserByEmailAndPassword(
          _emailController.text,
          _passwordController.text,
        );

        if (user != null) {
          // Successfully signed in
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text("Signed In successfully!"),
            backgroundColor: Colors.green,
          ));
          // Navigate to UpdateDairyScreen with user details
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => UpdateDairyScreen(
                onToggleTheme: onToggleTheme,
                isDarkMode: isDarkMode,
                userName: user['name'],
              ),
            ),
          );
        } else {
          // Invalid credentials
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text("Invalid credentials!"),
            backgroundColor: Colors.red,
          ));
        }
      } else {
        // Sign Up process
        final user = {
          'name': _nameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
        };
        await DatabaseHelper.instance.insertUser(user);

        // Successfully signed up
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Signed Up successfully!"),
          backgroundColor: Colors.green,
        ));

        // Navigate to UpdateDairyScreen with new user details
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UpdateDairyScreen(
              onToggleTheme: onToggleTheme,
              isDarkMode: isDarkMode,
              userName: _nameController.text,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Fetch current theme's brightness and colors
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final primaryTextColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;
    final fieldFillColor = isDark ? Colors.grey[900] : Colors.grey[200];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Colors.transparent,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryTextColor),
          onPressed: () {
            // Navigate back to UpdateDairyScreen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => UpdateDairyScreen(
                  onToggleTheme: onToggleTheme,
                  isDarkMode: isDarkMode,
                  userName: _nameController.text.isNotEmpty ? _nameController.text : 'Guest',
                ),
              ),
            );
          },
        ),
        title: CustomText(
          _isSignIn ? 'Sign In' : 'Sign Up',
          color: primaryTextColor,
          fontWeight: FontWeight.w600,
          fontSize: 16.sp,
        ),
      ),
      backgroundColor: bgColor,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 24.h),
                child: AnimatedOpacity(
                  opacity: 1.0,
                  duration: Duration(milliseconds: 800),
                  child: Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                      image: DecorationImage(
                        image: AssetImage('assets/images/logo.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),

              // Show name field during Sign Up only
              if (!_isSignIn)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: TextField(
                    controller: _nameController,
                    style: TextStyle(color: primaryTextColor),
                    decoration: InputDecoration(
                      hintText: 'Enter your name',
                      labelText: 'Name',
                      labelStyle: TextStyle(color: primaryTextColor),
                      hintStyle: TextStyle(color: primaryTextColor.withOpacity(0.6)),
                      filled: true,
                      fillColor: fieldFillColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                    ),
                  ),
                ),

              // Always show email field
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: TextField(
                  controller: _emailController,
                  style: TextStyle(color: primaryTextColor),
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    labelText: 'Email',
                    labelStyle: TextStyle(color: primaryTextColor),
                    hintStyle: TextStyle(color: primaryTextColor.withOpacity(0.6)),
                    filled: true,
                    fillColor: fieldFillColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                  ),
                ),
              ),

              // Password field
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: TextStyle(color: primaryTextColor),
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    labelText: 'Password',
                    labelStyle: TextStyle(color: primaryTextColor),
                    hintStyle: TextStyle(color: primaryTextColor.withOpacity(0.6)),
                    filled: true,
                    fillColor: fieldFillColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                  ),
                ),
              ),

              // Show confirm password field during Sign Up only
              if (!_isSignIn)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    style: TextStyle(color: primaryTextColor),
                    decoration: InputDecoration(
                      hintText: 'Confirm your password',
                      labelText: 'Confirm Password',
                      labelStyle: TextStyle(color: primaryTextColor),
                      hintStyle: TextStyle(color: primaryTextColor.withOpacity(0.6)),
                      filled: true,
                      fillColor: fieldFillColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                    ),
                  ),
                ),

              // Submit button
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                  ),
                  child: CustomText(
                    _isSignIn ? 'Sign In' : 'Sign Up',
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
              ),

              // Toggle between Sign In and Sign Up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    _isSignIn ? "Don't have an account?" : "Already have an account?",
                    fontSize: 14.sp,
                    color: primaryTextColor.withOpacity(0.7),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isSignIn = !_isSignIn;
                      });
                    },
                    child: CustomText(
                      _isSignIn ? 'Sign Up' : 'Sign In',
                      fontSize: 16.sp,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
