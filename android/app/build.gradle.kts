plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.id_photo_maker"
    compileSdkVersion(flutter.compileSdkVersion)
    
    defaultConfig {
        applicationId = "com.example.id_photo_maker"
        minSdkVersion(flutter.minSdkVersion)
        targetSdkVersion(flutter.targetSdkVersion)
        versionCode = 1
        versionName = "1.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }
}

flutter {
    source = "../.."
}