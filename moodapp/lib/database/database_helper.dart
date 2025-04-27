import 'package:sqflite/sqflite.dart'; // For SQLite database operations
import 'package:path/path.dart'; // For managing file paths
import 'dart:async'; // For asynchronous operations
import 'package:crypto/crypto.dart'; // For password hashing
import 'dart:convert'; // For encoding data into UTF-8

// DatabaseHelper class for managing SQLite database operations
class DatabaseHelper {
  // Singleton pattern: Create only one instance of the DatabaseHelper
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database; // Holds the database instance

  // Private constructor for Singleton
  DatabaseHelper._init();

  // Getter for database - Initializes the database if not already done
  Future<Database> get database async {
    if (_database != null) return _database!; // Return existing DB if already created
    _database = await _initDB('moodApp.db'); // Otherwise, initialize the DB
    return _database!;
  }

  // Initializes the database with the given file name
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath(); // Get the default database path
    final path = join(dbPath, filePath); // Join the path with the database name
    return await openDatabase(path, version: 1, onCreate: _createDB); // Open or create the database
  }

  // Creates tables in the database when it's created for the first time
  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT'; // Primary key for auto-increment
    const textType = 'TEXT NOT NULL'; // Text field that cannot be null
    const realType = 'REAL NOT NULL'; // Real number (for floating-point numbers)

    // Create the 'users' table to store user information
    await db.execute(''' 
      CREATE TABLE users (
        id $idType,
        name $textType,
        email $textType,
        password $textType
      )
    ''');

    // Create the 'moodData' table to store mood-related data
    await db.execute(''' 
      CREATE TABLE moodData (
        id $idType,
        date $textType,
        mood $textType,
        stressLevel $realType,
        selfEsteem $realType,
        description $textType
      )
    ''');

    // Create the 'journal' table to store user journal entries
    await db.execute(''' 
      CREATE TABLE journal (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT UNIQUE,
        comment TEXT
      )
    ''');
  }

  // Insert a new user (for sign-up) into the 'users' table
  Future<void> insertUser(Map<String, dynamic> user) async {
    final db = await instance.database; // Get the database instance
    try {
      // Hash the user's password before storing it for security
      String hashedPassword = hashPassword(user['password']);
      user['password'] = hashedPassword;

      // Insert the user into the 'users' table
      await db.insert(
        'users',
        user,
        conflictAlgorithm: ConflictAlgorithm.replace, // Replace any existing user with the same data
      );
    } catch (e) {
      print("Error inserting user: $e"); // Print error if insertion fails
    }
  }

  // Retrieve a user by email and password (for login)
  Future<Map<String, dynamic>?> getUserByEmailAndPassword(String email, String password) async {
    final db = await instance.database; // Get the database instance
    final hashedPassword = hashPassword(password); // Hash the input password for comparison
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?', // Query for a matching email and hashed password
      whereArgs: [email, hashedPassword],
    );

    if (result.isNotEmpty) {
      return result.first; // Return the user data if found
    } else {
      return null; // Return null if no matching user is found
    }
  }

  // Insert mood data into the 'moodData' table
  Future<void> insertMoodData(Map<String, dynamic> moodData) async {
    final db = await instance.database; // Get the database instance
    try {
      // Insert the mood data into the 'moodData' table
      await db.insert(
        'moodData',
        moodData,
        conflictAlgorithm: ConflictAlgorithm.replace, // Replace any existing data if conflicts occur
      );
    } catch (e) {
      print("Error inserting mood data: $e"); // Print error if insertion fails
    }
  }

  // Insert or update a journal entry
  Future<void> insertOrUpdateJournal(String date, String comment) async {
    final db = await instance.database; // Get the database instance
    try {
      // Insert or update the journal entry for the given date
      await db.insert(
        'journal',
        {'date': date, 'comment': comment},
        conflictAlgorithm: ConflictAlgorithm.replace, // Replace any existing entry with the same date
      );
    } catch (e) {
      print("Error inserting/updating journal comment: $e"); // Print error if insertion fails
    }
  }

  // Hash a password using SHA-256 algorithm for secure storage
  String hashPassword(String password) {
    final bytes = utf8.encode(password); // Convert the password into bytes
    final digest = sha256.convert(bytes); // Generate SHA-256 hash of the password
    return digest.toString(); // Return the hashed password as a string
  }

  // Retrieve a journal comment for a specific date
  Future<String?> getJournalCommentByDate(String date) async {
    final db = await instance.database; // Get the database instance
    final result = await db.query(
      'journal',
      where: 'date = ?', // Query for a journal entry on the specified date
      whereArgs: [date],
    );

    if (result.isNotEmpty) {
      return result.first['comment'] as String?; // Return the comment if found
    } else {
      return null; // Return null if no comment is found for the date
    }
  }

  // Close the database connection when it's no longer needed
  Future<void> close() async {
    final db = await instance.database; // Get the database instance
    db.close(); // Close the database connection
  }
}
