# Flutter-specific ProGuard rules for better performance and smaller APK size

# Keep Flutter engine classes
-keep class io.flutter.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }

# Keep Media3 ExoPlayer classes for video playback
# The app uses androidx.media3 (not the old com.google.android.exoplayer2)
-keep class androidx.media3.** { *; }
-keep interface androidx.media3.** { *; }
-keepclassmembers class androidx.media3.** {
    *;
}
# Keep Media3 ExoPlayer internal classes
-keep class androidx.media3.exoplayer.** { *; }
-keep interface androidx.media3.exoplayer.** { *; }
# Keep Media3 decoder classes
-keep class androidx.media3.decoder.** { *; }
-keep interface androidx.media3.decoder.** { *; }
# Keep Media3 UI classes
-keep class androidx.media3.ui.** { *; }
-keep interface androidx.media3.ui.** { *; }
# Keep Media3 common classes
-keep class androidx.media3.common.** { *; }
-keep interface androidx.media3.common.** { *; }

# Keep codec-related classes for video playback on older devices
-keep class android.media.** { *; }
-keep class android.media.MediaCodec { *; }
-keep class android.media.MediaCodecInfo { *; }
-keep class android.media.MediaFormat { *; }

# Keep Dio and network-related classes
-keep class dio.** { *; }
-keep class retrofit2.** { *; }

# Keep model classes for JSON serialization
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Keep WebSocket classes
-keep class org.java_websocket.** { *; }

# Keep location services
-keep class com.google.android.gms.location.** { *; }

# Keep Google Maps classes
-keep class com.google.android.gms.maps.** { *; }

# General optimizations
-optimizationpasses 5
-dontusemixedcaseclassnames
-dontskipnonpubliclibraryclasses
-dontpreverify
-verbose

# Remove logging in release builds
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
}

# Optimize for size
-repackageclasses ''
-allowaccessmodification