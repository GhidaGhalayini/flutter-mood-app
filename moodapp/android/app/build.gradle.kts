plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.moodapp"
    compileSdk = 34  // No semicolon here, and specifying the value directly
    ndkVersion = "27.0.12077973" // No semicolon here either
    compileSdk = 35
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.moodapp"
        minSdk = 21  // You can specify your own minSdk version
        targetSdk = 35
        versionCode = 1  // Specify your version code
        versionName = "1.0"  // Specify your version name
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
