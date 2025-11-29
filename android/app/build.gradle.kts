plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

import java.util.Properties
import java.io.FileInputStream

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.example.dooss_business_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "28.0.12674087"  // NDK r28+ required for 16KB page size support

    compileOptions {
        isCoreLibraryDesugaringEnabled = true 
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.onedoor.doos"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        
        // Support for 16KB page sizes (required for Android 15+)
        ndk {
            abiFilters += listOf("armeabi-v7a", "arm64-v8a", "x86", "x86_64")
        }
    }
    
    packaging {
        jniLibs {
            useLegacyPackaging = false
        }
    }

    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                val keyAlias = keystoreProperties["keyAlias"] as String?
                val keyPassword = keystoreProperties["keyPassword"] as String?
                val keystorePath = keystoreProperties["storeFile"] as String?
                val storePassword = keystoreProperties["storePassword"] as String?
                
                if (keyAlias != null && keyPassword != null && keystorePath != null && storePassword != null) {
                    this.keyAlias = keyAlias
                    this.keyPassword = keyPassword
                    // Normalize keystore path - handle both relative and absolute paths
                    // Path in key.properties might be relative to android/ directory
                    // build.gradle.kts is in android/app/, so we need to go up one level
                    val normalizedPath = if (keystorePath.contains("../app/")) {
                        keystorePath.replace("../app/", "")
                    } else {
                        keystorePath
                    }
                    // Only prepend "../" if path is relative and doesn't already start with "../"
                    val finalPath = if (normalizedPath.startsWith("/") || normalizedPath.startsWith("../")) {
                        normalizedPath
                    } else {
                        "../$normalizedPath"
                    }
                    this.storeFile = file(finalPath)
                    this.storePassword = storePassword
                }
            }
        }
    }


    buildTypes {
        getByName("release") {
            // Use release keystore if available, otherwise use debug signing
            val releaseSigningConfig = signingConfigs.findByName("release")
            if (releaseSigningConfig != null && releaseSigningConfig.storeFile != null && releaseSigningConfig.storeFile!!.exists()) {
                signingConfig = releaseSigningConfig
            } else {
                // Fallback to debug signing if no release keystore is configured
                signingConfig = signingConfigs.getByName("debug")
            }

            // Disable minification for now - enable after thorough testing
            // Note: For production, enable these after testing release builds
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Updated Media3 ExoPlayer for better compatibility with older devices (Galaxy Note 9)
    // Version 1.1.1 has better codec support for Android 8.0+ (API 26+)
    implementation("androidx.media3:media3-exoplayer:1.1.1")
    implementation("androidx.media3:media3-ui:1.1.1")
    implementation("androidx.media3:media3-common:1.1.1")
    // Add decoder for better codec support on older devices
    implementation("androidx.media3:media3-decoder:1.1.1")

    // Play Core library to fix missing classes in R8
      implementation("com.google.android.play:app-update:2.1.0")
    implementation("com.google.android.play:app-update-ktx:2.1.0")
    // - For In-App Reviews:
    implementation("com.google.android.play:review:2.0.0")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}
