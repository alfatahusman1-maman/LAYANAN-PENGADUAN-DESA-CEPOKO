pluginManagement {
    val flutterSdkPath = run {
        val localProperties = file("local.properties")
        require(localProperties.exists()) {
            "Flutter SDK belum tersambung. Jalankan flutter pub get terlebih dahulu."
        }
        localProperties.readLines()
            .firstOrNull { it.startsWith("flutter.sdk=") }
            ?.substringAfter("=")
            ?.trim()
            ?: error("flutter.sdk belum dicatat pada android/local.properties.")
    }
    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.11.1" apply false
    id("org.jetbrains.kotlin.android") version "2.2.20" apply false
}

include(":app")
