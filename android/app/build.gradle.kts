import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.example.obs_for_sama"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.papanguesoft.obsmanager"
        resValue("string", "app_name", "OBS Manager")
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String
        }
    }
    buildTypes {
        debug {
            signingConfig = signingConfigs.getByName("debug")
            // Le code ci-dessous est désactivé afin de donner la priorité au titre des flavors.
            // resValue("string", "app_name", "OBS Manager(Debug)")
        }
        release {
            signingConfig = signingConfigs.getByName("release")
            // On laisse dans tout les cas le titre pour la release
            resValue("string", "app_name", "OBS Manager")
        }
    }
    flavorDimensions += "default"
    productFlavors {
        create("getx") {
            dimension = "default"
            resValue(
                type = "string",
                name = "obsm_getx",
                value = "Flavors with getx")
//            applicationIdSuffix = ".getx"
            versionNameSuffix = "-getx"
            resValue("string", "app_name", "OBSM. GetX")
        }
        create("bloc") {
            dimension = "default"
            resValue(
                type = "string",
                name = "obsm_bloc",
                value = "Flavors with flutter bloc")
//            applicationIdSuffix = ".bloc"
            versionNameSuffix = "-bloc"
            resValue("string", "app_name", "OBSM. Bloc")
        }
    }
    androidComponents {
        onVariants { variant ->
            variant.outputs.forEach { output ->
                (output as? com.android.build.api.variant.impl.VariantOutputImpl)?.outputFileName?.set(
                    "obs-manager-${variant.name}.apk"
                )
            }
        }
    }
}

flutter {
    source = "../.."
}

