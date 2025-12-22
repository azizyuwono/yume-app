# Yume App - ProGuard Rules
# Keep rules for Flutter, Dart, and third-party packages

# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Dart
-keep class androidx.lifecycle.DefaultLifecycleObserver

# Dio (HTTP client)
-keep class com.google.gson.** { *; }
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn okio.**
-dontwarn javax.annotation.**
-keepnames class okhttp3.internal.publicsuffix.PublicSuffixDatabase

# Hive (Local storage)
-keep class * extends hive.** { *; }
-keep class hive.** { *; }
-keepclassmembers class * extends hive.HiveObject {
    <fields>;
}

# Cached Network Image
-keep class com.github.bumptech.glide.** { *; }

# Keep model classes (replace with your actual model package)
-keep class id.yumeapp.wallpaper.features.**.domain.** { *; }

# Preserve line numbers for better crash reports
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile

# If you're using Kotlin coroutines
-keepnames class kotlinx.coroutines.internal.MainDispatcherFactory {}
-keepnames class kotlinx.coroutines.CoroutineExceptionHandler {}
-dontwarn kotlinx.atomicfu.**

# General Android rules
-keepclassmembers class * implements android.os.Parcelable {
    static ** CREATOR;
}

# Google Play Core (often required by plugins even if not explicitly used)
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**
