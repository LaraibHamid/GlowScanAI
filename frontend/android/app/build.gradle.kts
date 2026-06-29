// ======================================================
// PLUGINS
// ======================================================

plugins {

    id("com.android.application")

    id("com.google.gms.google-services")

    id("kotlin-android")

    // Flutter Gradle Plugin
    // Must be applied AFTER Android & Kotlin plugins
    id("dev.flutter.flutter-gradle-plugin")
}



// ======================================================
// DEPENDENCIES
// ======================================================

dependencies {

    // --------------------------------------------------
    // Firebase Bill of Materials
    // --------------------------------------------------

    implementation(
        platform("com.google.firebase:firebase-bom:34.6.0")
    )

    // --------------------------------------------------
    // Add Firebase libraries here
    // Example:
    // implementation("com.google.firebase:firebase-auth")
    // implementation("com.google.firebase:firebase-firestore")
    // --------------------------------------------------

}



// ======================================================
// ANDROID CONFIGURATION
// ======================================================

android {

    namespace = "com.example.glowscanai_new"

    compileSdk = 35

    ndkVersion = "27.0.12077973"



    // --------------------------------------------------
    // JAVA / KOTLIN COMPATIBILITY
    // --------------------------------------------------

    compileOptions {

        sourceCompatibility = JavaVersion.VERSION_11

        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {

        jvmTarget = JavaVersion.VERSION_11.toString()
    }



    // --------------------------------------------------
    // DEFAULT CONFIG
    // --------------------------------------------------

    defaultConfig {

        // Unique Application ID
        applicationId = "com.example.glowscanai_new"

        // Minimum Android version supported
        minSdk = 23

        // Target Android version
        targetSdk = 34

        // App Version
        versionCode = 1
        versionName = "1.0"
    }



    // --------------------------------------------------
    // BUILD TYPES
    // --------------------------------------------------

    buildTypes {

        release {

            // Currently using debug signing
            // Replace with release keystore later

            signingConfig = signingConfigs.getByName("debug")
        }
    }
}



// ======================================================
// FLUTTER SOURCE
// ======================================================

flutter {

    source = "../.."
}
