try {
    val processEnvironment = Class.forName("java.lang.ProcessEnvironment")
    val unmodifiableMapField = processEnvironment.getDeclaredField("theEnvironment")
    unmodifiableMapField.isAccessible = true
    @Suppress("UNCHECKED_CAST")
    val env = unmodifiableMapField.get(null) as? MutableMap<String, String>
    env?.remove("ANDROID_PREFS_ROOT")

    val caseInsensitiveEnvField = processEnvironment.getDeclaredField("theCaseInsensitiveEnvironment")
    caseInsensitiveEnvField.isAccessible = true
    @Suppress("UNCHECKED_CAST")
    val caseInsensitiveEnv = caseInsensitiveEnvField.get(null) as? MutableMap<String, String>
    caseInsensitiveEnv?.remove("ANDROID_PREFS_ROOT")
} catch (_: Throwable) {
}

pluginManagement {
    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
            flutterSdkPath
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
    id("com.android.application") version "9.1.0" apply false
    // START: FlutterFire Configuration
    id("com.google.gms.google-services") version("4.3.15") apply false
    // END: FlutterFire Configuration
    id("org.jetbrains.kotlin.android") version "2.4.0" apply false
}

include(":app")
