// db_utils.dart
import 'package:path_provider/path_provider.dart'; // Provides access to the device's file system
import 'dart:io'; // Provides File, Directory, and other I/O utilities
import 'package:sqflite/sqflite.dart'; // Needed for getDatabasesPath to retrieve database location

// Function to copy the database to the external storage (Downloads folder)
Future<void> copyDatabaseToDownloads() async {
  // Get the default path where the app's database is stored
  final dbPath = await getDatabasesPath();
  final path = '$dbPath/moodapp.db'; // Set the actual name of your database file here

  // Get the path to the external storage directory (Downloads folder on Android)
  final externalDir = await getExternalStorageDirectory();
  final newPath = '${externalDir!.path}/mood_tracker_copy.db'; // Define the new path for the copied database

  // Create a File object pointing to the database file at the original path
  final file = File(path);

  // Copy the database file to the new location
  await file.copy(newPath);

  // Print a confirmation message with the new path of the copied database
  print('Database copied to: $newPath');
}
