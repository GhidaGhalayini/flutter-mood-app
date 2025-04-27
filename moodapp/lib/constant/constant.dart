import 'package:flutter/material.dart';
import 'package:moodapp/models/mood_model.dart'; // Importing the MoodType model to create mood objects

// Defining constant colors used throughout the app for consistency
const Color kBlackColor = Color(0xff1D1D1D); // Dark black color for text or background elements
const Color kPurpleColor = Color(0xff7A70DD); // Purple color used for buttons, accents, etc.
const Color kBackgroundColor = Color(0xfff0effd); // Light background color for the app's UI
const Color kWhiteColor = Color(0xFFF6F5FF); // Soft white color used for backgrounds or text
const Color kGreyColor = Color(0xFFb7b9c0); // Grey color used for secondary elements like text or dividers

// Creating a list of predefined moods, each with an image and a name
List<MoodType> moodList = [
  MoodType(image: 'happy-emoji.png', name: 'cheerful'), // Mood representing happiness
  MoodType(image: 'relaxed-emoji.png', name: 'relaxed'), // Mood representing relaxation
  MoodType(image: 'neutral-emoji.png', name: 'neutral'), // Mood representing neutrality
  MoodType(image: 'confused-emoji.png', name: 'confused'), // Mood representing confusion
];
