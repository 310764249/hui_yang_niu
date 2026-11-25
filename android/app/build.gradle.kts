plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.saiente.intellectualbreed"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "28.2.13676358"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    // ✅ 分包支持
    splits {
        abi {
            isEnable = true
            reset()
            include("arm64-v8a")
            isUniversalApk = true
        }
    }

    packaging {
        jniLibs {
            useLegacyPackaging = true
        }
    }



    defaultConfig {
        applicationId = "com.saiente.intellectualbreed"
        minSdk = 24
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders.putAll(
            mutableMapOf(
                "JPUSH_PKGNAME" to applicationId!!,
                "JPUSH_APPKEY" to "262b2270982f4bc64145de1c",
                "JPUSH_CHANNEL" to "developer-default",
                "networkSecurityConfig" to "@xml/network_security_config"
            )
        )
    }

    signingConfigs {
        create("release") {
            storeFile = file("../intellectual_breed.jks")
            storePassword = "Saiente2023"
            keyAlias = "Saiente"
            keyPassword = "Saiente2023"
        }
    }
    packaging {
        jniLibs {
            pickFirsts.add("**/libc++_shared.so")
        }
    }
    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
            isShrinkResources = false
            signingConfig = signingConfigs.getByName("release")
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }

        getByName("debug") {
            isMinifyEnabled = false
            isShrinkResources = false
            signingConfig = signingConfigs.getByName("release")
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

dependencies {
    implementation(fileTree(mapOf("dir" to "libs", "include" to listOf("*.jar", "*.aar"))))
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
    implementation("com.huawei.hms:push:6.10.0.300")
    implementation("com.huawei.agconnect:agconnect-core:1.7.2.300")
}

flutter {
    source = "../.."
}
